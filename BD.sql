/* Drop All */
DROP TABLE IF EXISTS Musique,Film, Livre,  Auteur, Realisateur, Acteur, Compositeur, Interprete, Joue, JoueDans, Compose, Ecrit, Realise, Pret, Sanction, Personnel, Adherent, Exemplaire, Ressource,  Contributeur CASCADE  ;
DROP TYPE IF EXISTS typeetat CASCADE ;
DROP USER IF EXISTS Adherent, Personnel;
DROP FUNCTION IF EXISTS Insert_Musique ( vtitre varchar, vdpublication date ,vediteur varchar, vgenre varchar, vclassification varchar , vlongueur integer, vnomC varchar, vprenomC varchar, vdnaissanceC date, vnationaliteC varchar, vnomI varchar, vprenomI varchar, vdnaissanceI date, vnationaliteI varchar);
DROP FUNCTION IF EXISTS Insert_Film ( vtitre varchar, vdpublication date, vediteur varchar, vgenre varchar, vclassification varchar, vlangue varchar, vlongueur integer, vsynopsis text, vnomA varchar, vprenomA varchar, vdnaissanceA date, vnationaliteA varchar, vnomR varchar, vprenomR varchar, vdnaissanceR date, vnationaliteR varchar);
DROP FUNCTION If Exists Insert_Livre( vtitre varchar, vdpublication date, vediteur varchar, vgenre varchar, vclassification varchar, visbn varchar, vresume text, vlangue character, vnom varchar, vprenom varchar, vdnaissance date, vnationalite varchar);
Drop FUNCTION If Exists Update_Pret_Rendu(vcode varchar, vcodexemplaire varchar, vlogin varchar, vdateemprunt date, vdateretour date, vetatretour typeetat);
Drop FUNCTION If Exists Emprunt(vcode integer, vcodexemplaire integer, vlogin varchar, vdateemprunt date, vdateretour_fixe date);
DROP FUNCTION IF EXISTS Insert_Auteur_associe_livre (vnom varchar, vprenom varchar, vdnaissance date, vnationalite varchar, vtitre varchar, vdpublication date, vediteur varchar, vgenre varchar, vclassification varchar, vISBN varchar);
DROP FUNCTION IF EXISTS Insert_Interprete_associe_musique (vnom varchar, vprenom varchar, vdnaissance date, vnationalite varchar, vtitre varchar, vdpublication date, vediteur varchar, vgenre varchar, vclassification varchar, vlongueur integer);
DROP FUNCTION IF EXISTS Insert_Compositeur_associe_musique (vnom varchar, vprenom varchar, vdnaissance date, vnationalite varchar, vtitre varchar, vdpublication date, vediteur varchar, vgenre varchar, vclassification varchar, vlongueur integer);
DROP FUNCTION IF EXISTS Insert_Acteur_associe_film (vnom varchar, vprenom varchar, vdnaissance date, vnationalite varchar, vtitre varchar, vdpublication date, vediteur varchar, vgenre varchar, vclassification varchar, vlangue varchar, vlongueur integer);
DROP FUNCTION IF EXISTS Insert_Realisateur_associe_film (vnom varchar, vprenom varchar, vdnaissance date, vnationalite varchar, vtitre varchar, vdpublication date, vediteur varchar, vgenre varchar, vclassification varchar, vlangue varchar, vlongueur integer);
DROP VIEW If EXISTS vFilm, vLivre, vMusique, vActeur, vAuteur, vRealisateur, vCompositeur, vInterprete;


/* DataType Etat */
CREATE TYPE typeetat AS ENUM ( 'neuf','bon', 'abime', 'perdu'  );

/* Création des tables */

CREATE TABLE Personnel (
	login VARCHAR PRIMARY KEY,
	mdp VARCHAR NOT NULL,
	nom VARCHAR NOT NULL,
	prenom VARCHAR NOT NULL,
	mail VARCHAR UNIQUE NOT NULL CHECK (mail LIKE '%@%.%'),
	role VARCHAR NOT NULL,
	salaire DECIMAL NOT NULL);

CREATE TABLE Adherent (
	login VARCHAR PRIMARY KEY,
	mdp VARCHAR NOT NULL,
	nom VARCHAR NOT NULL,
	prenom VARCHAR NOT NULL,
	mail VARCHAR UNIQUE NOT NULL CHECK (mail LIKE '%@%.%'),
	dnaissance DATE NOT NULL CHECK (dnaissance < CURRENT_DATE),
	dinscription DATE NOT NULL CHECK (dinscription < CURRENT_DATE),
	numtel INTEGER UNIQUE NOT NULL,
	nbpret INTEGER NOT NULL,
	etudiant BOOLEAN NOT NULL);

CREATE TABLE Ressource (
	code serial PRIMARY KEY ,
	titre character varying NOT NULL,
	dpublication date NOT NULL CHECK (dpublication < CURRENT_DATE),
	editeur varchar,
	genre character varying NOT NULL,
	classification character varying NOT NULL CHECK (length(classification)=13));

CREATE TABLE Livre (
	code serial PRIMARY KEY REFERENCES Ressource (code),
	ISBN character varying(13) NOT NULL CHECK (length(ISBN)=13),
	resume text NOT NULL,
	langue character varying NOT NULL);

