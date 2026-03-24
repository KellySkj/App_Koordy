--
-- PostgreSQL database dump
--


-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-03-19 11:27:21

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

--
-- TOC entry 875 (class 1247 OID 41392)
-- Name: presence_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.presence_enum AS ENUM (
    'absent',
    'present',
    'peut etre',
    'en attente'
);


ALTER TYPE public.presence_enum OWNER TO postgres;

--
-- TOC entry 872 (class 1247 OID 41384)
-- Name: statut_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.statut_enum AS ENUM (
    'Pending',
    'Approuve',
    'Refuse'
);


ALTER TYPE public.statut_enum OWNER TO postgres;

--
-- TOC entry 869 (class 1247 OID 41379)
-- Name: type_actualite_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.type_actualite_enum AS ENUM (
    'Article',
    'Evenement'
);


ALTER TYPE public.type_actualite_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 228 (class 1259 OID 41475)
-- Name: actualite; Type: TABLE; Schema: public; Owner: postgres
--

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


ALTER TABLE public.actualite OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 41474)
-- Name: actualite_id_actualite_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actualite_id_actualite_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.actualite_id_actualite_seq OWNER TO postgres;

--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 227
-- Name: actualite_id_actualite_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actualite_id_actualite_seq OWNED BY public.actualite.id_actualite;


--
-- TOC entry 230 (class 1259 OID 41503)
-- Name: actualite_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actualite_image (
    id_image integer NOT NULL,
    id_actualite integer,
    url_image character varying(255) NOT NULL,
    ordre integer DEFAULT 1
);


ALTER TABLE public.actualite_image OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 41502)
-- Name: actualite_image_id_image_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actualite_image_id_image_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.actualite_image_id_image_seq OWNER TO postgres;

--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 229
-- Name: actualite_image_id_image_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actualite_image_id_image_seq OWNED BY public.actualite_image.id_image;


--
-- TOC entry 220 (class 1259 OID 41402)
-- Name: association; Type: TABLE; Schema: public; Owner: postgres
--

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


ALTER TABLE public.association OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 41401)
-- Name: association_id_association_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.association_id_association_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.association_id_association_seq OWNER TO postgres;

--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 219
-- Name: association_id_association_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.association_id_association_seq OWNED BY public.association.id_association;


--
-- TOC entry 224 (class 1259 OID 41441)
-- Name: equipe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipe (
    id_equipe integer NOT NULL,
    nom_equipe character varying(50) NOT NULL,
    description_equipe text NOT NULL,
    categorie character varying(50) NOT NULL
);


ALTER TABLE public.equipe OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 41440)
-- Name: equipe_id_equipe_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipe_id_equipe_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipe_id_equipe_seq OWNER TO postgres;

--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 223
-- Name: equipe_id_equipe_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipe_id_equipe_seq OWNED BY public.equipe.id_equipe;


--
-- TOC entry 226 (class 1259 OID 41454)
-- Name: evenement; Type: TABLE; Schema: public; Owner: postgres
--

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


ALTER TABLE public.evenement OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 41453)
-- Name: evenement_id_evenement_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.evenement_id_evenement_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.evenement_id_evenement_seq OWNER TO postgres;

--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 225
-- Name: evenement_id_evenement_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.evenement_id_evenement_seq OWNED BY public.evenement.id_evenement;


--
-- TOC entry 222 (class 1259 OID 41425)
-- Name: membre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membre (
    id_membre integer NOT NULL,
    nom_membre character varying(50) NOT NULL,
    prenom_membre character varying(50) NOT NULL,
    mail_membre text NOT NULL,
    password_membre character varying(50) NOT NULL,
    date_naissance date NOT NULL,
    age integer NOT NULL
);


ALTER TABLE public.membre OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 41539)
-- Name: membre_activite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membre_activite (
    id_membre_activite integer NOT NULL,
    id_equipe integer,
    id_membre_asso integer,
    role_activite character varying(50) NOT NULL
);


