#import <AudioToolbox/AudioToolbox.h>
#include <CoreAudio/CoreAudioTypes.h>
#include <CoreAudioTypes/CoreAudioTypes.h>
#include <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#include <MacTypes.h>
#include <math.h>
#include <objc/objc.h>
#include <stdio.h>
#include <string.h>

#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioToolbox.h>
#import <ctype.h>
#import <stdio.h>

#include <AVFAudio/AVAudioSession.h>

// 1 buffer filling
// 1 buffer draining
// 1 buffer sitting in the middle as spare to account for any lag
#define kNumberOfRecordingBuffers 3
#define kBufferDurationInSeconds 0.5

struct s_recorder {
  CFStringRef file_name;
  AudioFileID file;
  AudioStreamBasicDescription record_format;
  SInt64 record_packet;
  BOOL is_running;
  AudioQueueRef queue;
  AudioQueueBufferRef buffers[kNumberOfRecordingBuffers];
};

/* Helper for error management */
void check_error(OSStatus error, const char *operation) {
  if (error == noErr) {
    return;
  }

  char errorString[20];
  *(UInt32 *)(errorString + 1) =
      CFSwapInt32HostToBig(error); // we have 4 bytes and we put them in
                                   // Big-endian ordering. 1st byte the biggest
  if (isprint(errorString[1]) && isprint(errorString[2]) &&
      isprint(errorString[3]) && isprint(errorString[4])) {
    errorString[0] = errorString[5] = '\'';
    errorString[6] = '\0';
  } else {
    sprintf(errorString, "%d", (int)error);
  }
  fprintf(stderr, "Error: %s (%s) - code %d\n", operation, errorString, error);
  exit(1);
}

typedef struct s_recorder t_recorder;

void setup_audio_format(t_recorder *recorder, UInt32 format_id) {
  memset(&recorder->record_format, 0, sizeof(AudioStreamBasicDescription));

  UInt32 size = sizeof(recorder->record_format.mSampleRate);
  check_error(
      AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate,
                              &size, &recorder->record_format.mSampleRate),
      "AudioSessionGetProperty - "
      "kAudioSessionProperty_CurrentHardwareSampleRate");

  printf("recorder->record_format.mSampleRate : %f\n",
         recorder->record_format.mSampleRate);

  size = sizeof(recorder->record_format.mChannelsPerFrame);
  check_error(AudioSessionGetProperty(
                  kAudioSessionProperty_CurrentHardwareInputNumberChannels,
                  &size, &(recorder->record_format.mChannelsPerFrame)),
              "AudioSessionGetProperty - "
              "kAudioSessionProperty_CurrentHardwareInputNumberChannels");

  recorder->record_format.mChannelsPerFrame = 1;
  printf("recorder->record_format.mChannelsPerFrame : %d\n",
         recorder->record_format.mChannelsPerFrame);

  recorder->record_format.mFormatID = format_id;
  if (format_id == kAudioFormatLinearPCM) {
    recorder->record_format.mFormatFlags =
        kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    recorder->record_format.mBitsPerChannel = 16;
    recorder->record_format.mBytesPerPacket =
        recorder->record_format.mBytesPerFrame =
            (recorder->record_format.mBitsPerChannel / 8) *
            recorder->record_format.mChannelsPerFrame;
    recorder->record_format.mFramesPerPacket = 1;
  }
}

// Compute size of buffer necessary to represent the supplied number of seconds
int compute_record_buffer_size(t_recorder *recorder,
                               const AudioStreamBasicDescription *format,
                               float seconds) {
  int packets, frames, bytes = 0;

  frames = (int)ceil(seconds * format->mSampleRate);

  if (format->mBytesPerFrame > 0) {
    bytes = frames * format->mBytesPerFrame;
  } else {
    UInt32 max_packet_size = 0;
    if (format->mBytesPerPacket > 0)
      max_packet_size = format->mBytesPerPacket;
    else {
      UInt32 property_size = sizeof(max_packet_size);
      check_error(
          AudioQueueGetProperty(recorder->queue,
                                kAudioQueueProperty_MaximumOutputPacketSize,
                                &max_packet_size, &property_size),
          "AudioQueueGetProperty kAudioQueueProperty_MaximumOutputPacketSize");
    }
    if (format->mFramesPerPacket > 0)
      packets = frames / format->mFramesPerPacket;
    else
      packets = frames;

    if (packets == 0)
      packets = 1;
    bytes = packets * max_packet_size;
  }
  return (bytes);
}