CREATE TABLE Film (
	code serial  PRIMARY KEY REFERENCES Ressource (code),
	langue character varying NOT NULL,
	longueur integer NOT NULL,
	synopsis text NOT NULL);

CREATE TABLE Musique (
	code serial PRIMARY KEY REFERENCES Ressource(code),
	longueur integer NOT NULL);

CREATE TABLE Exemplaire (
	code serial references Ressource(code),
	codexemplaire serial,
	etat typeetat NOT NULL,
	PRIMARY KEY(codexemplaire,code));

CREATE TABLE Contributeur (
	idcontrib serial primary key ,
	nom varchar not null ,
	prenom varchar not null ,
	dnaissance date not null ,
	nationalite varchar not null);

CREATE TABLE Auteur (
	idcontrib serial primary key references Contributeur(idcontrib));

CREATE TABLE Realisateur (
	idcontrib serial primary key references Contributeur(idcontrib));

CREATE TABLE Acteur (
	idcontrib serial primary key references Contributeur(idcontrib));

CREATE TABLE Compositeur (
	idcontrib serial primary key references Contributeur(idcontrib));

CREATE TABLE Interprete (
	idcontrib serial primary key references Contributeur(idcontrib));

create table JoueDans (
	idcontrib serial NOT NULL,
	code serial NOT NULL,
	PRIMARY KEY(idcontrib,code),
	FOREIGN KEY (code) REFERENCES Film(code),
	FOREIGN KEY (idcontrib) REFERENCES Acteur(idcontrib));

create table Realise (
	idcontrib serial NOT NULL,
	code serial NOT NULL,
	PRIMARY KEY(idcontrib,code),
	FOREIGN KEY (code) REFERENCES Film(code),
	FOREIGN KEY (idcontrib) REFERENCES Realisateur(idcontrib));

create table Joue (
	idcontrib serial NOT NULL,
	code serial NOT NULL,
	PRIMARY KEY(idcontrib,code),
	FOREIGN KEY (code) REFERENCES Musique(code),
	FOREIGN KEY (idcontrib) REFERENCES Interprete(idcontrib));

create table Compose (
	idcontrib serial NOT NULL,
	code serial NOT NULL,
	PRIMARY KEY(idcontrib,code),
	FOREIGN KEY (code) REFERENCES Musique(code),
	FOREIGN KEY (idcontrib) REFERENCES Compositeur(idcontrib));

create table Ecrit (
	idcontrib serial NOT NULL,
	code serial NOT NULL,
	PRIMARY KEY(idcontrib,code),
	FOREIGN KEY (code) REFERENCES Livre(code),
	FOREIGN KEY (idcontrib) REFERENCES Auteur(idcontrib));

CREATE TABLE Sanction (
	code serial NOT NULL,
	codexemplaire serial NOT NULL,
	login VARCHAR NOT NULL,
	dateemprunt DATE NOT NULL,
	remboursement BOOLEAN DEFAULT '0',
	finsanction DATE,
	PRIMARY KEY (code, codexemplaire, login, dateemprunt),
	FOREIGN KEY (code, codexemplaire) REFERENCES Exemplaire(code, codexemplaire),
	FOREIGN KEY (login) REFERENCES Adherent(login));

CREATE TABLE Pret (
	code serial NOT NULL,
	codexemplaire serial NOT NULL,
	login VARCHAR NOT NULL,
	dateemprunt DATE NOT NULL CHECK(dateemprunt = CURRENT_DATE),
	dateretour_fixe DATE NOT NULL,
	dateretour_reelle DATE,
	etatretour typeetat,
	PRIMARY KEY (code, codexemplaire, login, dateemprunt),
	FOREIGN KEY (code, codexemplaire) REFERENCES Exemplaire(code, codexemplaire),
	FOREIGN KEY (login) REFERENCES Adherent(login));


/* Fonctions d'insertion */

CREATE FUNCTION Insert_Livre ( vtitre varchar, vdpublication date ,vediteur varchar, vgenre varchar, vclassification varchar , visbn varchar, vresume text , vlangue character, vnom varchar, vprenom varchar, vdnaissance date, vnationalite varchar ) returns void as
$$
DECLARE
    varcodelivre integer;
BEGIN
    INSERT INTO Ressource ( code, titre, dpublication, editeur, genre, classification) VALUES (default, vtitre,vdpublication,vediteur,vgenre,vclassification);
    Select currval(pg_get_serial_sequence('Ressource','code')) into varcodelivre;
    INSERT INTO Livre (code, ISBN, resume, langue) VALUES (varcodelivre ,visbn,vresume,vlangue) ;
    IF NOT EXISTS(SELECT (nom, prenom, dnaissance, nationalite) from Contributeur where nationalite = vnationalite and nom = vnom and prenom = vprenom and dnaissance = vdnaissance) THEN
        INSERT INTO Contributeur ( nom, prenom, dnaissance, nationalite)  values (vnom, vprenom, vdnaissance, vnationalite);
        INSERT INTO Auteur(idcontrib) values ((SELECT currval(pg_get_serial_sequence('CONTRIBUTEUR','idcontrib'))));
    end if;
    insert into Ecrit(idcontrib, code) values ((SELECT Auteur.idcontrib from Auteur inner join Contributeur C on Auteur.idcontrib = C.idcontrib where prenom = vprenom and nom = vnom and dnaissance= vdnaissance and nationalite =vnationalite), varcodelivre );

