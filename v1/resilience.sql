DROP TABLE IF EXISTS Compte, Personne, LienPersonne, Communaute, PersonneFaitPartieCommunaute, LienCommunaute, Vote, SavoirFaire, PersonneDeclareSavoirFaire, CommunauteDeclareSavoirFaire, Service, Message;

CREATE TABLE Compte (
  clePublique VARCHAR PRIMARY KEY
);

CREATE TABLE Personne (
  pseudo VARCHAR PRIMARY KEY,
  prenom VARCHAR,
  nom VARCHAR,
  dateNaissance DATE,
  longitude DECIMAL,
  latitude DECIMAL,
  compte VARCHAR REFERENCES Compte(clePublique)
);

CREATE TABLE LienPersonne (
  id SERIAL PRIMARY KEY,
  description VARCHAR,
  personneDeclarant VARCHAR REFERENCES Personne(pseudo),
  personneConcernee VARCHAR REFERENCES Personne(pseudo)
);

CREATE TABLE Communaute (
  nom VARCHAR PRIMARY KEY,
  dateCreation DATE,
  description TEXT,
  longitude DECIMAL,
  latitude DECIMAL,
  compte VARCHAR REFERENCES Compte(clePublique)
);

CREATE TABLE PersonneFaitPartieCommunaute(
  personne VARCHAR REFERENCES Personne(pseudo),
  communaute VARCHAR REFERENCES Communaute(nom),
  exclu BOOLEAN,
  PRIMARY KEY(personne, communaute)
);

CREATE TABLE LienCommunaute(
  description VARCHAR,
  PRIMARY KEY(CommunauteQuiDeclare, CommunauteConcernee),
  CommunauteQuiDeclare VARCHAR REFERENCES Communaute(nom),
  CommunauteConcernee VARCHAR REFERENCES Communaute(nom)
);

CREATE TABLE Vote(
  contre BOOLEAN,
  dateVote DATE,
  personneVotante VARCHAR REFERENCES Personne(pseudo),
  personneConcernee VARCHAR REFERENCES Personne(pseudo),
  communauteConcernee VARCHAR REFERENCES Communaute(nom),
  PRIMARY KEY (personneVotante, personneConcernee, communauteConcernee)
);

CREATE TABLE SavoirFaire (
  id SERIAL PRIMARY KEY,
  degre INTEGER CHECK (degre>=0 AND degre<=5),
  description TEXT
);

CREATE TABLE PersonneDeclareSavoirFaire (
  personne VARCHAR REFERENCES Personne(pseudo),
  savoirFaire INTEGER REFERENCES SavoirFaire(id)
);

CREATE TABLE CommunauteDeclareSavoirFaire (
  communaute VARCHAR REFERENCES Communaute(nom),
  savoirFaire INTEGER REFERENCES SavoirFaire(id),
  PRIMARY KEY (Communaute, SavoirFaire)
);

CREATE TABLE Service (
  id SERIAL PRIMARY KEY,
  description VARCHAR,
  aDiscuter BOOLEAN,
  montantG1 INTEGER,
  personneQuiPropose VARCHAR REFERENCES Personne(pseudo),
  savoirFaire INTEGER REFERENCES SavoirFaire(id),
  contrePartie INTEGER REFERENCES Service(id)
);

CREATE TABLE Message (
  id SERIAL PRIMARY KEY,
  message TEXT,
  expediteurPersonne VARCHAR REFERENCES Personne(pseudo),
  expediteurCommunaute VARCHAR REFERENCES Communaute(nom),
  destinatairePersonne VARCHAR REFERENCES Personne(pseudo),
  destinataireCommunaute VARCHAR REFERENCES Communaute(nom),
  ref INTEGER REFERENCES Message(id),
  premiereRef INTEGER REFERENCES Message(id)
);

INSERT INTO Compte VALUES
('8qQ7UhikRFZspgrnlmzaefeUNiJmAWmmSomuiomyui1x'),
('AhAnDkoiJNiHNhY3s5dBorCnDoFB5ojexuxZdzempooK'),
('kjNhJhbjhkiUuiu3s5dBorCnDoFB5hbjhkiUuiuszoaZ'),
('orCnDoFB5ojexuxZdzempooKAhAnDkoiJNiHNhY3s5dB'),
('orCnDoRFZspgrnlmzaRFZspgrnlmzaKAhAnDkoY3s5dB')
;

INSERT INTO Personne(pseudo, prenom, nom, dateNaissance, longitude, latitude, compte) VALUES
  ('matt', 'Matthieu', 'GLORION', '1997-10-24', 47.390547, -2.955815, '8qQ7UhikRFZspgrnlmzaefeUNiJmAWmmSomuiomyui1x'),
  ('clementdupuis', 'Clément', 'DUPUIS', '1997-10-24', 49.415048, 2.818973, 'AhAnDkoiJNiHNhY3s5dBorCnDoFB5ojexuxZdzempooK'),
  ('mariaidrissi', 'Maria', 'IDRISSI', '1997-10-24', 49.401488, 2.801639, 'kjNhJhbjhkiUuiu3s5dBorCnDoFB5hbjhkiUuiuszoaZ'),
  ('pilo', 'Pilo', 'MILIEU', '1997-10-24', 49.408485, 2.808484, 'orCnDoFB5ojexuxZdzempooKAhAnDkoiJNiHNhY3s5dB'),
  ('bryan', 'Nicolas', 'CALMELS', '1900-01-01', 49.408485, 2.808484, 'orCnDoRFZspgrnlmzaRFZspgrnlmzaKAhAnDkoY3s5dB')
;

INSERT INTO LienPersonne(description, personneDeclarant, personneConcernee) VALUES
  ('collaboration NA17', 'matt', 'mariaidrissi'),
  ('collaboration NA17', 'matt', 'clementdupuis'),
  ('collaboration NA17', 'clementdupuis', 'mariaidrissi'),
  ('collaboration NA17', 'clementdupuis', 'matt'),
  ('collaboration NA17', 'mariaidrissi', 'matt'),
  ('collaboration NA17', 'mariaidrissi', 'clementdupuis'),
  ('voisin', 'matt', 'pilo'),
  ('chef de grafhit', 'bryan', 'matt')
;
