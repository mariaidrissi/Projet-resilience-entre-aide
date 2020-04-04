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
  id INTEGER PRIMARY KEY,
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
  id INTEGER PRIMARY KEY,
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
  id INTEGER PRIMARY KEY,
  description VARCHAR,
  aDiscuter BOOLEAN,
  montantG1 INTEGER,
  personneQuiPropose VARCHAR REFERENCES Personne(pseudo),
  savoirFaire INTEGER REFERENCES SavoirFaire(id),
  contrePartie INTEGER REFERENCES Service(id)
);

CREATE TABLE Message (
  id INTEGER PRIMARY KEY,
  message TEXT,
  expediteurPersonne VARCHAR REFERENCES Personne(pseudo),
  expediteurCommunaute VARCHAR REFERENCES Communaute(nom),
  destinatairePersonne VARCHAR REFERENCES Personne(pseudo),
  destinataireCommunaute VARCHAR REFERENCES Communaute(nom),
  ref INTEGER REFERENCES Message(id),
  premiereRef INTEGER REFERENCES Message(id)
);