end
$$
LANGUAGE 'plpgsql';


CREATE FUNCTION Insert_Film ( vtitre varchar, vdpublication date ,vediteur varchar, vgenre varchar, vclassification varchar , vlangue varchar, vlongueur integer, vsynopsis text, vnomA varchar, vprenomA varchar, vdnaissanceA date, vnationaliteA varchar, vnomR varchar, vprenomR varchar, vdnaissanceR date, vnationaliteR varchar) returns void as
$$
DECLARE
    varcodefilm integer;
BEGIN
    INSERT INTO Ressource ( code, titre, dpublication, editeur, genre, classification) VALUES (default, vtitre,vdpublication,vediteur,vgenre,vclassification);
    Select currval(pg_get_serial_sequence('Ressource','code')) into varcodefilm;
    INSERT INTO Film (code, langue, longueur, synopsis) VALUES (varcodefilm ,vlangue,vlongueur,vsynopsis) ;
	IF NOT EXISTS(SELECT (nom, prenom, dnaissance, nationalite) from Contributeur where nationalite = vnationaliteA and nom = vnomA and prenom = vprenomA and dnaissance = vdnaissanceA) THEN
		INSERT INTO Contributeur ( nom, prenom, dnaissance, nationalite)  values (vnomA, vprenomA, vdnaissanceA, vnationaliteA);
		INSERT INTO Acteur(idcontrib) values ((SELECT currval(pg_get_serial_sequence('CONTRIBUTEUR','idcontrib'))));
	END IF;
    IF NOT EXISTS(SELECT (nom, prenom, dnaissance, nationalite) from Contributeur where nationalite = vnationaliteR and nom = vnomR and prenom = vprenomR and dnaissance = vdnaissanceR) THEN
		INSERT INTO Contributeur (nom, prenom, dnaissance, nationalite)  values (vnomR, vprenomR, vdnaissanceR, vnationaliteR);
		INSERT INTO Realisateur(idcontrib) values ((SELECT currval(pg_get_serial_sequence('CONTRIBUTEUR','idcontrib'))));
	END IF;
	insert into JoueDans(idcontrib, code) values ((SELECT Acteur.idcontrib from Acteur inner join Contributeur C on Acteur.idcontrib = C.idcontrib where prenom = vprenomA and nom = vnomA and dnaissance= vdnaissanceA and nationalite =vnationaliteA), varcodefilm );
	insert into Realise(idcontrib, code) values ((SELECT Realisateur.idcontrib from Realisateur inner join Contributeur C on Realisateur.idcontrib = C.idcontrib where prenom = vprenomR and nom = vnomR and dnaissance= vdnaissanceR and nationalite =vnationaliteR), varcodefilm );
end
$$
LANGUAGE 'plpgsql';


CREATE FUNCTION Insert_Musique ( vtitre varchar, vdpublication date ,vediteur varchar, vgenre varchar, vclassification varchar , vlongueur integer, vnomC varchar, vprenomC varchar, vdnaissanceC date, vnationaliteC varchar, vnomI varchar, vprenomI varchar, vdnaissanceI date, vnationaliteI varchar) returns void as
$$
DECLARE
    varcodemusique integer;
BEGIN
    INSERT INTO Ressource ( code, titre, dpublication, editeur, genre, classification) VALUES (default, vtitre,vdpublication,vediteur,vgenre,vclassification);
    Select currval(pg_get_serial_sequence('Ressource','code')) into varcodemusique;
    INSERT INTO Musique (code, longueur) VALUES (varcodemusique, vlongueur) ;
	IF NOT EXISTS(SELECT (nom, prenom, dnaissance, nationalite) from Contributeur where nationalite = vnationaliteC and nom = vnomC and prenom = vprenomC and dnaissance = vdnaissanceC) THEN
		INSERT INTO Contributeur ( nom, prenom, dnaissance, nationalite)  values (vnomC, vprenomC, vdnaissanceC, vnationaliteC);
		INSERT INTO Compositeur(idcontrib) values ((SELECT currval(pg_get_serial_sequence('CONTRIBUTEUR','idcontrib'))));
	END IF;
    IF NOT EXISTS(SELECT (nom, prenom, dnaissance, nationalite) from Contributeur where nationalite = vnationaliteI and nom = vnomI and prenom = vprenomI and dnaissance = vdnaissanceI) THEN
		INSERT INTO Contributeur (nom, prenom, dnaissance, nationalite)  values (vnomI, vprenomI, vdnaissanceI, vnationaliteI);
		INSERT INTO Interprete(idcontrib) values ((SELECT currval(pg_get_serial_sequence('CONTRIBUTEUR','idcontrib'))));
	END IF;
	insert into Compose(idcontrib, code) values ((SELECT Compositeur.idcontrib from Compositeur inner join Contributeur C on Compositeur.idcontrib = C.idcontrib where prenom = vprenomC and nom = vnomC and dnaissance= vdnaissanceC and nationalite =vnationaliteC), varcodemusique );
	insert into Joue(idcontrib, code) values ((SELECT Interprete.idcontrib from Interprete inner join Contributeur C on Interprete.idcontrib = C.idcontrib where prenom = vprenomI and nom = vnomI and dnaissance= vdnaissanceI and nationalite =vnationaliteI), varcodemusique );
