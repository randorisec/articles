ARCH_FLAGS=-arch arm64
NAME=evil_mic_recorder
SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/
SOURCES:= main.m
CFLAGS= -I.
LDFLAGS=-framework Foundation -framework AudioToolBox -framework Security -framework AVFAudio


default: build

build: $(SOURCES)
	xcrun -sdk iphoneos clang -o $(NAME) $(ARCH_FLAGS) -lobjc $(LDFLAGS) -isysroot $(SDKROOT)  $(CFLAGS) $(SOURCES) 
	ldid -Sentitlements.plist $(NAME)
