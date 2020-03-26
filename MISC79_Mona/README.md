## Ramonage de vulns avec Mona
L'article au format [pdf](https://github.com/randorisec/articles/blob/master/MISC79_Mona/MISC79-Ramonage_de_vulns_avec_Mona.py-Davy_Douhine.pdf)

### Auteur
Davy Douhine

### Synopsis
Défini par Peter Van Eeckhoutte, son auteur, comme la boite à outils du développement d'exploit en environnement win32, mona.py [1] est un plugin qui fonctionne avec Immunity Debugger et WinDBG. Simple d'utilisation, il a l'énorme avantage de réunir les fonctionnalités de bon nombre d'autres outils tout en s'intégrant dans votre débogueur.
Plutôt que de présenter toutes ses possibilités unes par unes, nous allons à travers des exemples pratiques montrer comment il permet de gagner du temps lors de l'écriture d'exploits en environnement Windows.

### Remerciements
Merci à Alexandre, André (@andremoulu), Fred (@FredzyPadzy), Inti (@SalasRossenbach) Jérôme (JLeonard), l'équipe MISC (@MISCRedac), Mohamed, Peter (@corelanc0d3r), Saâd (@_saadk) et Thomas pour la relecture et l'inspiration.

### Les liens
[1] https://github.com/corelan/mona

[2] https://www.corelan.be/index.php/2009/07/19/exploit-writing-tutorial-part-1-stack-based-overflows/

[3] https://www.corelan.beHYPERLINK "https://www.corelan.be/index.php/2009/07/23/writing-buffer-overflow-exploits-a-quick-and-basic-tutorial-part-2/"/index.php/2009/07/23/writing-buffer-overflow-exploits-a-quick-and-basic-tutorial-part-2/

[4] https://www.corelan.be/index.HYPERLINK "https://www.corelan.be/index.php/2009/07/25/writing-buffer-overflow-exploits-a-quick-and-basic-tutorial-part-3-seh/"php/2009/07/25/writing-buffer-overflow-exploits-a-quick-and-basic-tutorial-part-3-seh/

[5] https://www.hackinparis.com/slides/hip2k11/04-ProjectQuebec.pdf

[6] https://www.corelan.be/index.php/2010/01/26/starting-to-write-immunity-debugger-pycommands-my-cheatsheet/

[7] http://www.vmware.com/fr/products/player

[8] https://github.com/corelan/windbglib

[9] http://www.exploit-db.com/exploits/35177

[10] http://www.exploit-db.com/exploits/31643

[11] https://community.rapid7.com/community/metasploit/blog/2014/12/09/good-bye-msfpayload-and-msfencode

[12] https://github.com/MISCMag/MISC-79

[13] https://www.corelan.be/index.php/2010/06/16/exploit-writing-tutorial-part-10-chaining-dep-with-rop-the-rubikstm-cube/

### L'exploit iftp.py (chapitre 4.3)
Dispo [ici](https://github.com/randorisec/articles/blob/master/MISC79_Mona/iftp.py)

### L'exploit easy.py (chapitre 4.4)
Dispo [ici](https://github.com/randorisec/articles/blob/master/MISC79_Mona/easy.py)

### Cheatsheet mona.py
Toutes les commandes sont à préfixer de:
- ```!mona``` pour ImmunityDbg

- ```!py``` mona pour WinDBG

|**Configuration**||
|---|---|
|```config -set workingfolder c:\logs\%p```|définir le répertoire utilisé par mona pour les logs
|```config -get workingfolder```|afficher le répertoire utilisé par mona pour les logs
|```config –set excluded_modules “module1.dll,module2.dll”```|exclure des librairies des recherches (ex: « virtual guest additions »).
|```config –add excluded_modules “module3.dll”```|ajouter des librairies à exclure des recherches
|**Recherches**||
|```findmsp```|cherche un motif cyclique
|```jmp -r esp -n```|cherche un saut vers ESP en excluant les adresses contenant un octet « null »
|```find -s "\x68\x63\x61\x6C\x63"```|cherche une suite d’octets
|```find -s "calc"-type asc```|cherche des caractères ASCII
|```find -s '\xFF\xFF\xFF\xFF\xFF'-x RW```|cherche une suite d’octets pour lesquels les adresses possèdent le niveau d’accès demandé (ici RW)
|```find –s “retn” –type instr –m audconv.dll –cpb '\x0a\x3d'```|cherche l’instruction “RETN” dans le module spécifié en excluant les pointeurs qui contiennent les octets spécifiés par -b
|```findwild -s "xchg eax,esi#*#retn"–m audconv.dll```|cherche la suite d’instruction qui commence par XCHG et qui termine par RETN dans le module spécifié
|```stackpivot```|cherche des pointeurs pour pivoter sur la pile
|```ropfunc```|cherche des pointeurs vers les fonctions permettant de contourner le DEP
|```rop```|cherche des gadgets pour contourner le DEP
|**Points d’arrêt (breakpoints)**||
|```bpseh```|positionne un BP sur chaque SEH
|```bp –t READ –a 77c35459```|positionne un BP en lecture
|```bp –t WRITE –a 0012F4C4```|positionne un BP en écriture
|```bf –t ADD –f import –s *VirtualProtect* -m easycdda.exe```|positionne un BP sur l’adresse définie dans l’IAT de easycdda.exe qui matche sur la fonction *VirtualProtect*
|**Divers**||
|```update```|mise à jour
|```assemble -s "ADD ESP,0C10 # RETN 0x04"```|convertit des instructions (séparées par #) en opcode
|```bytearray -b '\x00'```|génère un tableau d'octets pour la recherche de mauvais caractères
|```pc 1000```|génère un motif cyclique
|```skeleton```|génère un squelette de module metasploit
|```suggest```|génère un squelette de module metasploit (à lancer après avoir provoqué un crash de l'appli avec un motif cyclique)
|```stacks```|affiche les piles du processus
|```heap –h default –t layout```|affiche un aperçu global du tas
|```dumpobj -a 0x00000000 -l 1```|affiche et tente d'identifier un objet (seulement avec WinDBG)
|```geteat```|affiche la EAT (Export Address Table)
|```getiat -s kernel32```|affiche uniquement les fonctions qui contiennent la chaine de caractère “kernel32” dans l'IAT (Import Address Table)