end
$$
LANGUAGE 'plpgsql';


/* Valeurs Test Ressources */

select insert_livre('Le Kamakiri, un Bonzai Japonais','2010-09-06','Jardiland','culture','1287456666999','1597823500169','A la decouverte des mysteres du japon','français', 'Jean', 'Jacque', CURRENT_DATE, 'Francais');
select insert_livre('Le Petit Chaperon Bleu','2010-09-06','leboijoli','féerique','1287456321245','1597823500120','une petite fille qui va chez son grand-père pour lui donner un pot de nutella','français', 'Jean', 'Paul', CURRENT_DATE, 'Francais');
SELECT Insert_Film ('Matrice','2001-03-15','editop','action','1587000000364','english','245','un homme perdu dans ses pensées essaie d''en sortir','Michael','Truelle','1987-06-25','français','Georges','Carrot','1979-12-30','américain');
select insert_film('The Sonoc movie','1975-12-14','paramoustache','action','1364785912476', 'english',134,'les aventures de Sonoc le pangolin bleu qui nage a la vitesse d''un escargot','Henry','Trila','1989-10-07','luxembourgeois','Georges','Carrot','1979-12-30','américain');
SELECT Insert_Musique ('Billie bermuda','1997-06-07','cdfanatic','pop','5168284956326', 197,'Helio', 'Galaxy','1993-11-12', 'anglais', 'Alexandre','Short','1999-02-01','canadien');



/* Création fonctions d'ajouts de contributeurs */


CREATE FUNCTION Insert_Auteur_associe_livre (vnom varchar, vprenom varchar, vdnaissance date, vnationalite varchar, vtitre varchar, vdpublication date, vediteur varchar, vgenre varchar, vclassification varchar, vISBN varchar) returns void as
$$	
BEGIN
    IF EXISTS(SELECT (titre, dpublication, editeur, genre, classification, ISBN) from Ressource AS R, Livre AS L where R.titre = vtitre and R.dpublication = vdpublication and R.editeur = vediteur and R.genre = vgenre and R.classification = vclassification and L.ISBN = vISBN) THEN
	IF NOT EXISTS(SELECT (nom, prenom, dnaissance, nationalite) from Contributeur where nationalite = vnationalite and nom = vnom and prenom = vprenom and dnaissance = vdnaissance) THEN
		INSERT INTO Contributeur (idcontrib, nom, prenom, dnaissance, nationalite) VALUES (default, vnom, vprenom, vdnaissance, vnationalite);
		INSERT INTO Auteur(idcontrib) values ((SELECT currval(pg_get_serial_sequence('CONTRIBUTEUR','idcontrib'))));
        	INSERT INTO Ecrit(idcontrib, code) values ((SELECT Auteur.idcontrib from Auteur inner join Contributeur C on Auteur.idcontrib = C.idcontrib where prenom = vprenom and nom = vnom and dnaissance= vdnaissance and nationalite =vnationalite),(SELECT R.code from Ressource R inner join Livre L on R.code = L.code where R.titre = vtitre and R.dpublication = vdpublication and R.editeur = vediteur and R.genre = vgenre and R.classification = vclassification and L.ISBN = vISBN));
    	ELSE RAISE EXCEPTION 'Cet auteur est déjà dans la liste des contributeurs';
	end if;
    ELSE RAISE EXCEPTION 'Ce livre n''est pas dans la liste des livres existants. Veuillez ajouter le livre en premier lieu';
    end if;
end
$$
LANGUAGE 'plpgsql';



CREATE FUNCTION Insert_Interprete_associe_musique (vnom varchar, vprenom varchar, vdnaissance date, vnationalite varchar, vtitre varchar, vdpublication date, vediteur varchar, vgenre varchar, vclassification varchar, vlongueur integer) returns void as
$$	
	
