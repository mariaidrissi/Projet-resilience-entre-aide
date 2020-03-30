# NOTE DE CLARIFICATION
Projet Résilience NA17

## Contexte
Dans le cadre de l'uv NA17, les groupes de projets sont chargés de travailler sur le projet Résilience qui a pour but de créer une interface d'entraide et d'échange entre plusieurs personnes et communautés. Le projet permettra à chaque personne de pouvoir rajouter une communauté à la base de données, ajouter des liens entre les personnes ou entre les communautés, gérer les informations d'une communauté. L'objectif est que les personnes puissent rajouter des services et des savoirs-faires pour s'entraider entre communauté avec ou sans contrepartie. Les personnes pourront également s'échanger des messages et renseigner leur coordonnées géographiques.  

## Données d'entrée
Le sujet du projet ainsi que le cadre et les détails sur les livrables sont détaillés sur le librecours :
* https://librecours.net/exercice/projet/resilience.xhtml
* https://librecours.net/exercice/projet/cadre.xhtml
* https://librecours.net/exercice/projet/livrables.xhtml

Des informations additionnelles pourront préciser le cadre du projet sur [l'espace d'échange Mattermost](https://team.picasoft.net/nx1718-20p/channels/na17)

## Objet du projet
Le but du projet est d'implémenter le réseau Résilience tel que décrit [dans le README](/README.md)

## Produit du projet
La version 1 intégrera les livrables suivants :
* README (avec les noms des membres du groupe)
* NDC
* MCD
* MLD relationnel
* BBD : base de données, données de test, questions attendues (vues)

La version 2 intégrera les livrables suivants :
* README (avec les noms des membres du groupe)
* NDC
* MCD
* MLD non-relationnel
* BBD : base de données, données de test, questions
* Application Python

Note : la base de données relationnelle sera réalisée avec PostgreSQL.

## Objectifs visés
Les livrables devront être rendus suivant le déroulement du semestre pour NA17 (voir page [Séquences](https://librecours.net/parcours/na17/sequences.html) sur le librecours).

La page [Cadre du projet](https://librecours.net/exercice/projet/cadre.xhtml) du librecours détaille la volumétrie attendue pour un groupe de 3 :
* 9 Classes : Personne, Communauté, Lien, PourContre, Savoir-faire, Service, Message, Compte, Coordonnées Géographiques
* 9 Associations 1:N 
* 3 Associations N:M
* 30 Attributs 
* 3 Vues : 
 1. Vue communauté : donne la liste des communautés auxquelles une personne appartient avec un booléen.
 2. Vue message : pour visualiser chaque message en ajoutant l'identifiant du message d'origine lorsque le message s'inscrit dans un fil historique.
 3. Vue proches: pour visualiser les communautés et personnes proches de chaque personne et communauté (moins de 1km)

Il est précisé que
* **Le code informatique doit s'exécuter correctement**. Il doit être lisible, ses conditions de test et d'exécution doivent être simples et documentées. Il n'est pas acceptable qu'un code ne s'exécute pas du tout.
* **La documentation doit être correctement rédigée et présentée en français (ou en anglais)**. Il n'est pas acceptable qu'un document réalisé à plusieurs en temps non limité ne soit pas correct.


## Acteurs du projet
Les trois membres de l'équipe 2 NA17 sont chargés de la réalisation : Clément DUPUIS, Matthieu GLORION et Maria IDRISSI.

Stéphane Crozat est chargé de la correction.

## Contraintes à respecter
Les délais de rendu des livrables sont déjà déterminés sur la plateforme librecours : 
* Semaine 4 : note de clarification
* Semaine 5 : projet en version 1 (readme, ndc, mcd, mld relationnel, bdd)
* Semaine 11 : projet en version 2 (readme, ndc, mcd, mld non-relationnel, bdd, app python)

## Contraintes liés au sujet 
Les personnes doivent pouvoir :
* s'ajouter à la base de données 
* créer des communautés
* déclarer faire partie de communauté
* déclarer avoir des liens avec d'autres personnes (unidirectionnel)
* gérer les informations de leur communauté, agir en tant que "la communauté"
* être contre la présence d'une personne dans la communauté
* ajouter un savoir-faire
* proposer des services (en lien ou non avec les savoir-faire)
* posséder un compte en Ğ1
* échanger des messages avec d'autres personnes et communauté
* se localiser avec des coordonnés géographiques

Les communautés doivent pouvoir :
* ajouter un savoir-faire 
* posséder un compte en Ğ1
* échanger des messages avec d'autres personnes et communauté
* déclarer avoir des liens avec d'autres communautés (unidirectionnel)


Contraintes générales :
* Si plus de la moitié des membres de la communauté est opposé à la présence d'une autre personne, alors celle-ci ne fait plus partie de la communauté.
* Un savoir-faire a un degré de 1 à 5
* Les services sont proposés avec ou sans-contre partie (autre service ou avec une somme en monnaie Ğ1)
* On stocke dans la base la liste des clés publiques des comptes en Ğ1. .
* Un message est la propriété intégrale de son expéditeur
* Un message peut faire référence à un autre message.
* Les coordonnées géographiques sous un format du type 49.41957, 2.82377. 
* Produire un lien du type : https://www.openstreetmap.org/#map=17/49.41957/2.82243 (où 17 est ici le niveau de zoom).

 
