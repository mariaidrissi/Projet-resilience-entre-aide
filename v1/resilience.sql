DROP TABLE IF EXISTS
Position, Compte, Personne, LienPersonne, Communaute,
PersonneFaitPartieCommunaute, LienCommunaute,
Vote, SavoirFaire, PersonneDeclareSavoirFaire,
CommunauteDeclareSavoirFaire, Service, Message
CASCADE
;

CREATE TABLE Position (
  id SERIAL PRIMARY KEY,
  latitude DECIMAL,
  longitude DECIMAL
);

CREATE TABLE Compte (
  clePublique VARCHAR PRIMARY KEY
);

CREATE TABLE Personne (
  pseudo VARCHAR PRIMARY KEY,
  prenom VARCHAR,
  nom VARCHAR,
  dateNaissance DATE,
  position INTEGER REFERENCES Position(id),
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
  position INTEGER REFERENCES Position(id),
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

CREATE OR REPLACE FUNCTION distance(lat1 DECIMAL, lon1 DECIMAL, lat2 DECIMAL, lon2 DECIMAL) RETURNS DECIMAL AS $$
DECLARE
    x float = 111.12 * (lat2 - lat1);
    y float = 111.12 * (lon2 - lon1) * cos(lat1 / 92.215);
BEGIN
    RETURN sqrt(x * x + y * y);
END
$$ LANGUAGE plpgsql;
;

CREATE VIEW vueCommunaute (pseudo, communaute, exclu) AS
  SELECT F.personne, F.communaute, F.exclu
  FROM PersonneFaitPartieCommunaute F
  GROUP BY F.personne, F.communaute
;

CREATE VIEW vueMessage (idMessage, contenu, idMessagePrecedent, idMessageOrigine) AS
  SELECT id, message, ref, premiereRef
  FROM Message
;

CREATE VIEW vueProches(distance_km, pseudo1, communaute1, personneProche, communauteProche) AS
  SELECT X.distance, X.pseudo1, X.commu1, X.pseudo2, X.commu2
  FROM (
    SELECT distance(P1.latitude, P1.longitude, P2.latitude, P2.longitude) AS distance,
      Pers1.pseudo AS pseudo1,
      C1.nom AS commu1,
      Pers2.pseudo AS pseudo2,
      C2.nom AS commu2
    FROM  Communaute C1 FULL JOIN Personne Pers1 ON C1.position = Pers1.Position,
          Communaute C2 FULL JOIN Personne Pers2 ON C2.position = Pers2.Position,
          Position P1, Position P2
    WHERE P1.id<>P2.id
      AND (P1.id = C1.position OR P1.id = Pers1.position)
      AND (P2.id = C2.position OR P2.id = Pers2.position)
  ) X
  GROUP BY X.pseudo1, X.commu1, X.pseudo2, X.commu2, X.distance
  HAVING distance < 1
;



-- INSERTIONS

INSERT INTO Compte VALUES
('8qQ7UhikRFZspgrnlmzaefeUNiJmAWmmSomuiomyui1x'),
('AhAnDkoiJNiHNhY3s5dBorCnDoFB5ojexuxZdzempooK'),
('kjNhJhbjhkiUuiu3s5dBorCnDoFB5hbjhkiUuiuszoaZ'),
('zazaDoFB5ojexuxZdzempooKAhAnDkoiJNiHNhY3s5dB'),
('orCnDoFB5ojexuxZdzempooKAhAnDkoiJNiHNhY3s5dB'),
('fhGRKEI45fsdDdEF43sF45TESEfEF43sF45TESEffjns'),
('mzaefeUNiJmCnDoFB5hbjhkiUuiuszfhbjhkiUuiuszf'),
('eked34nzeukdjEDJfhj45JZnejkdh3445ERFskdhkedf'),
('pouzaeoiuazeiuqdfsbdckjsnqdkqsdkqsdkqsdjhefl')
;

INSERT INTO Position(latitude, longitude) VALUES
(47.390547, -2.955815),
(49.415048, 2.818973),
(49.412011, 2.815001),
(49.413449, 2.815280),
(49.408485, 2.808484),
(59.4, 45.34),
(65.4, 75.34),
(34.4, 29.34),
(49.415629, 2.818578)
;

INSERT INTO Personne(pseudo, prenom, nom, dateNaissance, position, compte) VALUES
  ('matt', 'Matthieu', 'GLORION', '1997-10-24', 1, '8qQ7UhikRFZspgrnlmzaefeUNiJmAWmmSomuiomyui1x'),
  ('clementdupuis', 'Clément', 'DUPUIS', '1997-10-24', 2, 'AhAnDkoiJNiHNhY3s5dBorCnDoFB5ojexuxZdzempooK'),
  ('mariaidrissi', 'Maria', 'IDRISSI', '1997-10-24', 3, 'kjNhJhbjhkiUuiu3s5dBorCnDoFB5hbjhkiUuiuszoaZ'),
  ('pilo', 'Pilo', 'MILIEU', '1997-10-24', 4, 'zazaDoFB5ojexuxZdzempooKAhAnDkoiJNiHNhY3s5dB'),
  ('bryan', 'Nicolas', 'CALMELS', '1900-01-01', 5, 'orCnDoFB5ojexuxZdzempooKAhAnDkoiJNiHNhY3s5dB')
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

INSERT INTO Communaute(nom, dateCreation, description, position, compte) VALUES
  ('Vegancommunaute', '2020-03-04', 'Cette communauté est déstinée à toute personne végane ou intéréssée par un mode de vie végan', 6, 'fhGRKEI45fsdDdEF43sF45TESEfEF43sF45TESEffjns'),
  ('Yogacommunaute', '2020-02-04', 'Cette communauté est déstinée à toute personne pratiquant ou intéréssée par le yoga', 7, 'mzaefeUNiJmCnDoFB5hbjhkiUuiuszfhbjhkiUuiuszf'),
  ('Jardinagecommunaute', '2020-02-04', 'Cette communauté est déstinée à toute personne pratiquant ou intéréssée par le jardinage', 8, 'eked34nzeukdjEDJfhj45JZnejkdh3445ERFskdhkedf'),
  ('etudiantsUTC', '2020-02-04', 'Cette communauté est déstinée à tous les étudiants et étudiantes de l"UTC', 9, 'pouzaeoiuazeiuqdfsbdckjsnqdkqsdkqsdkqsdjhefl')
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

INSERT INTO CommunauteDeclareSavoirFaire VALUES
  ('Jardinagecommunaute', 'jardinage', '5'),
  ('Jardinagecommunaute', 'cuisine', '3'),
  ('Vegancommunaute', 'jardinage', '2'),
  ('Vegancommunaute', 'cuisine', '5')
;

INSERT INTO Vote(contre, dateVote, personneVotante, personneConcernee, communauteConcernee) VALUES
  (FALSE, '2020-03-04', 'mariaidrissi', 'matt', 'Yogacommunaute'),
  (TRUE, '2020-01-04', 'matt', 'mariaidrissi', 'Jardinagecommunaute'),
  (FALSE, '2020-02-04', 'matt', 'clementdupuis', 'Jardinagecommunaute'),
  (FALSE, '2020-04-04', 'clementdupuis', 'mariaidrissi', 'Vegancommunaute')
;

INSERT INTO Service (description, aDiscuter, personneQuiPropose, savoirFaire) VALUES
  ('Jardinage à domicile pour personnes agées', FALSE, 'matt', 'jardinage'),
  ('Cuisine de plats asiatiques', FALSE, 'clementdupuis', 'cuisine'),
  ('Peindre les murs de la maison', FALSE, 'mariaidrissi', 'peinture')
;

INSERT INTO Message(message, expediteurPersonne, expediteurCommunaute, destinatairePersonne, destinataireCommunaute, ref, premiereRef) VALUES
  ('Est-ce que tu recommandes une marque de peinture ?', 'clementdupuis', NULL, 'mariaidrissi', NULL, NULL, NULL),
  ('La peinture disponible au magasin du coté du cinéma est convenable', 'mariaidrissi', NULL, 'clementdupuis', NULL, 1, 1),
  ('Dacc, merci.', 'clementdupuis', NULL, 'mariaidrissi', NULL, 2, 1),
  ('Seriez vous interessé par nos fruits et légumes de saison?', NULL, 'Jardinagecommunaute', NULL, 'Vegancommunaute', NULL, NULL)
 ;
