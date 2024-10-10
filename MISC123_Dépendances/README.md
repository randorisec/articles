## Le bourbier des dépendances : confusion et sabotage
L'article en complet [ici](https://connect.ed-diamond.com/misc/misc-123/le-bourbier-des-dependances-confusion-et-sabotage)

### Auteur
Florent Bayar-Oudet

### Synopsis
Lors du développement d'une application, un développeur va intégrer des dépendances tierces à son projet. Ces dépendances peuvent provenir de dépôts publics ou internes à l'entreprise. Les différents langages de programmation fournissent des gestionnaires de paquets pour faciliter l'installation et la mise à jour de ces dépendances (pip pour Python ou npm pour JavaScript par exemple). La confiance accordée à ces gestionnaires de paquets ouvre la voie à un nouveau type d'attaque permettant à un attaquant d'installer des dépendances malveillantes au sein du système d'information d'une entreprise. Cet article présente la possibilité de corrompre la chaîne d'approvisionnement (supply chain) d'un projet via ses dépendances privées, dont la sécurité est rarement remise en question.

### Les liens
[1] Article original du chercheur Alex Birsan : https://medium.com/@alex.birsan/dependency-confusion-4a5d60fec610

[2] Article discutant des différentes problématiques de cette attaque avec npm : https://snyk.io/blog/detect-prevent-dependency-confusion-attacks-npm-supply-chain-security/

[3] Outil permettant de détecter les paquets JavaScript vulnérables avec npm : https://GitHub.com/snyk-labs/snync

[4] Article de Jfrog Artifactory sur la remédiation pour cette vulnérabilité : https://jfrog.com/blog/going-beyond-exclude-patterns-safe-repositories-with-priority-resolution/

[5] Détail de la configuration d’une règle de routage pour Sonatype : https://help.sonatype.com/repomanager3/nexus-repository-administration/repository-management/routing-rules

[6] Réserver un préfix sur nuget.org : https://docs.microsoft.com/en-us/nuget/nuget-org/id-prefix-reservation

[7] Détails des faits pour le sabotage de node-ipc : https://snyk.io/blog/peacenotwar-malicious-npm-node-ipc-package-vulnerability/

[8] Outil Socket pour analyser le changement de code des dépendances en JavaScript : https://socket.dev/