BEGIN
    IF EXISTS(SELECT (titre, dpublication, editeur, genre, classification) from Ressource AS R, Musique AS M where R.titre = vtitre and R.dpublication = vdpublication and R.editeur = vediteur and R.genre = vgenre and R.classification = vclassification and M.longueur = vlongueur) THEN
		IF NOT EXISTS(SELECT (nom, prenom, dnaissance, nationalite) from Contributeur where nationalite = vnationalite and nom = vnom and prenom = vprenom and dnaissance = vdnaissance) THEN
			INSERT INTO Contributeur (idcontrib, nom, prenom, dnaissance, nationalite) VALUES (default, vnom, vprenom, vdnaissance, vnationalite);
		end if;
		IF NOT EXISTS(SELECT Interprete.idcontrib from Interprete inner join Contributeur C on Interprete.idcontrib = C.idcontrib WHERE C.nom = vnom and C.prenom = vprenom and C.dnaissance = vdnaissance and C.nationalite = vnationalite) THEN
			INSERT INTO Interprete(idcontrib) values ((SELECT idcontrib From Contributeur where nom = vnom and prenom = vprenom and dnaissance = vdnaissance and nationalite = vnationalite ));
        	INSERT INTO Joue(idcontrib, code) values ((SELECT Interprete.idcontrib from Interprete inner join Contributeur C on Interprete.idcontrib = C.idcontrib where prenom = vprenom and nom = vnom and dnaissance= vdnaissance and nationalite =vnationalite),(SELECT R.code from Ressource R inner join Musique M on R.code = M.code where R.titre = vtitre and R.dpublication = vdpublication and R.editeur = vediteur and R.genre = vgenre and R.classification = vclassification and M.longueur = vlongueur));
    	ELSE RAISE EXCEPTION 'Cet interprete est déjà dans la liste des interpretes';
		end if;
    ELSE RAISE EXCEPTION 'Cet enregistrement musical n''est pas dans la liste des musiques existantes. Veuillez ajouter l''enregistrement en premier lieu';
    end if;
end
$$
LANGUAGE 'plpgsql';


CREATE FUNCTION Insert_Compositeur_associe_musique (vnom varchar, vprenom varchar, vdnaissance date, vnationalite varchar, vtitre varchar, vdpublication date, vediteur varchar, vgenre varchar, vclassification varchar, vlongueur integer) returns void as
$$	
	
BEGIN
    IF EXISTS(SELECT (titre, dpublication, editeur, genre, classification) from Ressource AS R, Musique AS M where R.titre = vtitre and R.dpublication = vdpublication and R.editeur = vediteur and R.genre = vgenre and R.classification = vclassification and M.longueur = vlongueur) THEN
		IF NOT EXISTS(SELECT (nom, prenom, dnaissance, nationalite) from Contributeur where nationalite = vnationalite and nom = vnom and prenom = vprenom and dnaissance = vdnaissance) THEN
			INSERT INTO Contributeur (idcontrib, nom, prenom, dnaissance, nationalite) VALUES (default, vnom, vprenom, vdnaissance, vnationalite);
		end if;
		IF NOT EXISTS(SELECT Compositeur.idcontrib from Compositeur inner join Contributeur C on Compositeur.idcontrib = C.idcontrib WHERE C.nom = vnom and C.prenom = vprenom and C.dnaissance = vdnaissance and C.nationalite = vnationalite) THEN
			INSERT INTO Compositeur(idcontrib) values ((SELECT idcontrib From Contributeur where nom = vnom and prenom = vprenom and dnaissance = vdnaissance and nationalite = vnationalite ));
        	INSERT INTO Compose(idcontrib, code) values ((SELECT Compositeur.idcontrib from Compositeur inner join Contributeur C on Compositeur.idcontrib = C.idcontrib where prenom = vprenom and nom = vnom and dnaissance= vdnaissance and nationalite =vnationalite),(SELECT R.code from Ressource R inner join Musique M on R.code = M.code where R.titre = vtitre and R.dpublication = vdpublication and R.editeur = vediteur and R.genre = vgenre and R.classification = vclassification and M.longueur = vlongueur));
    	ELSE RAISE EXCEPTION 'Ce compositeur est déjà dans la liste des compositeurs';
		end if;
    ELSE RAISE EXCEPTION 'Cet enregistrement musical n''est pas dans la liste des musiques existantes. Veuillez ajouter l''enregistrement en premier lieu';
    end if;
end
$$
LANGUAGE 'plpgsql';


CREATE FUNCTION Insert_Acteur_associe_film (vnom varchar, vprenom varchar, vdnaissance date, vnationalite varchar, vtitre varchar, vdpublication date, vediteur varchar, vgenre varchar, vclassification varchar, vlangue varchar, vlongueur integer) returns void as
$$	
BEGIN
    IF EXISTS(SELECT (titre, dpublication, editeur, genre, classification) from Ressource AS R, Film AS F where R.titre = vtitre and R.dpublication = vdpublication and R.editeur = vediteur and R.genre = vgenre and R.classification = vclassification and F.langue = vlangue and F.longueur = vlongueur) THEN
		IF NOT EXISTS(SELECT (nom, prenom, dnaissance, nationalite) from Contributeur where nationalite = vnationalite and nom = vnom and prenom = vprenom and dnaissance = vdnaissance) THEN
			INSERT INTO Contributeur (idcontrib, nom, prenom, dnaissance, nationalite) VALUES (default, vnom, vprenom, vdnaissance, vnationalite);
		end if;
		IF NOT EXISTS(SELECT Acteur.idcontrib from Acteur inner join Contributeur C on Acteur.idcontrib = C.idcontrib WHERE C.nom = vnom and C.prenom = vprenom and C.dnaissance = vdnaissance and C.nationalite = vnationalite) THEN
			INSERT INTO Acteur(idcontrib) values ((SELECT idcontrib From Contributeur where nom = vnom and prenom = vprenom and dnaissance = vdnaissance and nationalite = vnationalite ));
        	INSERT INTO JoueDans(idcontrib, code) values ((SELECT Acteur.idcontrib from Acteur inner join Contributeur C on Acteur.idcontrib = C.idcontrib where prenom = vprenom and nom = vnom and dnaissance= vdnaissance and nationalite =vnationalite),(SELECT R.code from Ressource R inner join Film F on R.code = F.code where R.titre = vtitre and R.dpublication = vdpublication and R.editeur = vediteur and R.genre = vgenre and R.classification = vclassification and F.langue = vlangue and F.longueur = vlongueur));
    	ELSE RAISE EXCEPTION 'Cet acteur est déjà dans la liste des acteurs';
		end if;
    ELSE RAISE EXCEPTION 'Ce film n''est pas dans la liste des films existants. Veuillez ajouter le film en premier lieu';
    end if;
