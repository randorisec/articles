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
Dispo [ici](https://github.com/randorisec/articles/blob/master/MISC76_Metasploit/emc.pl)

### Le module metasploit:
Dispo sur le github de [metasploit](https://github.com/rapid7/metasploit-framework/blob/master//modules/exploits/windows/emc/replication_manager_exec.rb) ou directement [ici](https://github.com/randorisec/articles/blob/master/MISC76_Metasploit/replication_manager_exec.rb)