ALTER TABLE public.membre_activite OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 41538)
-- Name: membre_activite_id_membre_activite_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.membre_activite_id_membre_activite_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.membre_activite_id_membre_activite_seq OWNER TO postgres;

--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 233
-- Name: membre_activite_id_membre_activite_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.membre_activite_id_membre_activite_seq OWNED BY public.membre_activite.id_membre_activite;


--
-- TOC entry 232 (class 1259 OID 41518)
-- Name: membre_asso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membre_asso (
    id_membre_asso integer NOT NULL,
    role character varying(50) NOT NULL,
    date_adhesion date NOT NULL,
    id_association integer,
    id_membre integer,
    conseil_asso character varying(50) NOT NULL
);


ALTER TABLE public.membre_asso OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 41517)
-- Name: membre_asso_id_membre_asso_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.membre_asso_id_membre_asso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.membre_asso_id_membre_asso_seq OWNER TO postgres;

--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 231
-- Name: membre_asso_id_membre_asso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.membre_asso_id_membre_asso_seq OWNED BY public.membre_asso.id_membre_asso;


--
-- TOC entry 221 (class 1259 OID 41424)
-- Name: membre_id_membre_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.membre_id_membre_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.membre_id_membre_seq OWNER TO postgres;

--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 221
-- Name: membre_id_membre_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.membre_id_membre_seq OWNED BY public.membre.id_membre;


--
-- TOC entry 236 (class 1259 OID 41558)
-- Name: participation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.participation (
    id_participation integer NOT NULL,
    id_evenement integer,
    id_membre integer,
    presence public.presence_enum NOT NULL
);


ALTER TABLE public.participation OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 41557)
-- Name: participation_id_participation_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.participation_id_participation_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.participation_id_participation_seq OWNER TO postgres;

--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 235
-- Name: participation_id_participation_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.participation_id_participation_seq OWNED BY public.participation.id_participation;


--
-- TOC entry 4909 (class 2604 OID 41478)
-- Name: actualite id_actualite; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actualite ALTER COLUMN id_actualite SET DEFAULT nextval('public.actualite_id_actualite_seq'::regclass);


--
-- TOC entry 4910 (class 2604 OID 41506)
-- Name: actualite_image id_image; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actualite_image ALTER COLUMN id_image SET DEFAULT nextval('public.actualite_image_id_image_seq'::regclass);


--
-- TOC entry 4905 (class 2604 OID 41405)
-- Name: association id_association; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.association ALTER COLUMN id_association SET DEFAULT nextval('public.association_id_association_seq'::regclass);


--
-- TOC entry 4907 (class 2604 OID 41444)
-- Name: equipe id_equipe; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipe ALTER COLUMN id_equipe SET DEFAULT nextval('public.equipe_id_equipe_seq'::regclass);


--
-- TOC entry 4908 (class 2604 OID 41457)
-- Name: evenement id_evenement; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evenement ALTER COLUMN id_evenement SET DEFAULT nextval('public.evenement_id_evenement_seq'::regclass);


--
-- TOC entry 4906 (class 2604 OID 41428)
-- Name: membre id_membre; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membre ALTER COLUMN id_membre SET DEFAULT nextval('public.membre_id_membre_seq'::regclass);


--
-- TOC entry 4913 (class 2604 OID 41542)
-- Name: membre_activite id_membre_activite; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membre_activite ALTER COLUMN id_membre_activite SET DEFAULT nextval('public.membre_activite_id_membre_activite_seq'::regclass);


--
-- TOC entry 4912 (class 2604 OID 41521)
-- Name: membre_asso id_membre_asso; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membre_asso ALTER COLUMN id_membre_asso SET DEFAULT nextval('public.membre_asso_id_membre_asso_seq'::regclass);


--
-- TOC entry 4914 (class 2604 OID 41561)
-- Name: participation id_participation; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participation ALTER COLUMN id_participation SET DEFAULT nextval('public.participation_id_participation_seq'::regclass);