end
$$
LANGUAGE 'plpgsql';


CREATE FUNCTION Insert_Realisateur_associe_film (vnom varchar, vprenom varchar, vdnaissance date, vnationalite varchar, vtitre varchar, vdpublication date, vediteur varchar, vgenre varchar, vclassification varchar, vlangue varchar, vlongueur integer) returns void as
$$	
BEGIN
    IF EXISTS(SELECT (titre, dpublication, editeur, genre, classification) from Ressource AS R, Film AS F where R.titre = vtitre and R.dpublication = vdpublication and R.editeur = vediteur and R.genre = vgenre and R.classification = vclassification and F.langue = vlangue and F.longueur = vlongueur) THEN
		IF NOT EXISTS(SELECT (nom, prenom, dnaissance, nationalite) from Contributeur where nationalite = vnationalite and nom = vnom and prenom = vprenom and dnaissance = vdnaissance) THEN
			INSERT INTO Contributeur (idcontrib, nom, prenom, dnaissance, nationalite) VALUES (default, vnom, vprenom, vdnaissance, vnationalite);
		end if;
		IF NOT EXISTS(SELECT Realisateur.idcontrib from Realisateur inner join Contributeur C on Realisateur.idcontrib = C.idcontrib WHERE C.nom = vnom and C.prenom = vprenom and C.dnaissance = vdnaissance and C.nationalite = vnationalite) THEN
			INSERT INTO Realisateur(idcontrib) values ((SELECT idcontrib From Contributeur where nom = vnom and prenom = vprenom and dnaissance = vdnaissance and nationalite = vnationalite ));
        	INSERT INTO Realise(idcontrib, code) values ((SELECT Realisateur.idcontrib from Realisateur inner join Contributeur C on Realisateur.idcontrib = C.idcontrib where prenom = vprenom and nom = vnom and dnaissance= vdnaissance and nationalite =vnationalite),(SELECT R.code from Ressource R inner join Film F on R.code = F.code where R.titre = vtitre and R.dpublication = vdpublication and R.editeur = vediteur and R.genre = vgenre and R.classification = vclassification and F.langue = vlangue and F.longueur = vlongueur));
    	ELSE RAISE EXCEPTION 'Ce réalisateur est déjà dans la liste des réalisateurs';
		end if;
    ELSE RAISE EXCEPTION 'Ce film n''est pas dans la liste des films existants. Veuillez ajouter le film en premier lieu';
    end if;
end
$$
LANGUAGE 'plpgsql';


/* Valeurs Tests fonctions d'ajouts de contributeurs */ 

SELECT Insert_Auteur_associe_livre ('Tropio','Ernest','1975-04-01','francais','Le Kamakiri, un Bonzai Japonais','2010-09-06','Jardiland','culture','1287456666999','1597823500169');
SELECT Insert_Compositeur_associe_musique('Roy','Larry','1984-05-03','americain','Billie bermuda','1997-06-07','cdfanatic','pop','5168284956326', 197);
SELECT Insert_Interprete_associe_musique('Roy','Larry','1984-05-03','americain','Billie bermuda','1997-06-07','cdfanatic','pop','5168284956326', 197);
SELECT Insert_Acteur_associe_film('José','Maria','1986-05-04','espagnole','Matrice','2001-03-15','editop','action','1587000000364','english',245);
SELECT Insert_Acteur_associe_film ('Billy','Marc','1990-01-23','américain','The Sonoc movie','1975-12-14','paramoustache','action','1364785912476', 'english',134);
SELECT Insert_Realisateur_associe_film ('Billy','Marc','1990-01-23','américain','The Sonoc movie','1975-12-14','paramoustache','action','1364785912476', 'english',134);




/* Création fonctions liées aux emprunts */


