# Note de clarification

Version 1 : 29/03/2020

### Contexte: 

Une bibliothèque municipale souhaite informatiser ses activités pour faciliter la gestion de ressources documentaires et leur recherche et emprunt par les adhérents. 
La gestion des prêts, retards et réservations sera également facilitée, de même que la gestion des utilisateurs et de leurs données. 
Elle souhaite aussi établir la liste des documents populaires, et étudier le profil des adhérents actuels et passés pour pouvoir leur suggérer des 
documents grâce aux statistiques des documents.


### Données d’entrées:

Aucune donnée d’entrée.

### Objet du projet: 

Concevoir un système de gestion pour une bibliothèque municipale : gestion de catalogages, consultations, gestion des utilisateurs, prêts, etc.

### Produit du projet: 

* README (avec les noms des membres du groupe)
* Note de Clarification
* Modèle Conceptuel Donnée
* MLD relationnel et non-relationnel
* BDD : base de données, données de test, questions
* Application Python


### Objectifs visés:

* Qualité : Un code informatique s'exécute correctement, accompagné de données de test et d’une documentation correctement présentée et correctement écrite en français.
* Délai : 3 avril 2020 pour le livrable 1, 21 juin 2020 pour le livrable 2.
* Coût : Non défini.

### Acteurs du projet:

#### Maître d’ouvrage: 
* CORREA-VICTORINO Alessandro

#### Maître d’oeuvre: 
* Antoine GOUILLET
* Claire TAUPIN
* Baptiste VIERA
* Omar PÉREZ
* Paul VILAIN

### Conséquences attendues:

Faciliter la gestion de la bibliothèque, faciliter l’utilisation des services pour les adhérents et le personnel.

**Contraintes à respecter:** 
* Première version des livrables pour le 3 Avril 2020 
        ( README et Note de clarification pour le lundi 30 mars 2020; 
        MCD en UML, MLD et BDD en SQL pour le vendredi 3 avril 2020 ).

* Livrable final pour le 21 Juin 2020
        Modifications sur le livrable 1 et Application Python.

**Contraintes de coûts:** 
Aucune 

**Contraintes de performances:** 
Aucune



|**Objet**    |**Propriétés**        |**Contraintes**|
|:-------:|:---------------|:--------|
|Livre* |Code, Titre, DateApparition,Genre, Liste de Contributeurs, Langue, Résumé, ISBN, État (neuf, bon, abîmé ou perdu), nombre d’emprunts|<ul><li>Code unique pour localiser dans la bibliothèque.</li><li>Liste de contributeurs qui seront distingués comme auteurs.</li></ul>|
|Film*      |Code, Titre, DateApparition,Genre, Liste de Contributeurs, Longueur, Langue, Synopsis, État (neuf, bon, abîmé ou perdu), nombre d’emprunts|<ul><li>Code unique pour localiser dans la bibliothèque.</li><li>Liste de contributeurs qui seront distingués comme Réalisateurs et Acteurs.</li></ul>|
|Musique*|Code, Titre, DateApparition, Genre, Liste de Contributeurs, Longueur, État (neuf, bon, abîmé ou perdu), nombre d’emprunts|<ul><li>Code unique pour localiser dans la bibliothèque.</li><li>Liste de contributeurs qui seront distingués comme Compositeurs et Interprètes.</li></ul>|
|Acteur**|Nom, Prénom, Date de naissance, Nationalité||
|Réalisateur**|Nom, Prénom, Date de naissance, Nationalité||
|Auteur**|Nom, Prénom, Date de naissance, Nationalité||
|Interprète**|Nom, Prénom, Date de naissance, Nationalité||
|Compositeur**|Nom, Prénom, Date de naissance, Nationalité||
|Adhérent|login, mot de passe, nom, prénom, adresse, adresse e-mail, dateNaissance, numéro de téléphone, Blacklisté ou non.|<ul><li>Authentification nécessaire</li><li>Suspension des droits si sanctions (retard, dégradation, remboursement)</li><li>Blacklisté (oui / non)</li><li>On suppose qu’un adhérent ne peut pas se désinscrire de la bibliothèque.</li></ul>|
|Personnel|login, mot de passe, nom, prénom, adresse, adresse e-mail.||
|Prêt|date début, date rendu, durée du prêt| <ul><li>Possible si exemplaire libre et en bon état.</li><li>Vérifier date de rendu</li><li>Vérifier l’état du document quand il est rendu</li><li>Vérifier nombre de prêts en cours pour chaque adhérent</li><li>Vérifier si l’utilisateur n’est pas blacklisté</li><li>Vérifier que la durée de l’emprunt n’a pas été dépassé</li></ul>|

***Note 1**: _Livre,  Musique et Film héritent d’une classe “Ressource”_.

****Note 2**: _Auteur, Acteur, Realisateur, Compositeur et Interprete héritent d’une classe “Contributeur”_.

|**Utilisateurs**|**Droits**|
|:----------:|:--------|
|Personnel|Lecture, Ajout/Suppression de ressources, Modification d’informations|
|Adhérent|Prêt, Recherche de ressources -> Suspension des droits si sanctions (retard, dégradation, remboursement)|