--
-- TOC entry 5099 (class 0 OID 41475)
-- Dependencies: 228
-- Data for Name: actualite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actualite (id_actualite, id_association, id_auteur, type_actualite, titre, contenu, image_principale, date_creation, date_publication, statut, id_evenement, event_date) FROM stdin;



--
-- TOC entry 5101 (class 0 OID 41503)
-- Dependencies: 230
-- Data for Name: actualite_image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actualite_image (id_image, id_actualite, url_image, ordre) FROM stdin;



--
-- TOC entry 5091 (class 0 OID 41402)
-- Dependencies: 220
-- Data for Name: association; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.association (id_association, nom, type_structure, sport, adresse, adresse_2, description, date_creation, image, code_postal, ville, pays, couleur_1, couleur_2) FROM stdin;



--
-- TOC entry 5095 (class 0 OID 41441)
-- Dependencies: 224
-- Data for Name: equipe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipe (id_equipe, nom_equipe, description_equipe, categorie) FROM stdin;



--
-- TOC entry 5097 (class 0 OID 41454)
-- Dependencies: 226
-- Data for Name: evenement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evenement (id_evenement, titre_evenement, description_evenement, type_evenement, date_debut_event, date_fin_event, lieu_event, id_association) FROM stdin;



--
-- TOC entry 5093 (class 0 OID 41425)
-- Dependencies: 222
-- Data for Name: membre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membre (id_membre, nom_membre, prenom_membre, mail_membre, password_membre, date_naissance, age) FROM stdin;



--
-- TOC entry 5105 (class 0 OID 41539)
-- Dependencies: 234
-- Data for Name: membre_activite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membre_activite (id_membre_activite, id_equipe, id_membre_asso, role_activite) FROM stdin;



--
-- TOC entry 5103 (class 0 OID 41518)
-- Dependencies: 232
-- Data for Name: membre_asso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membre_asso (id_membre_asso, role, date_adhesion, id_association, id_membre, conseil_asso) FROM stdin;



--
-- TOC entry 5107 (class 0 OID 41558)
-- Dependencies: 236
-- Data for Name: participation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.participation (id_participation, id_evenement, id_membre, presence) FROM stdin;



--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 227
-- Name: actualite_id_actualite_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actualite_id_actualite_seq', 1, false);


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 229
-- Name: actualite_image_id_image_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actualite_image_id_image_seq', 1, false);


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 219
-- Name: association_id_association_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.association_id_association_seq', 1, false);


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 223
-- Name: equipe_id_equipe_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipe_id_equipe_seq', 1, false);


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 225
-- Name: evenement_id_evenement_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.evenement_id_evenement_seq', 1, false);


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 233
-- Name: membre_activite_id_membre_activite_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.membre_activite_id_membre_activite_seq', 1, false);


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 231
-- Name: membre_asso_id_membre_asso_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.membre_asso_id_membre_asso_seq', 1, false);


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 221
-- Name: membre_id_membre_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.membre_id_membre_seq', 1, false);


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 235
-- Name: participation_id_participation_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.participation_id_participation_seq', 1, false);


--
-- TOC entry 4926 (class 2606 OID 41511)
-- Name: actualite_image actualite_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actualite_image
    ADD CONSTRAINT actualite_image_pkey PRIMARY KEY (id_image);


--
-- TOC entry 4924 (class 2606 OID 41491)
-- Name: actualite actualite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actualite
    ADD CONSTRAINT actualite_pkey PRIMARY KEY (id_actualite);


--
-- TOC entry 4916 (class 2606 OID 41423)
-- Name: association association_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.association
    ADD CONSTRAINT association_pkey PRIMARY KEY (id_association);


--
-- TOC entry 4920 (class 2606 OID 41452)
-- Name: equipe equipe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipe
    ADD CONSTRAINT equipe_pkey PRIMARY KEY (id_equipe);


--
-- TOC entry 4922 (class 2606 OID 41468)
-- Name: evenement evenement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evenement
    ADD CONSTRAINT evenement_pkey PRIMARY KEY (id_evenement);