CREATE FUNCTION Emprunt (vcode integer, vcodexemplaire integer, vlogin varchar, vdateemprunt date, vdateretour_fixe date) returns void as
$$
  BEGIN
  IF NOT EXISTS(SELECT s.login FROM Sanction s INNER JOIN Adherent a ON (s.login = a.login) WHERE ((a.login = vlogin) AND (s.remboursement=FALSE OR s.finsanction > CURRENT_DATE )))  THEN /*check si la personne peut emprunter*/

    IF EXISTS( SELECT e.codexemplaire FROM Exemplaire e INNER JOIN Pret p ON e.codexemplaire = p.codexemplaire AND e.code = p.code WHERE e.code = vcode AND e.codexemplaire=vcodexemplaire AND e.etat='bon' OR e.etat='neuf') THEN
      IF NOT EXISTS (SELECT (e.codexemplaire) FROM Exemplaire e INNER JOIN Pret p ON (e.code=p.code) WHERE (p.dateretour_reelle IS NULL)) THEN /*CAS OU LIVRE DEJA EMPRUNTE ET L'UTILISATEUR PEUT EMPRUNTER*/
            INSERT INTO Pret VALUES(vcode,vcodexemplaire,vlogin,vdateemprunt,vdateretour_fixe,NULL,NULL);
            UPDATE Adherent
                SET nbpret = nbpret + 1
                WHERE login = vlogin;
      End if;
    End if;
  IF NOT EXISTS( SELECT e.codexemplaire FROM Exemplaire e INNER JOIN Pret p ON e.codexemplaire = p.codexemplaire AND e.code = p.code WHERE e.code = vcode AND e.codexemplaire=vcodexemplaire) THEN/*CAS OU LIVRE N A JAMAIS ETE EMPRUNTE ET PEUT ETRE EMPRUNTE PAR L'UTILISATEUR*/
        INSERT INTO Pret VALUES(vcode,vcodexemplaire,vlogin,vdateemprunt,vdateretour_fixe,NULL,NULL);
        UPDATE Adherent
            SET nbpret = nbpret + 1
            WHERE login = vlogin;
  End if;
  End if;
END
$$

LANGUAGE 'plpgsql';


CREATE FUNCTION Update_Pret_Rendu (vcode integer, vcodexemplaire integer, vlogin varchar, vdateemprunt date, vdateretour date, vetatretour typeetat) returns void as
$$
BEGIN
    UPDATE Pret
	SET dateretour_reelle = vdateretour, etatretour = vetatretour
	WHERE code = vcode AND codexemplaire = vcodexemplaire AND login = vlogin AND dateemprunt = vdateemprunt AND dateretour_fixe = vdateretour;
    UPDATE Adherent
    SET nbpret = nbpret -1
    WHERE login = vlogin;
END
$$
LANGUAGE 'plpgsql';

/* Valeur test Update Prêt rendu */
SELECT Update_Pret_Rendu (1, 1,'marie123','2020-04-20','2020-04-04','abime');



/*Creation de users et gestion des droits*/
CREATE USER Adherent;
CREATE USER Personnel;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE acteur, adherent, auteur,
compose, compositeur, contributeur, ecrit, exemplaire, film, interprete,
joue, jouedans, Livre, musique, personnel, pret, realisateur, realise,
ressource, sanction TO Personnel;

GRANT SELECT ON TABLE acteur, adherent, auteur,
compose, compositeur, contributeur, ecrit, exemplaire, film, interprete,
joue, jouedans, Livre, musique, pret, realisateur, realise,
ressource, sanction TO Adherent;




/* Valeurs Test Personnel */
INSERT INTO Personnel VALUES('mardup','123mot','Dupont','Marc','marc@mail.com','Directeur',1200);
INSERT INTO Personnel VALUES('antgou','123mots','Gouillet','Antoine','antoine@mail.com','Directeur',120000);
INSERT INTO Personnel VALUES('omaper','mdp124','Perez','Omar','omar@mail.com','Employe',800);
INSERT INTO Personnel VALUES('bapvie','motpasse','Viera','Baptiste','bap@mail.com','Employe',900);
INSERT INTO Personnel VALUES('clatau','motdepasse1234','Taupin','Claire','claire@mail.com','Employe',800);
INSERT INTO Personnel VALUES('pauvil','mdp1','Vilain','Paul','paul@mail.com','Employe',1000);

/* Valeurs test Adherent */
INSERT INTO Adherent VALUES('marie123','password1','Hubert','Marie','marie@mail.com','2000-01-20','2018-01-20',0630303030,20,TRUE);
INSERT INTO Adherent VALUES('camille987','passc','Franco','Camille','camille@mail.com','1989-06-10','2010-05-10',0630364030,17,TRUE);
INSERT INTO Adherent VALUES('david490','password1','Maupassant','David','david@mail.com','1980-04-22','2016-11-28',0690407080,7,FALSE);


/*Valeurs Test Exemplaire */
INSERT INTO Exemplaire VALUES (1,1,'neuf');
INSERT INTO Exemplaire VALUES (1,2,'bon');
INSERT INTO Exemplaire VALUES (1,3,'abime');
INSERT INTO Exemplaire VALUES (1,4,'perdu');
INSERT INTO Exemplaire VALUES (2,1,'neuf');
/*Valeurs Test Prêt */
INSERT INTO Pret VALUES (1,1,'marie123',CURRENT_DATE,CURRENT_DATE+15,NULL,NULL);
INSERT INTO Pret VALUES (1,2,'camille987',CURRENT_DATE,CURRENT_DATE+15,NULL,NULL);


/*  DONNÉES DE TEST POUR EMPRUNT LES DIFFERENTS CAS DE FIGURE: IL FAUT FAIRE LES SELECT UN PAR UN!!!  */

