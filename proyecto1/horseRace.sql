create or replace type persona_t as object (
    rfc         varchar2(80),
    nombre      varchar2(80),
    telefono    varchar2(80),
    sexo        char(1),
    direccion   varchar2(80)
) NOT FINAL;
/

create or replace type dueno_t under persona_t(
    ganancias       NUMBER(8,2)
);
/

CREATE TYPE tecnicas_array AS VARRAY(4) OF VARCHAR2(80);
/

create or replace type entrenador_t under persona_t(
    experiencia         NUMBER,
    tecnicas            tecnicas_array,
    salario             NUMBER(8,2)
);
/

create or replace type jockey_t under persona_t(
    estatura        NUMBER(8,2),
    peso            NUMBER(8,2),
    edad            NUMBER,
    salario         NUMBER(8,2)
);
/

CREATE TABLE DUENO OF dueno_t (
    PRIMARY KEY(rfc)
);
/

CREATE TABLE ENTRENADOR OF entrenador_t (
    PRIMARY KEY(rfc)
);
/

CREATE TABLE JOCKEY OF jockey_t (
    PRIMARY KEY(rfc)
);
/

CREATE TABLE CABALLO (
    reg     NUMBER,
    nombre  VARCHAR2(20),
    fecha_nac   DATE,
    genero char(1),
    tipo    VARCHAR2(80),
    entrenador  REF entrenador_t REFERENCES ENTRENADOR,
    CHECK (tipo IN ('Pura_Sangre', 'Quarter', 'Árabe', 'Appaloosa')),
    PRIMARY KEY(reg)
);
/

CREATE TABLE PROPIEDAD_DE (
    caballo         NUMBER,
    dueno           VARCHAR2(80),
    porcentaje      NUMBER(3,2), --revisar que sea porcentaje de 0 a 1
    PRIMARY KEY(caballo, dueno),
    FOREIGN KEY(dueno) REFERENCES DUENO(rfc)
);
/

CREATE TABLE CARRERA (
    num_carrera     NUMBER,
    premio          NUMBER,
    fecha_carr      DATE,
    tipo            VARCHAR2(80),
    PRIMARY KEY(num_carrera)
);
/

CREATE TABLE ARRANQUE (
    inicio      NUMBER,
    pos_final   NUMBER,
    color       VARCHAR2(80),
    carrera     NUMBER,
    caballo     NUMBER,
    jockey      REF jockey_t REFERENCES JOCKEY,
    PRIMARY KEY(inicio, carrera),
    FOREIGN KEY(carrera) REFERENCES CARRERA(num_carrera)
);
/

-- TRIGGER 1
-- Trigger que valida que el tipo de caballo corresponde al tipo de carrera en la que participa -> testeado check
CREATE OR REPLACE TRIGGER VALIDA_CABALLO_CARRERA
    BEFORE INSERT OR UPDATE ON ARRANQUE
    FOR EACH ROW

    DECLARE
        tipo_carrera CARRERA.tipo%TYPE;
        tipo_caballo CABALLO.tipo%TYPE;
        
    BEGIN
    -- Se almacena el tipo de carrera y el tipo de caballo en las variables
    SELECT carr.tipo, cab.tipo
    INTO tipo_carrera, tipo_caballo
    FROM CARRERA carr, CABALLO cab
    WHERE carr.num_carrera = :NEW.carrera 
        AND cab.reg = :NEW.caballo;
    
    -- Se valida que corresponda el tipo de caballo para el tipo de carrera
    IF (tipo_carrera = 'Carrera plana' AND tipo_caballo NOT IN ('Pura_Sangre', 'Quarter')) THEN
        RAISE_APPLICATION_ERROR(-20001, 'No correspone el tipo de caballo con el tipo de carrera');

    ELSIF (tipo_carrera = 'Carrera de campo') AND tipo_caballo NOT IN ('Pura_Sangre', 'Appaloosa') THEN
        RAISE_APPLICATION_ERROR(-20001, 'No correspone el tipo de caballo con el tipo de carrera');

    ELSIF (tipo_carrera = 'Carrera de tiro') AND tipo_caballo NOT IN ('Quarter', 'Arabe') THEN
        RAISE_APPLICATION_ERROR(-20001, 'No correspone el tipo de caballo con el tipo de carrera');

    ELSIF (tipo_carrera = 'Carrera de salto') AND tipo_caballo NOT IN ('Árabe', 'Appaloosa') THEN
        RAISE_APPLICATION_ERROR(-20001, 'No correspone el tipo de caballo con el tipo de carrera');
    END IF;
    
