
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE TYPE public.presence_enum AS ENUM (
    'absent',
    'present',
    'peut etre',
    'en attente'
);

CREATE TYPE public.statut_enum AS ENUM (
    'Pending',
    'Approuve',
    'Refuse'
);

CREATE TYPE public.type_actualite_enum AS ENUM (
    'Article',
    'Evenement'
);

CREATE TABLE public.association (
    id_association integer NOT NULL,
    nom character varying(50) NOT NULL,
    type_structure character varying(50) NOT NULL,
    sport text NOT NULL,
    adresse text NOT NULL,
    adresse_2 text NOT NULL,
    description text NOT NULL,
    date_creation date NOT NULL,
    image text NOT NULL,
    code_postal integer NOT NULL,
    ville character varying(50) NOT NULL,
    pays character varying(50) NOT NULL,
    couleur_1 character varying(50) NOT NULL,
    couleur_2 character varying(50) NOT NULL
);

CREATE TABLE public.membre (
    id_membre integer NOT NULL,
    nom_membre character varying(50) NOT NULL,
    prenom_membre character varying(50) NOT NULL,
    mail_membre text NOT NULL,
    password_membre character varying(50) NOT NULL,
    date_naissance date NOT NULL,
    age integer NOT NULL
);

CREATE TABLE public.equipe (
    id_equipe integer NOT NULL,
    nom_equipe character varying(50) NOT NULL,
    description_equipe text NOT NULL,
    categorie character varying(50) NOT NULL
);

CREATE TABLE public.evenement (
    id_evenement integer NOT NULL,
    titre_evenement character varying(50) NOT NULL,
    description_evenement text NOT NULL,
    type_evenement character varying(255) NOT NULL,
    date_debut_event date NOT NULL,
    date_fin_event date NOT NULL,
    lieu_event text NOT NULL,
    id_association integer
);

CREATE TABLE public.actualite (
    id_actualite integer NOT NULL,
    id_association integer,
    id_auteur integer NOT NULL,
    type_actualite public.type_actualite_enum NOT NULL,
    titre character varying(25) NOT NULL,
    contenu text NOT NULL,
    image_principale character varying(255),
    date_creation timestamp without time zone NOT NULL,
    date_publication timestamp without time zone NOT NULL,
    statut public.statut_enum NOT NULL,
    id_evenement integer,
    event_date timestamp without time zone NOT NULL
);

CREATE TABLE public.actualite_image (
    id_image integer NOT NULL,
    id_actualite integer,
    url_image character varying(255) NOT NULL,
    ordre integer DEFAULT 1
);

CREATE TABLE public.membre_asso (
    id_membre_asso integer NOT NULL,
    role character varying(50) NOT NULL,
    date_adhesion date NOT NULL,
    id_association integer,
    id_membre integer,
    conseil_asso character varying(50) NOT NULL
);

CREATE TABLE public.membre_activite (
    id_membre_activite integer NOT NULL,
    id_equipe integer,
    id_membre_asso integer,
    role_activite character varying(50) NOT NULL
);

CREATE TABLE public.participation (
    id_participation integer NOT NULL,
    id_evenement integer,
    id_membre integer,
    presence public.presence_enum NOT NULL
);

CREATE SEQUENCE public.association_id_association_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE public.membre_id_membre_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE public.equipe_id_equipe_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE public.evenement_id_evenement_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE public.actualite_id_actualite_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE public.actualite_image_id_image_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE public.membre_asso_id_membre_asso_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE public.membre_activite_id_membre_activite_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
CREATE SEQUENCE public.participation_id_participation_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER SEQUENCE public.association_id_association_seq OWNED BY public.association.id_association;
ALTER SEQUENCE public.membre_id_membre_seq OWNED BY public.membre.id_membre;
ALTER SEQUENCE public.equipe_id_equipe_seq OWNED BY public.equipe.id_equipe;
ALTER SEQUENCE public.evenement_id_evenement_seq OWNED BY public.evenement.id_evenement;
ALTER SEQUENCE public.actualite_id_actualite_seq OWNED BY public.actualite.id_actualite;
ALTER SEQUENCE public.actualite_image_id_image_seq OWNED BY public.actualite_image.id_image;
ALTER SEQUENCE public.membre_asso_id_membre_asso_seq OWNED BY public.membre_asso.id_membre_asso;
ALTER SEQUENCE public.membre_activite_id_membre_activite_seq OWNED BY public.membre_activite.id_membre_activite;
ALTER SEQUENCE public.participation_id_participation_seq OWNED BY public.participation.id_participation;