void input_buffer_handler(void *inUserData, AudioQueueRef inAQ,
                          AudioQueueBufferRef inBuffer,
                          const AudioTimeStamp *inStartTime,
                          UInt32 inNumPackets,
                          const AudioStreamPacketDescription *inPacketDesc) {
  t_recorder *in_recorder = (t_recorder *)inUserData;

  if (inNumPackets > 0) {
    check_error(AudioFileWritePackets(in_recorder->file, FALSE,
                                      inBuffer->mAudioDataByteSize,
                                      inPacketDesc, in_recorder->record_packet,
                                      &inNumPackets, inBuffer->mAudioData),
                "AudioFileWritePackets");
    in_recorder->record_packet += inNumPackets;
  }

  // if we're not stopping, re-enqueue the buffe so that it gets filled again
  if (in_recorder->is_running)
    check_error(AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL),
                "AudioQueueEnqueueBuffer");
}

void start_record(t_recorder *recorder, CFStringRef output_file) {
  int i = 0;
  int buffer_byte_size = 0;
  UInt32 size = 0;
  CFURLRef url = nil;

  recorder->file_name = CFStringCreateCopy(kCFAllocatorDefault, output_file);
  setup_audio_format(recorder, kAudioFormatLinearPCM);

  check_error(AudioQueueNewInput(&(recorder->record_format),
                                 input_buffer_handler, (void *)recorder, NULL,
                                 NULL, 0, &(recorder->queue)),
              "AudioQueueNewInput ");

  // get the record format back from the queue's audio converter --
  // the file may require a more specific stream description than was necessary
  // to create the encoder.
  recorder->record_packet = 0;
  size = sizeof(recorder->record_format);
  check_error(AudioQueueGetProperty(recorder->queue,
                                    kAudioQueueProperty_StreamDescription,
                                    &recorder->record_format, &size),
              "AudioQueueGetProperty kAudioQueueProperty_StreamDescription");

  NSString *record_file = [NSTemporaryDirectory()
      stringByAppendingPathComponent:(NSString *)output_file];

  NSLog(@"record_file %@\n", record_file);
  url = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)record_file,
                              NULL);

  // Creates audio file
  check_error(
      AudioFileCreateWithURL(url, kAudioFileCAFType, &recorder->record_format,
                             kAudioFileFlags_EraseFile, &recorder->file),
      "AudioFileCreateWithURL");
  CFRelease(url);

  buffer_byte_size = compute_record_buffer_size(
      recorder, &recorder->record_format, kBufferDurationInSeconds);
  for (i = 0; i < kNumberOfRecordingBuffers; i++) {
    check_error(AudioQueueAllocateBuffer(recorder->queue, buffer_byte_size,
                                         &recorder->buffers[i]),
                "AudioQueueAllocateBuffer");
    check_error(
        AudioQueueEnqueueBuffer(recorder->queue, recorder->buffers[i], 0, NULL),
        "AudioQueueEnqueueBuffer");
  }
  recorder->is_running = true;
  check_error(AudioQueueStart(recorder->queue, NULL), "AudioQueueStart");
}

void stop_recording(t_recorder *recorder) {
  recorder->is_running = false;
  check_error(AudioQueueStop(recorder->queue, true), "AudioQueueStop");

  if (recorder->file_name) {
    CFRelease(recorder->file_name);
    recorder->file_name = NULL;
  }
  AudioQueueDispose(recorder->queue, true);
  AudioFileClose(recorder->file);
}

int main() {

  @autoreleasepool {
    NSLog(@"setup recording");
    t_recorder recorder;
    memset(&recorder, 0, sizeof(t_recorder));

    start_record(&recorder, CFSTR("audio_file"));
    NSLog(@"Recording started... press any key to stop");

    getchar();
    NSLog(@"Stopping recording.");
    stop_recording(&recorder);

    NSLog(@"stopped");
  }

  return (0);
}
