## Auditer la sécurité des applications iOS
L'article complet [ici](https://connect.ed-diamond.com/MISC/misc-091/auditer-la-securite-d-une-application-ios-avec-needle)
### Auteur
Davy Douhine

### Synopsis
Auditer la sécurité d'une application iOS n'est toujours pas une tâche aisée. Force est de constater que la plupart des auditeurs, amateurs de bug bounty ou autres curieux préfèrent travailler sur les applications Android malgré les récentes protections ajoutées au système d'exploitation de Google. Nous allons malgré tout essayer de présenter une méthodologie qui rend possible l'analyse orientée sécurité d'une application iOS, même sans jailbreak. Un bref rappel sera effectué pour ensuite introduire quelques outils et documentations apparues ces derniers mois.

### Mots-clés
IOS, AUDIT, APPLICATION, MOBILE, FRIDA, CYCRIPT, CHARLES PROXY, RVICTL

### Remerciements
Merci à Guillaume pour la relecture.

### Les liens
[miscmag91] https://connect.ed-diamond.com/MISC/MISC-091/Auditer-la-securite-d-une-application-iOS-avec-Needle

[marco] https://twitter.com/lancinimarco/status/955206373041680385

[githubneedle] https://github.com/mwrlabs/needle/issues/212

[owasp_testing_guide] https://www.owasp.org/index.php/OWASP_Testing_Project

[mahh] http://eu.wiley.com/WileyCDA/WileyTitle/productCd-1118958500.html

[uncover] https://github.com/pwn20wndstuff/Undecimus

[chimera] https://chimera.sh/

[xnuqemu] https://worthdoingbadly.com/xnuqemu/

[iosqemu] https://alephsecurity.com/2019/06/17/xnu-qemu-arm64-1/

[miscmag92] https://connect.ed-diamond.com/MISC/MISC-092/Frida-le-couteau-suisse-de-l-analyse-dynamique-multiplateforme

[objc-method-observer] https://codeshare.frida.re/@mrmacete/objc-method-observer/

[bfdecrypt] https://github.com/BishopFox/bfdecrypt

[ipapatch] https://github.com/Naituw/IPAPatch

[resign] https://github.com/vtky/resign

[demo-cycript] https://github.com/Naituw/IPAPatch/releases/tag/1.0.1

[l3tjg] https://level3tjg.github.io/

[objection] https://github.com/sensepost/objection

[sslkillswitch2] https://github.com/nabla-c0d3/ssl-kill-switch2

[fridasslbypass] https://codeshare.frida.re/@lichao890427/ios-ssl-bypass/

[charlesproxy] https://apps.apple.com/app/charles-proxy/id1134218562

[rvi_capture] https://github.com/gh2o/rvi_capture

[impactor] http://www.cydiaimpactor.com/