END;
/


-- TRIGGER 2
-- Trigger que valida que el corresponde a la técnica de entrenamiento que domina su entrenador
CREATE OR REPLACE TRIGGER VALIDA_CABALLO_ENTRENADOR
    BEFORE INSERT OR UPDATE ON CABALLO 
    FOR EACH ROW

    DECLARE
        tipo_caballo CABALLO.tipo%TYPE;
        tecnicas ENTRENADOR.tecnicas%TYPE;
        v_found BOOLEAN := false;
        v_index INTEGER;

    BEGIN
        -- Valida que el insert o update contenga REF de entrenador
        IF (:NEW.entrenador IS NOT NULL) THEN
            tipo_caballo := :NEW.tipo;
            
            SELECT DEREF(:NEW.entrenador).tecnicas INTO tecnicas FROM DUAL;
            
            v_index := tecnicas.FIRST;
            
            -- Valida que el entrenador domine al menos una técnica
            IF (v_index IS NOT NULL) THEN
            
                -- Valida si el entrenador domina alguna técnica para el tipo de caballo
                IF (tipo_caballo = 'Pura_Sangre') THEN
                    WHILE NOT v_found AND v_index IS NOT NULL LOOP
                        IF tecnicas(v_index) = 'Carrera plana' OR tecnicas(v_index) = 'Carrera de campo' THEN
                            v_found := true;
                        ELSE
                            v_index := tecnicas.NEXT(v_index);
                        END IF;
                    END LOOP;
                    
                    IF NOT v_found THEN
                        RAISE_APPLICATION_ERROR(-20002, 'El entrenador no domina ninguna técnica del tipo de caballo');
                    END IF;
                    
                ELSIF (tipo_caballo = 'Quarter') THEN
                    WHILE NOT v_found AND v_index IS NOT NULL LOOP
                        IF tecnicas(v_index) = 'Carrera plana' OR tecnicas(v_index) = 'Carrera de tiro' THEN
                            v_found := true;
                        ELSE
                            v_index := tecnicas.NEXT(v_index);
                        END IF;
                    END LOOP;
                    
                    IF NOT v_found THEN
                        RAISE_APPLICATION_ERROR(-20002, 'El entrenador no domina ninguna técnica del tipo de caballo');
                    END IF;
                    
                ELSIF (tipo_caballo = 'Appaloosa') THEN
                    WHILE NOT v_found AND v_index IS NOT NULL LOOP
                        IF tecnicas(v_index) = 'Carrera de campo' OR tecnicas(v_index) = 'Carrera de salto' THEN
                            v_found := true;
                        ELSE
                            v_index := tecnicas.NEXT(v_index);
                        END IF;
                    END LOOP;
                    
                    IF NOT v_found THEN
                        RAISE_APPLICATION_ERROR(-20002, 'El entrenador no domina ninguna técnica del tipo de caballo');
                    END IF;
                    
                ELSIF (tipo_caballo = 'Árabe') THEN
                    WHILE NOT v_found AND v_index IS NOT NULL LOOP
                        IF tecnicas(v_index) = 'Carrera de tiro' OR tecnicas(v_index) = 'Carrera de salto' THEN
                            v_found := true;
                        ELSE
                            v_index := tecnicas.NEXT(v_index);
                        END IF;
                    END LOOP;
                    
                    IF NOT v_found THEN
                        RAISE_APPLICATION_ERROR(-20002, 'El entrenador no domina ninguna técnica del tipo de caballo');
                    END IF;
                END IF;
            
            ELSE
                -- El entrenador no domina ninguna técnica
                RAISE_APPLICATION_ERROR(-20000, 'El entrenador no domina ninguna técnica');
            END IF;
        END IF;
    END;
