# NF17-Bibliotheque

## Membres:

* Antoine Gouillet
* Baptiste Viera
* Claire Taupin
* Omar Perez
* Paul Vilain


## Mode d’emploi:

#### Lancement

Le script est fait pour fonctionner en oneshot, vous pouvez lancer tout le script d'un coup, les tables, fonctions, contraites et autres seront supprimées à chaque lancement

#### Utilisation

**Afin de garantir le respect de l'ensemble des relations de la base de données, des fonctions on été crées:**

Pour insérer un livre/film/musique, on passe exclusivement par une des fonctions prévues à cet effet :

* Insert_Livre
* Insert_Film
* Insert_Musique

Pour insérer un contributeur (acteur/réalisateur/compositeur/interprete/auteur) tout en l'associant à l'oeuvre à laquelle il a contribué, on passe là aussi par une des fonctions suivantes :

* Insert_Acteur_associe_film
* Insert_Realisateur_associe_film
* Insert_Compositeur_associe_musique
* Insert_Interprete_associe_musique
* Insert_Auteur_associe_livre

Cela garantit l'homogénéité et le respect des relations, ainsi que la non violation des contraintes.

On peut accéder à l’ensemble des ressources et leurs informations via la view du meme nom, vLivre pour les livres, vMusique, et vFilm.
Il en va de meme pour adhérents et personnels.

-Pour créer un pret, on utilisera la fonction Emprunt: 
Elle étudie les différents cas de figure pour un emprunt. Si le livre qu'on souhaite emprunter est déjà emprunté par quelqu'un d'autre on ne 
lui le laisse pas l'emprunter ou s'il a des sanctions non reglés (pas payés ou pas encore achevés). Si l'emprunt est possible la fonction rentre automatiquement les données dans les tables 
pret et modifie la table adhérent en augmentant le nombre de prets de l'utilisateur concerné.
Pour effectuer les test il faudra utiliser les lignes données en ligne 432 du code, et les tester une par une.


Lorsque qu’un pret est ramené, on passe par la fonction Update_Pret_Rendu.

#### Droits

Concernant la gestion des droits, les deux types d'utilisateurs ont été créés: Adhérent et Personnel.
Adhérent n'a que le droit de consultation ( Select ), tandis que Personnel dispose de l'ensemble des droits.


## Répartition

**README/Gestion du Git:** 
* Antoine Gouillet

**Note de Clarification:**
* Antoine Gouillet
* Baptiste Viera
* Claire Taupin
* Omar Perez
* Paul Vilain

**UML:**
* Antoine Gouillet
* Baptiste Viera
* Claire Taupin
* Omar Perez
* Paul Vilain

**PlantUML:**
* Omar Perez


**MLD:**
* Antoine Gouillet
* Claire Taupin
* Baptiste Viera
* Paul Vilain

**SQL:**

Création des tables et contraintes:
* Antoine Gouillet
* Claire Taupin
* Omar Perez

Création des vues:
* Baptiste Viera
* Paul Vilain

Création des fonctions:
* Antoine Gouillet
* Claire Taupin

Insertion des données de test:
* Omar Perez 
* Paul Vilain