--
-- TOC entry 4930 (class 2606 OID 41546)
-- Name: membre_activite membre_activite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membre_activite
    ADD CONSTRAINT membre_activite_pkey PRIMARY KEY (id_membre_activite);


--
-- TOC entry 4928 (class 2606 OID 41527)
-- Name: membre_asso membre_asso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membre_asso
    ADD CONSTRAINT membre_asso_pkey PRIMARY KEY (id_membre_asso);


--
-- TOC entry 4918 (class 2606 OID 41439)
-- Name: membre membre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membre
    ADD CONSTRAINT membre_pkey PRIMARY KEY (id_membre);


--
-- TOC entry 4932 (class 2606 OID 41565)
-- Name: participation participation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participation
    ADD CONSTRAINT participation_pkey PRIMARY KEY (id_participation);


--
-- TOC entry 4934 (class 2606 OID 41492)
-- Name: actualite actualite_id_association_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actualite
    ADD CONSTRAINT actualite_id_association_fkey FOREIGN KEY (id_association) REFERENCES public.association(id_association) ON DELETE CASCADE;


--
-- TOC entry 4935 (class 2606 OID 41497)
-- Name: actualite actualite_id_evenement_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actualite
    ADD CONSTRAINT actualite_id_evenement_fkey FOREIGN KEY (id_evenement) REFERENCES public.evenement(id_evenement) ON DELETE CASCADE;


--
-- TOC entry 4936 (class 2606 OID 41512)
-- Name: actualite_image actualite_image_id_actualite_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actualite_image
    ADD CONSTRAINT actualite_image_id_actualite_fkey FOREIGN KEY (id_actualite) REFERENCES public.actualite(id_actualite) ON DELETE CASCADE;


--
-- TOC entry 4933 (class 2606 OID 41469)
-- Name: evenement evenement_id_association_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evenement
    ADD CONSTRAINT evenement_id_association_fkey FOREIGN KEY (id_association) REFERENCES public.association(id_association) ON DELETE CASCADE;


--
-- TOC entry 4939 (class 2606 OID 41547)
-- Name: membre_activite membre_activite_id_equipe_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membre_activite
    ADD CONSTRAINT membre_activite_id_equipe_fkey FOREIGN KEY (id_equipe) REFERENCES public.equipe(id_equipe) ON DELETE CASCADE;


--
-- TOC entry 4940 (class 2606 OID 41552)
-- Name: membre_activite membre_activite_id_membre_asso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membre_activite
    ADD CONSTRAINT membre_activite_id_membre_asso_fkey FOREIGN KEY (id_membre_asso) REFERENCES public.membre_asso(id_membre_asso) ON DELETE CASCADE;


--
-- TOC entry 4937 (class 2606 OID 41528)
-- Name: membre_asso membre_asso_id_association_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membre_asso
    ADD CONSTRAINT membre_asso_id_association_fkey FOREIGN KEY (id_association) REFERENCES public.association(id_association) ON DELETE CASCADE;


--
-- TOC entry 4938 (class 2606 OID 41533)
-- Name: membre_asso membre_asso_id_membre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membre_asso
    ADD CONSTRAINT membre_asso_id_membre_fkey FOREIGN KEY (id_membre) REFERENCES public.membre(id_membre) ON DELETE CASCADE;


--
-- TOC entry 4941 (class 2606 OID 41566)
-- Name: participation participation_id_evenement_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participation
    ADD CONSTRAINT participation_id_evenement_fkey FOREIGN KEY (id_evenement) REFERENCES public.evenement(id_evenement);


--
-- TOC entry 4942 (class 2606 OID 41571)
-- Name: participation participation_id_membre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participation
    ADD CONSTRAINT participation_id_membre_fkey FOREIGN KEY (id_membre) REFERENCES public.membre(id_membre);


-- Completed on 2026-03-19 11:27:22

--
-- PostgreSQL database dump complete
--