/

-- TRIGGER 3
-- reparte el premio de una carrera ganada en primer lugar
CREATE OR REPLACE TRIGGER REPARTE_GANANCIAS
    AFTER INSERT OR UPDATE ON ARRANQUE
    FOR EACH ROW
        WHEN (NEW.pos_final = 1)
        
        DECLARE 
            v_num_duenos NUMBER;
            v_premio NUMBER;
        BEGIN
            -- saca num de dueños
            SELECT COUNT(d.rfc) 
            INTO v_num_duenos 
            FROM DUENO d
            WHERE d.rfc IN (
                SELECT p.dueno
                FROM PROPIEDAD_DE p
                WHERE p.caballo = :NEW.caballo
            );
            
            -- saca premio
            SELECT c.premio INTO v_premio FROM CARRERA c WHERE c.num_carrera = :NEW.carrera; 
            
            -- Agrega ganancias a dueños
            UPDATE DUENO d
            SET d.ganancias = d.ganancias + v_premio * 0.8 / v_num_duenos
            WHERE d.rfc in (
                SELECT p.dueno
                FROM PROPIEDAD_DE p
                WHERE p.caballo = :NEW.caballo
            );
            
            -- Agrega salario a entrenador
            UPDATE ENTRENADOR e
            SET e.salario = e.salario + v_premio * 0.1
            WHERE e.rfc = (
                SELECT c.entrenador.rfc
                FROM CABALLO c
                WHERE c.reg = :NEW.caballo
            );
            
            -- Agrega ganancias a jinete
            UPDATE JOCKEY j
            SET j.salario = j.salario + v_premio * 0.1
            WHERE REF(j) = :NEW.jockey;
        END;
/


-- INSERTS

-- DUENO -> rfc, nombre, telefono, sexo, direccion, ganancias
INSERT INTO DUENO VALUES('d1', 'Dueno1', '8110', 'M', 'Dir', 0);
INSERT INTO DUENO VALUES('d2', 'Dueno2', '8111', 'F', 'Dir', 10);
/

-- ENTRENADOR -> rfc, nombre, telefono, sexo, direccion, experiencia, tecnicas, salario
INSERT INTO ENTRENADOR VALUES('e1', 'Entrenador1', '8112', 'F', 'Dir', 1, tecnicas_array(), 100);
INSERT INTO ENTRENADOR VALUES('e2', 'Entrenador2', '8113', 'M', 'Dir', 2, tecnicas_array('Carrera plana'), 1000);
INSERT INTO ENTRENADOR VALUES('e3', 'Entrenador3', '8114', 'M', 'Dir', 1, tecnicas_array('Carrera de campo', 'Carrera de salto'), 0);
/

-- JOCKEY -> rfc, nombre, telefono, sexo, direccion, estatura, peso, edad, salario
INSERT INTO JOCKEY VALUES('j1', 'Jockey1', '8125', 'F', 'Dir', 1.72, 58.45, 33, 10);

-- CABALLO -> reg, nombre, fecha_nac, genero, tipo, REF(entrenador)
INSERT INTO CABALLO VALUES(111, 'Apache', NULL, 'M', 'Pura_Sangre', NULL);
INSERT INTO CABALLO VALUES(112, 'Pinta', NULL, 'H', 'Appaloosa', NULL);
INSERT INTO CABALLO VALUES(113, 'Cherokee', NULL, 'M', 'Quarter', NULL);
INSERT INTO CABALLO VALUES(114, 'Moro', NULL, 'M', 'Árabe', NULL);
/