ALTER TABLE ONLY public.association ALTER COLUMN id_association SET DEFAULT nextval('public.association_id_association_seq'::regclass);
ALTER TABLE ONLY public.membre ALTER COLUMN id_membre SET DEFAULT nextval('public.membre_id_membre_seq'::regclass);
ALTER TABLE ONLY public.equipe ALTER COLUMN id_equipe SET DEFAULT nextval('public.equipe_id_equipe_seq'::regclass);
ALTER TABLE ONLY public.evenement ALTER COLUMN id_evenement SET DEFAULT nextval('public.evenement_id_evenement_seq'::regclass);
ALTER TABLE ONLY public.actualite ALTER COLUMN id_actualite SET DEFAULT nextval('public.actualite_id_actualite_seq'::regclass);
ALTER TABLE ONLY public.actualite_image ALTER COLUMN id_image SET DEFAULT nextval('public.actualite_image_id_image_seq'::regclass);
ALTER TABLE ONLY public.membre_asso ALTER COLUMN id_membre_asso SET DEFAULT nextval('public.membre_asso_id_membre_asso_seq'::regclass);
ALTER TABLE ONLY public.membre_activite ALTER COLUMN id_membre_activite SET DEFAULT nextval('public.membre_activite_id_membre_activite_seq'::regclass);
ALTER TABLE ONLY public.participation ALTER COLUMN id_participation SET DEFAULT nextval('public.participation_id_participation_seq'::regclass);


ALTER TABLE ONLY public.association ADD CONSTRAINT association_pkey PRIMARY KEY (id_association);
ALTER TABLE ONLY public.membre ADD CONSTRAINT membre_pkey PRIMARY KEY (id_membre);
ALTER TABLE ONLY public.equipe ADD CONSTRAINT equipe_pkey PRIMARY KEY (id_equipe);
ALTER TABLE ONLY public.evenement ADD CONSTRAINT evenement_pkey PRIMARY KEY (id_evenement);
ALTER TABLE ONLY public.actualite ADD CONSTRAINT actualite_pkey PRIMARY KEY (id_actualite);
ALTER TABLE ONLY public.actualite_image ADD CONSTRAINT actualite_image_pkey PRIMARY KEY (id_image);
ALTER TABLE ONLY public.membre_asso ADD CONSTRAINT membre_asso_pkey PRIMARY KEY (id_membre_asso);
ALTER TABLE ONLY public.membre_activite ADD CONSTRAINT membre_activite_pkey PRIMARY KEY (id_membre_activite);
ALTER TABLE ONLY public.participation ADD CONSTRAINT participation_pkey PRIMARY KEY (id_participation);

ALTER TABLE ONLY public.evenement
    ADD CONSTRAINT evenement_id_association_fkey
    FOREIGN KEY (id_association) REFERENCES public.association(id_association) ON DELETE CASCADE;

ALTER TABLE ONLY public.actualite
    ADD CONSTRAINT actualite_id_association_fkey
    FOREIGN KEY (id_association) REFERENCES public.association(id_association) ON DELETE CASCADE;

ALTER TABLE ONLY public.actualite
    ADD CONSTRAINT actualite_id_evenement_fkey
    FOREIGN KEY (id_evenement) REFERENCES public.evenement(id_evenement) ON DELETE CASCADE;

ALTER TABLE ONLY public.actualite_image
    ADD CONSTRAINT actualite_image_id_actualite_fkey
    FOREIGN KEY (id_actualite) REFERENCES public.actualite(id_actualite) ON DELETE CASCADE;

ALTER TABLE ONLY public.membre_asso
    ADD CONSTRAINT membre_asso_id_association_fkey
    FOREIGN KEY (id_association) REFERENCES public.association(id_association) ON DELETE CASCADE;

ALTER TABLE ONLY public.membre_asso
    ADD CONSTRAINT membre_asso_id_membre_fkey
    FOREIGN KEY (id_membre) REFERENCES public.membre(id_membre) ON DELETE CASCADE;

ALTER TABLE ONLY public.membre_activite
    ADD CONSTRAINT membre_activite_id_equipe_fkey
    FOREIGN KEY (id_equipe) REFERENCES public.equipe(id_equipe) ON DELETE CASCADE;

ALTER TABLE ONLY public.membre_activite
    ADD CONSTRAINT membre_activite_id_membre_asso_fkey
    FOREIGN KEY (id_membre_asso) REFERENCES public.membre_asso(id_membre_asso) ON DELETE CASCADE;

ALTER TABLE ONLY public.participation
    ADD CONSTRAINT participation_id_evenement_fkey
    FOREIGN KEY (id_evenement) REFERENCES public.evenement(id_evenement);

ALTER TABLE ONLY public.participation
    ADD CONSTRAINT participation_id_membre_fkey
    FOREIGN KEY (id_membre) REFERENCES public.membre(id_membre);

ALTER TABLE ONLY public.participation
ADD CONSTRAINT participation_evenement_membre_unique UNIQUE (id_evenement, id_membre);