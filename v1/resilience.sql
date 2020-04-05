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
  communaute VARCHAR REFERENCES Communaute(nom),
  personne VARCHAR REFERENCES Personne(pseudo),
  exclu BOOLEAN,
  PRIMARY KEY(personne, communaute)
);

CREATE TABLE LienCommunaute(
  id SERIAL PRIMARY KEY,
  description VARCHAR,
  communauteDeclarant VARCHAR REFERENCES Communaute(nom),
  communauteConcernee VARCHAR REFERENCES Communaute(nom)
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
  nom VARCHAR PRIMARY KEY,
  description TEXT
);

CREATE TABLE PersonneDeclareSavoirFaire (
  personne VARCHAR REFERENCES Personne(pseudo),
  savoirFaire VARCHAR REFERENCES SavoirFaire(nom),
  degre INTEGER CHECK (degre>=0 AND degre<=5),
  PRIMARY KEY (personne, savoirFaire)
);

CREATE TABLE CommunauteDeclareSavoirFaire (
  communaute VARCHAR REFERENCES Communaute(nom),
  savoirFaire VARCHAR REFERENCES SavoirFaire(nom),
  degre INTEGER CHECK (degre>=0 AND degre<=5),
  PRIMARY KEY (communaute, savoirFaire)
);

CREATE TABLE Service (
  id SERIAL PRIMARY KEY,
  description VARCHAR,
  aDiscuter BOOLEAN,
  montantG1 INTEGER,
  personneQuiPropose VARCHAR REFERENCES Personne(pseudo),
  savoirFaire VARCHAR REFERENCES SavoirFaire(nom),
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

CREATE VIEW vueCommunaute (pseudo, communaute, exclu) AS
SELECT F.personne, F.communaute, F.exclu
FROM PersonneFaitPartieCommunaute F
GROUP BY F.personne, F.communaute
;



INSERT INTO Compte VALUES
('8qQ7UhikRFZspgrnlmzaefeUNiJmAWmmSomuiomyui1x'),
('AhAnDkoiJNiHNhY3s5dBorCnDoFB5ojexuxZdzempooK'),
('kjNhJhbjhkiUuiu3s5dBorCnDoFB5hbjhkiUuiuszoaZ'),
('zazaDoFB5ojexuxZdzempooKAhAnDkoiJNiHNhY3s5dB'),
('orCnDoFB5ojexuxZdzempooKAhAnDkoiJNiHNhY3s5dB'),
('fhGRKEI45fsdDdEF43sF45TESEfEF43sF45TESEffjns'),
('mzaefeUNiJmCnDoFB5hbjhkiUuiuszfhbjhkiUuiuszf'),
('eked34nzeukdjEDJfhj45JZnejkdh3445ERFskdhkedf')
;

INSERT INTO Personne(pseudo, prenom, nom, dateNaissance, longitude, latitude, compte) VALUES
  ('matt', 'Matthieu', 'GLORION', '1997-10-24', 47.390547, -2.955815, '8qQ7UhikRFZspgrnlmzaefeUNiJmAWmmSomuiomyui1x'),
  ('clementdupuis', 'Clément', 'DUPUIS', '1997-10-24', 49.415048, 2.818973, 'AhAnDkoiJNiHNhY3s5dBorCnDoFB5ojexuxZdzempooK'),
  ('mariaidrissi', 'Maria', 'IDRISSI', '1997-10-24', 49.401488, 2.801639, 'kjNhJhbjhkiUuiu3s5dBorCnDoFB5hbjhkiUuiuszoaZ'),
  ('pilo', 'Pilo', 'MILIEU', '1997-10-24', 49.408485, 2.808484, 'zazaDoFB5ojexuxZdzempooKAhAnDkoiJNiHNhY3s5dB'),
  ('bryan', 'Nicolas', 'CALMELS', '1900-01-01', 49.408485, 2.808484, 'orCnDoFB5ojexuxZdzempooKAhAnDkoiJNiHNhY3s5dB')
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

INSERT INTO Communaute(nom, dateCreation, description, longitude, latitude, compte) VALUES
  ('Vegancommunaute', '2020-03-04', 'Cette communauté est déstinée à toute personne végane ou intéréssée par un mode de vie végan', 59.4, 45.34, 'fhGRKEI45fsdDdEF43sF45TESEfEF43sF45TESEffjns'),
  ('Yogacommunaute', '2020-02-04', 'Cette communauté est déstinée à toute personne pratiquant ou intéréssée par le yoga', 65.4, 75.34, 'mzaefeUNiJmCnDoFB5hbjhkiUuiuszfhbjhkiUuiuszf'),
  ('Jardinagecommunaute', '2020-02-04', 'Cette communauté est déstinée à toute personne pratiquant ou intéréssée par le jardinage', 34.4, 29.34, 'eked34nzeukdjEDJfhj45JZnejkdh3445ERFskdhkedf')
;

INSERT INTO LienCommunaute(description, communauteDeclarant, communauteConcernee) VALUES
('Les gens de la Vegancommunaute peuvent faire des séances de yoga avec la Yogacommunaute','Vegancommunaute','Yogacommunaute'),
('Les gens de la Yogacommunaute peuvent faire des séances de jardinage avec la Jardinagecommunaute','Yogacommunaute','Jardinagecommunaute'),
('Les gens de la Jardinagecommunaute peuvent donner des légumes à la Vegancommunaute','Jardinagecommunaute','Vegancommunaute')
;

INSERT INTO PersonneFaitPartieCommunaute(personne, communaute, exclu) VALUES
('matt', 'Jardinagecommunaute', '0'),
('mariaidrissi', 'Yogacommunaute', '0'),
('clementdupuis', 'Vegancommunaute', '0')
;

INSERT INTO SavoirFaire(nom, description) VALUES
  ('jardinage', 'savoir faire pousser des plantes'),
  ('cuisine', 'savoir faire pousser des plats'),
  ('peinture', 'savoir peindre'),
  ('nouage_de_lacets', 'savoir nouer ses lacets'),
  ('navigation', 'savoir naviguer avec un bateau')
;

INSERT INTO PersonneDeclareSavoirFaire VALUES
  ('matt', 'nouage_de_lacets', '0'),
  ('matt', 'navigation', '5'),
  ('matt', 'jardinage', '4'),
  ('matt', 'cuisine', '4')
;