-- CARRERA -> num_carrera, premio, fecha_carr, tipo
INSERT INTO CARRERA VALUES(1, 100, NULL, 'Carrera plana');
INSERT INTO CARRERA VALUES(2, 100, NULL, 'Carrera de campo');
INSERT INTO CARRERA VALUES(3, 100, NULL, 'Carrera de tiro');
INSERT INTO CARRERA VALUES(4, 100, NULL, 'Carrera de salto');
/
-- ARRANQUE -> inicio, pos_final, color, carrera, caballo, REF(jockey)
INSERT INTO ARRANQUE VALUES(1, 1, 'Azul', 1, 111, NULL);
INSERT INTO ARRANQUE VALUES(1, 2, 'Verde', 2, 112, NULL);
INSERT INTO ARRANQUE VALUES(3, 3, 'Negro', 3, 113, NULL);
INSERT INTO ARRANQUE VALUES(5, 2, 'Café', 4, 114, NULL);
/

-- PROPIEDAD_DE -> caballo, dueno, porcentaje
INSERT INTO PROPIEDAD_DE VALUES(111, 'd1', 1);
INSERT INTO PROPIEDAD_DE VALUES(114, 'd1', 0.5);
INSERT INTO PROPIEDAD_DE VALUES(114, 'd2', 0.5);


UPDATE CABALLO
SET entrenador = (
    SELECT REF(e)
    FROM ENTRENADOR e
    WHERE e.rfc = 'e2'
)
WHERE reg = 111;
/

UPDATE CABALLO
SET entrenador = (
    SELECT REF(e)
    FROM ENTRENADOR e
    WHERE e.rfc = 'e3'
)
WHERE reg = 114;
/

--Test trigger 1
--Input aceptado sin errores
INSERT INTO CARRERA(
	num_carrera, premio, fecha_carr, tipo)
	VALUES (8, 2000, TO_DATE('17/12/2015', 'DD/MM/YYYY'), 'Carrera plana');
	
INSERT INTO ARRANQUE(inicio, pos_final, color, carrera, caballo, jockey)
	VALUES (1, 3, 'Café', 8, 113, NULL);

--Error: El tipo de caballo no coincide con el tipo de carrera
INSERT INTO CARRERA(
	num_carrera, premio, fecha_carr, tipo)
	VALUES (9, 2000, TO_DATE('17/12/2015', 'DD/MM/YYYY'), 'Carrera plana');
	
INSERT INTO ARRANQUE(inicio, pos_final, color, carrera, caballo, jockey)
	VALUES (2, 3, 'Café', 9, 114, NULL);

-- TEST trigger 2
UPDATE CABALLO
SET entrenador = (
    SELECT REF(e)
    FROM ENTRENADOR e
    WHERE e.rfc = 'e1'
)
WHERE reg = 112;
/

-- TEST Trigger 2
UPDATE CABALLO
SET entrenador = (
    SELECT REF(e)
    FROM ENTRENADOR e
    WHERE e.rfc = 'e2'
)
WHERE reg = 111;
/

--TEST trigger 3
    -- Ver ganancias antes
    SELECT rfc, nombre, ganancias FROM DUENO;
    SELECT rfc, nombre, salario FROM ENTRENADOR;
    SELECT rfc, nombre, salario FROM JOCKEY;
    -- inserts
    INSERT INTO CARRERA VALUES(5, 100, NULL, 'Carrera de salto');
    INSERT INTO PROPIEDAD_DE VALUES(112, 'd1', 0.5);
    INSERT INTO PROPIEDAD_DE VALUES(112, 'd2', 0.5);
    UPDATE CABALLO
    SET entrenador = (
        SELECT REF(e)
        FROM ENTRENADOR e
        WHERE e.rfc = 'e3'
    )
    WHERE reg = 112;
/
    -- Arranque
    INSERT INTO ARRANQUE VALUES(1, 1, 'Verde', 5, 112, NULL);
    
    -- Resultados
    SELECT rfc, nombre, ganancias FROM DUENO;
    SELECT rfc, nombre, salario FROM ENTRENADOR;
    SELECT rfc, nombre, salario FROM JOCKEY;
