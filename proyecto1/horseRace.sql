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
    CHECK (tipo IN ('Pura_Sangre', 'Quarter', 'Arabe', 'Appaloosa')),
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
    inicio NUMBER,
    pos_final   NUMBER,
    color       VARCHAR2(80),
    carrera     NUMBER,
    caballo     NUMBER,
    jockey      REF jockey_t REFERENCES JOCKEY,
    PRIMARY KEY(inicio, carrera),
    FOREIGN KEY(carrera) REFERENCES CARRERA(num_carrera)
);
/

-- verificar caballo con tipo de carrera del arranque
TRIGGER BEFORE INSERT OR UPDATE ON ARRANQUE
    -- comparar tipo de caballo con tipo de carrera
    -- si no son compatibles raise_application_error();
        -- Pura Sangre  -> 400m, 2km, campo traviesa
        -- Quarter      -> 400m, 2km, tiro-de-carro
        -- Árabe        -> tiro-de-carro, carrera con obstáculos
        -- Appaloosa    -> carrera de obstáculos, campo traviesa
    
-- comparar tipo de caballo con técnica de entrenamiento del entrenador
TRIGGER BEFORE INSERT OR UPDATE ON CABALLO
    -- :new.tipo V.S. :new.trainer.tecnicas
    
-- reparte el premio de una carrera ganada en primer lugar
TRIGGER AFTER INSERT OR UPDATE ON ARRANQUE WHEN (NEW.posicion_final = 1)
    -- UPDATE SALARIO DE JOCKEY, UN INCREMENTO DEL 20% DEL PREMIO DEL ARRANQUE
    -- UPDATE SALARIO DE ENTRENADOR, UN INCREMENTO DEL 10% DEL PREMIO DEL ARRANQUE
    -- UPDATE DUENOS DE CABALLO, UN INCREMENTO DEL 80% DEL PREMIO A GANANCIAS