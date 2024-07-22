Ce script de solution exploite plusieurs vulnérabilités du contrat HackMeIfYouCan. Chaque section décrit comment une fonction spécifique du contrat est exploitée pour obtenir des points.

Prérequis
Foundry : Assurez-vous que Foundry est installé et configuré.
Adresse du Contrat : Le contrat HackMeIfYouCan doit être déployé à l'adresse 0x9D29D33d4329640e96cC259E141838EB3EB2f1d9.
Clé Privée : Utilisez la clé privée de votre compte pour signer les transactions.

Remplir le .env: 

>PRIVATEKEY=0xd292fc320144aef5e067c6c2edff18384c6c4d1d7b7b74d091218160b24e250b
>WALLET_ADDRESS=0x4bc1cAEDBf984D34404C4D0BF2178DAB1a9Bf026
>SEPOLIA_RPC_URL=https://rpc2.sepolia.org/

sh
forge build
Exécution :
Exécutez le script avec la commande suivante :

sh
forge script script/HackMeIfYouCan.s.sol --tc HackMeIfYouCanSolution --rpc-url $SEPOLIA_RPC_URL --broadcast

Function flip explication : 
on récupére le hash du block précedant 
on le divise par le factor
et on a le résultat du coinflip qu'on insère dans la fonction flip 
il faut le faire 10x pour gagner le point

Function addpoint explication : 
On crée un proxy, pour intéragir avec la fonction car le tx.origin != msg.send

Function transfer explication : 
Transferer en mettant en argument l'adresse de destination + value

Function sendKey explication : 
Récupérer la key sur le contract avec la manipulation de slot 
ici la key est stocké dans le slot(16)

Function sendPassword explication : 
Récupérer le password sur le contract avec la manipulation de slot
ici la key esst sotkcé dnas le slot(3)