SELECT Emprunt(2,1,'camille987',CURRENT_DATE,CURRENT_DATE+20);/*doit marcher car camille peut emprunter ce exemplaire qui est disponible*/
SELECT Emprunt(2,1,'camille987',CURRENT_DATE,CURRENT_DATE+20);/*ce cas ne marche pas car camille l emprunte deja*/
SELECT Emprunt(1,1,'marie123',CURRENT_DATE,CURRENT_DATE+20); /*ce cas ne marche pas car marie est sanctionne et n a pas paye*/
SELECT Emprunt(2,1,'david490',CURRENT_DATE,CURRENT_DATE+20); /*ce cas ne marche pas car david est sanctionne et doit attendre la fin de sa sanction*/

INSERT INTO Sanction VALUES (1,1,'david490',CURRENT_DATE-15,NULL,CURRENT_DATE+15); /*Peut pas emprunter car datesanction pas encore atteinte */
INSERT INTO Sanction VALUES (1,1,'marie123',CURRENT_DATE-15,FALSE,NULL); /*Peut pas emprunter car pas paye*/



/*Montrer les documents disponibles*/

SELECT r.titre, r.dpublication, r.editeur, r.genre, COUNT (*) AS NbDisponibles
FROM Ressource r INNER JOIN Exemplaire e ON (r.code=e.code)
WHERE (e.etat='bon' OR e.etat='neuf')
GROUP BY r.titre, r.dpublication, r.editeur, r.genre;

/*Montrer les docs disponibles pour une catégorie*/
SELECT r.titre, r.dpublication, r.editeur, r.genre, COUNT (*) AS NbDisponibles
FROM Ressource r INNER JOIN Exemplaire e ON (r.code=e.code )
WHERE ((e.etat='bon' OR e.etat='neuf') AND r.genre='féerique')
GROUP BY r.titre,r.dpublication,r.editeur,r.genre;

/*Montrer le nb d’exemplaires disponibles d’un livre*/
SELECT r.titre, COUNT (*) AS NbDisponibles
FROM Ressource r INNER JOIN Exemplaire e ON (r.code=e.code)
WHERE (e.etat='bon' OR e.etat='neuf')
GROUP BY r.titre;

/*Montrer tous les documents empruntés par une personne  par exemple Marie de login marie123**/
SELECT r.titre, e.etat,p.dateemprunt, p.dateretour_reelle
FROM Ressource r, Exemplaire e, Pret p
WHERE (r.code=e.code AND e.code=p.code AND e.codexemplaire=p.codexemplaire AND p.login='marie123');

/*Montrer tous les documents NON RENDUS et EN RETARD pour une personne*/
select P.login, R.titre, P.dateretour_fixe from Ressource R, Pret P inner join (select A.login from Adherent A inner join Pret P on
A.login = P.login where P.dateretour_reelle IS NULL AND
P.dateretour_fixe < CURRENT_DATE) T on P.login = T.login where P.code = R.code;

/*Jours restants emprunt pour une personne, par exemple Marie de login marie123*/
SELECT r.titre, e.etat, p.dateemprunt, p.dateretour_reelle, p.dateretour_fixe - CURRENT_DATE as NbJoursRestant
FROM Ressource r, Pret p, Exemplaire e
WHERE (r.code=e.code AND p.code=e.code AND p.codexemplaire = e.codexemplaire AND p.login='marie123');


/*Création des vues*/

CREATE VIEW vFilm AS
SELECT R.code , R.titre, R.dpublication, R.editeur, R.genre, R.classification, F.langue, F.longueur, F.synopsis FROM Ressource AS R INNER JOIN Film AS F ON R.code = F.code;

CREATE VIEW vLivre AS
SELECT R.code, R.titre, R.dpublication, R.editeur, R.genre, R.classification,L.ISBN, L.resume, L.langue FROM Ressource AS R INNER JOIN Livre AS L ON R.code = L.code;

CREATE VIEW vMusique AS
SELECT R.code, R.titre, R.dpublication, R.editeur, R.genre, R.classification, M.longueur FROM Ressource AS R INNER JOIN Musique AS M ON R.code = M.code;

CREATE VIEW vAuteur (id, nom, prenom, dnaissance, nationalite) AS
SELECT * From Contributeur, Auteur
WHERE Auteur.idcontrib=Contributeur.idcontrib;

CREATE VIEW vRealisateur (id, nom, prenom, dnaissance, nationalite) AS
SELECT * From Contributeur, Realisateur
WHERE Realisateur.idcontrib=Contributeur.idcontrib;

CREATE VIEW vActeur (id, nom, prenom, dnaissance, nationalite) AS
SELECT * From Contributeur, Acteur
WHERE Acteur.idcontrib=Contributeur.idcontrib;

CREATE VIEW vCompositeur (id, nom, prenom, dnaissance, nationalite) AS
SELECT * From Contributeur, Compositeur
WHERE Compositeur.idcontrib=Contributeur.idcontrib;

CREATE VIEW vInterprete (id, nom, prenom, dnaissance, nationalite) AS
SELECT * From Contributeur, Interprete
WHERE Interprete.idcontrib=Contributeur.idcontrib;

