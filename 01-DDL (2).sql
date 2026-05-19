BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE city';
   EXECUTE IMMEDIATE 'DROP TABLE country';
   EXECUTE IMMEDIATE 'DROP TABLE countrylanguage';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/
CREATE TABLE country 
(
  Code char(3) DEFAULT '' NOT NULL,
  Name char(52) DEFAULT '' NOT NULL,
  Continent varchar(15) DEFAULT 'Asia' NOT NULL check(Continent IN('Asia','Europe','North America','Africa','Oceania','Antarctica','South America')),
  Region char(26) DEFAULT '' NOT NULL,
  SurfaceArea number(10,2) DEFAULT 0.00 NOT NULL,
  IndepYear number(6) DEFAULT NULL,
  Population number(11) DEFAULT 0 NOT NULL ,
  LifeExpectancy number(3,1) DEFAULT NULL,
  GNP number(10,2) DEFAULT NULL,
  GNPOld number(10,2) DEFAULT NULL,
  LocalName char(45) DEFAULT '' NOT NULL ,
  GovernmentForm char(45) DEFAULT '' NOT NULL ,
  HeadOfState char(60) DEFAULT NULL,
  Capital number(11) DEFAULT NULL,
  Code2 char(2)DEFAULT '' NOT NULL ,
  PRIMARY KEY (Code)
);

CREATE TABLE city (
  ID number(10) NOT NULL,
  Name char(35) DEFAULT '' NOT NULL,
  CountryCode char(3) DEFAULT '' NOT NULL,
  District char(30) DEFAULT '',
  Population number(10) DEFAULT 0 NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (CountryCode) REFERENCES country (Code)
);

CREATE TABLE countrylanguage (
  CountryCode CHAR(3) DEFAULT '' NOT NULL,
  Language CHAR(30) DEFAULT '' NOT NULL,
  IsOfficial char(1) DEFAULT 'F' NOT NULL check(IsOfficial IN('T','F')),
  Percentage number(4,1) DEFAULT 0 NOT NULL,
  PRIMARY KEY (CountryCode,Language),
  FOREIGN KEY (CountryCode) REFERENCES country (Code)
) ;
