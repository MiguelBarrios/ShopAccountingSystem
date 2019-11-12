DROP TABLE Customer

CREATE TABLE Customer (
    firstname       VARCHAR(32),
    lastname        VARCHAR(32),
    streetNumber    VARCHAR(12)         NOT NULL,
    streetName      VARCHAR(32)         NOT NULL,
    city            VARCHAR(32)         NOT NULL,
    state           VARCHAR(2)          NOT NULL,   /*State abbrev*/
    zip             INT                 NOT NULL,            
    category        INT,
    CONSTRAINT inCategory_Range CHECK (category > 0 AND category <= 10),
    CONSTRAINT PK_Customer PRIMARY KEY (firstname, lastname),   
    CONSTRAINT zipCode_range CHECK (ZIP <= 99999),
    CONSTRAINT valide_statAbb CHECK (len(state) = 2)
);

INSERT INTO Customer
    (firstname, lastname, streetNumber, streetName, city, state, zip, category)
VALUES
    ('Miguel', 'BarriosDavila', 1800, 'Beaumont Drive', 'Norman', 'OK', 73071, 4)

INSERT INTO Customer
    (firstname, lastname, streetNumber, streetName, city, state, zip, category)
VALUES
    ('Bob', 'Dole', 1800, 'Beaumont Drive', 'Norman', 'OK', 83071, 9)



SELECT * FROM Customer