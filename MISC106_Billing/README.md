## Contournement API Google Play
*Article publié dans le MISC 106, libre de droits en juillet 2020*

### Auteur
Guillaume Lopes

### Synopsis
D'après le blog [INVESP], le montant global des paiements dits « in-app » représentaient environ 37 milliards de dollars (USD) en 2017 pour les applications mobiles (Android et Apple). Ce montant représente quasiment la moitié des revenus générés par les applications mobiles (48,2%), dépassant les revenus générés par les régies publicitaires (14%), ainsi que l'achat d'applications (37,8%). Il est donc important que la sécurité de ces paiements soit correctement implémentée afin d'éviter un manque à gagner pour les développeurs des applications. Dans le cadre de cet article, nous avons passé en revue 50 applications Android afin d'étudier le fonctionnement de l'API Google Play Billing et d'identifier les vulnérabilités liées à une mauvaise implémentation. Nous détaillerons en exemple des applications vulnérables.

### Mots-clés
ANDROID / GOOGLE / PLAY BILLING / PLAY STORE / IN-APP

### Remerciements
Un grand merci aux relecteurs : Davy Douhine, Clément Notin, Marc Lebrun et Benoit Baudry. 

### Les liens
[INVESP] : https://www.invespcro.com/blog/in-app-purchase-revenue/

[BILLINGDOC] : https://developer.android.com/google/play/billing/billing_overview

[PLAYCONSOLE] :https://developer.android.com/distribute/console

[VERIFY] : https://developer.android.com/google/play/billing/billing_library_overview#Verify

[PLAYDEV] : https://developers.google.com/android-publisher/

[PRIME31] : https://prime31.com/docs#androidIAB

[UNITY] : https://docs.unity3d.com/Manual/UnityIAPValidatingReceipts.html

[SCHURMANN] :https://www.schuermann.eu/2013/10/29/google-play-billing-hacked.html

[POC] : https://github.com/dschuermann/billing-hack

[PATCHER] : https://www.luckypatchers.com/

[SWINDLE] : https://www.mulliner.org/collin/publications/asia226-mulliner.pdf

[BILLINGTEST] : https://developer.android.com/google/play/billing/billing_testing.html

[MATOS] : https://www.securingapps.com/blog/BsidesLisbon17_AbusingAndroidInappBilling.pdf

[FRIDA] : https://www.frida.re/

[DNSPY] : https://github.com/0xd4d/dnSpy

[NDK] : https://developer.android.com/ndk/guides