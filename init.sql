grant all privileges on database postgres to postgres;

--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: add_n(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_n(integer) RETURNS character
    LANGUAGE plpgsql
AS $_$declare t int; begin
    select max(id_igrok) into t from info_igrok;
    for k in (t+1)..($1+t+1) loop
        insert into info_igrok(id_igrok,name_igrok,surename_igrok,date_igrok,height_igrok,weight_igrok) values(k, chr(cast(round(random()*25+65)as integer))||chr(cast(round(random()*25+97)as integer))||chr(cast(round(random()*25+97)as integer))||chr(cast(round(random()*25+97)as integer))||chr(cast(round(random()*25+97)as integer)), chr(cast(round(random()*25+65)as integer))||chr(cast(round(random()*25+97)as integer))||chr(cast(round(random()*25+97)as integer))||chr(cast(round(random()*25+97)as integer))||chr(cast(round(random()*25+97)as integer))||chr(cast(round(random()*25+97)as integer))||chr(cast(round(random()*25+97)as integer))||chr(cast(round(random()*25+97)as integer))||chr(cast(round(random()*25+97)as integer))||chr(cast(round(random()*25+97)as integer))||chr(cast(round(random()*25+97)as integer)), cast(cast(round(19)as char(2))||cast(round(random()*1+8)as char(2))||cast(round(random()*9+0)as char(2))|| chr(cast(round(45)as integer))||cast(round(random()*11+1)as char(2))|| chr(cast(round(45)as integer))||cast(round(random()*27+1)as char(2)) as date), cast(round(random()*68+151)as integer), cast(round(random()*40+60)as integer));
    end loop; return 'Done!';
end;$_$;


ALTER FUNCTION public.add_n(integer) OWNER TO postgres;

--
-- Name: add_n_play(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_n_play(integer) RETURNS character
    LANGUAGE plpgsql
AS $_$declare t int; begin
    select max(id_igrok) into t from play_igrok;
    for k in (t+1)..($1+t+1) loop
        insert into play_igrok(id_igrok,goal,goal_peredach,shtraf_time,play_time) values(k, cast(round(random()*15)as integer), cast(round(random()*25)as integer), cast(cast(round(0)as char(2))||chr(cast(round(58)as integer))|| cast(round(random()*45)as char(2)) || chr(cast(round(58)as integer)) || cast(round(random()*59)as char(2)) as time), cast(cast(round(random()*3)as char(2))||chr(cast(round(58)as integer))|| cast(round(random()*59)as char(2)) || chr(cast(round(58)as integer)) || cast(round(random()*59)as char(2)) as time));
    end loop; return 'Done!';
end;$_$;


ALTER FUNCTION public.add_n_play(integer) OWNER TO postgres;

--
-- Name: effective(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.effective() RETURNS character
    LANGUAGE plpgsql
AS $$declare l int;
    declare p varchar(20);
    declare p2 time;
    declare p3 time;
    declare d int;
    declare t1 int;
    declare t2 int;
    declare h int;
    declare m int;
    declare s int;

begin
    TRUNCATE effective;
    select max(id_igrok) from play_igrok into l;
    for k in (1)..(l) loop
        select name_igrok from info_igrok,play_igrok where( info_igrok.id_igrok=k and info_igrok.id_igrok= play_igrok.id_igrok) into p;
        select shtraf_time from play_igrok where play_igrok.id_igrok=k into p2;
        select play_time from play_igrok where play_igrok.id_igrok=k into p3;

        SELECT EXTRACT(MINUTE FROM p3 ) into m;
        SELECT EXTRACT(SECOND FROM p3 ) into s;
        SELECT EXTRACT(HOUR FROM p3 ) into h;
        Select (s+60*m+60*60*h) into t1;

        SELECT EXTRACT(MINUTE FROM p2 ) into m;
        SELECT EXTRACT(SECOND FROM p2 ) into s;
        SELECT EXTRACT(HOUR FROM p2) into h;
        Select (s+60*m+60*60*h) into t2;

        select ((t1*100)/(t1+t2)) into d;
        insert into effective(id, name,shtraf,play,effect_percent) values(k,p, p2,p3,d);

    end loop;
    perform * from effective order by effect_percent desc;
    return 'Done!';
end;$$;


ALTER FUNCTION public.effective() OWNER TO postgres;

--
-- Name: population(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.population() RETURNS character
    LANGUAGE plpgsql
AS $$declare t int;
    declare l int;
    declare p varchar(20);
    declare p2 int;
begin
    TRUNCATE population_club;
    select max(id_pop) into t from population_club;
    select max(id_club) into l from club;
    for k in (1)..(l) loop
        select name_club from club where id_club=k into p;
        select sum(kolvo) from bilet, club,play where ((club.id_club=play.id_k1 or club.id_club=play.id_k2) and club.id_club=k and bilet.id_club=play.id_bilet) into p2;
        insert into population_club(id_pop, name_club,count) values(k,p, p2);
        perform *from population_club order by count desc;

    end loop; return 'Done!';
end;$$;


ALTER FUNCTION public.population() OWNER TO postgres;

--
-- Name: reiting(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.reiting(date, date) RETURNS character
    LANGUAGE plpgsql
AS $_$declare t int;
    declare l int;
    declare p varchar(20);
    declare p2 int;
    declare p3 int;
    declare d date;
    declare d1 date;

begin
    TRUNCATE reiting;
    select  date_play from play into d1;
    select max(id) into t from reiting;
    select max(id_igrok) from play_igrok into l;
    for k in (1)..(l) loop
        if ((d1>=$1 and d1<=$2) and (d1 is NOT NULL)) then
            select name_igrok from info_igrok where id_igrok=k into p;
            select goal from play_igrok where id_igrok=k into p2;
            select goal_peredach from play_igrok where id_igrok=k  into p3;
            select date_play from play, club, info_igrok, play_igrok where ((play.id_k1=club.id_club or play.id_k2=club.id_club) and club.id_club=info_igrok.id_igrok and info_igrok.id_igrok=play_igrok.id_igrok and info_igrok.id_igrok=k and play.date_play>=$1 and play.date_play<=$2) into d;
            select date_play from play,info_igrok where (info_igrok.id_igrok=k+1) into d1;
            if (d is NOT NULL) then
                insert into reiting(id, name,goal,goal_p,date_play) values(k,p, p2,p3,d);
            end if;
        end if;
        perform * from reiting order by goal desc;
    end loop; return 'Done!';
end;$_$;


ALTER FUNCTION public.reiting(date, date) OWNER TO postgres;

--
-- Name: zpstadion_avg(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.zpstadion_avg() RETURNS character
    LANGUAGE plpgsql
AS $$declare l int;
    declare p2 int;
    declare p3 int;
    declare d date;
    declare p character(1);
begin
    TRUNCATE stadion;
    select max(id_club) from bilet into l;
    for k in (1)..(l) loop
        select kolvo from bilet, play where( bilet.id_club=k and bilet.id_club= play.id_bilet and bilet.kolvo<=600 and bilet.kolvo>400) into p2;
        select cost from bilet where (bilet.id_club=k and bilet.kolvo<=600 and bilet.kolvo>400) into p3;
        select date_play from play,bilet where (play.id_bilet=k and bilet.kolvo<=600 and bilet.kolvo>400) into d;
        select match_h from match,play,bilet where (play.id_match=match.id_match and play.id_bilet=k and bilet.kolvo<=600 and bilet.kolvo>400) into p;
        if ((p2 is not null) and (p3 is not null)) then
            insert into stadion(id, kolvo,cost ,date_play,match) values(k,p2, p3,d,p);
        end if;
    end loop;
    perform * from stadion order by kolvo desc;
    return 'Done!';
end;$$;


ALTER FUNCTION public.zpstadion_avg() OWNER TO postgres;

--
-- Name: zpstadion_max(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.zpstadion_max() RETURNS character
    LANGUAGE plpgsql
AS $$declare l int;
    declare p2 int;
    declare p3 int;
    declare d date;
    declare p character(1);
begin
    TRUNCATE stadion;
    select max(id_club) from bilet into l;
    for k in (1)..(l) loop
        select kolvo from bilet, play where( bilet.id_club=k and bilet.id_club= play.id_bilet and bilet.kolvo>600) into p2;
        select cost from bilet where (bilet.id_club=k and bilet.kolvo>600) into p3;
        select date_play from play,bilet where (play.id_bilet=k and bilet.kolvo>600) into d;
        select match_h from match,play,bilet where (play.id_match=match.id_match and play.id_bilet=k and bilet.kolvo>600) into p;
        if ((p2 is not null) and (p3 is not null)) then
            insert into stadion(id, kolvo,cost ,date_play,match) values(k,p2, p3,d,p);
        end if;
    end loop;
    perform * from stadion order by kolvo desc;
    return 'Done!';
end;$$;


ALTER FUNCTION public.zpstadion_max() OWNER TO postgres;

--
-- Name: zpstadion_min(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.zpstadion_min() RETURNS character
    LANGUAGE plpgsql
AS $$declare l int;
    declare p2 int;
    declare p3 int;
    declare d date;
    declare p character(1);
begin
    TRUNCATE stadion;
    select max(id_club) from bilet into l;
    for k in (1)..(l) loop
        select kolvo from bilet, play where( bilet.id_club=k and bilet.id_club= play.id_bilet and bilet.kolvo<=400) into p2;
        select cost from bilet where (bilet.id_club=k and bilet.kolvo <=400) into p3;
        select date_play from play,bilet where (play.id_bilet=k and bilet.kolvo<=400) into d;
        select match_h from match,play,bilet where (play.id_match=match.id_match and play.id_bilet=k and bilet.kolvo<=400) into p;
        if ((p2 is not null) and (p3 is not null)) then
            insert into stadion(id, kolvo,cost ,date_play,match) values(k,p2, p3,d,p);
        end if;
    end loop;
    perform * from stadion order by kolvo desc;
    return 'Done!';
end;$$;


ALTER FUNCTION public.zpstadion_min() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bilet; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.bilet (
                              id_club integer NOT NULL,
                              kolvo integer,
                              cost integer
);


ALTER TABLE public.bilet OWNER TO postgres;

--
-- Name: characteristion; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.characteristion (
                                        id_igrok integer,
                                        number_igrok integer,
                                        position_igrok character varying(20),
                                        size_igrok integer,
                                        xvat character varying(20),
                                        CONSTRAINT characteristion_position_igrok_check CHECK (((((position_igrok)::bpchar = 'vratar'::bpchar) OR ((position_igrok)::bpchar = 'zashitnik'::bpchar)) OR ((position_igrok)::bpchar = 'napadaushy'::bpchar))),
                                        CONSTRAINT characteristion_xvat_check CHECK ((((xvat)::bpchar = 'left'::bpchar) OR ((xvat)::bpchar = 'rigth'::bpchar)))
);


ALTER TABLE public.characteristion OWNER TO postgres;

--
-- Name: club; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.club (
                             id_club integer NOT NULL,
                             name_club character varying(20) NOT NULL
);


ALTER TABLE public.club OWNER TO postgres;

--
-- Name: effective; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.effective (
                                  id integer NOT NULL,
                                  name character varying(20),
                                  shtraf time without time zone,
                                  play time without time zone,
                                  effect_percent integer
);


ALTER TABLE public.effective OWNER TO postgres;

--
-- Name: info_igrok; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.info_igrok (
                                   id_igrok integer NOT NULL,
                                   name_igrok character varying(20),
                                   surename_igrok character varying(25),
                                   date_igrok date,
                                   height_igrok integer,
                                   weight_igrok integer,
                                   id_club integer,
                                   CONSTRAINT info_igrok_height_igrok_check CHECK (((height_igrok < 220) AND (height_igrok > 150)))
);


ALTER TABLE public.info_igrok OWNER TO postgres;

--
-- Name: match; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.match (
                              id_match integer NOT NULL,
                              match_h character(1),
                              CONSTRAINT match_match_h_check CHECK (((match_h = 'h'::bpchar) OR (match_h = 'v'::bpchar)))
);


ALTER TABLE public.match OWNER TO postgres;

--
-- Name: nagrada_igrok; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.nagrada_igrok (
                                      id integer NOT NULL,
                                      nagrada text[]
);


ALTER TABLE public.nagrada_igrok OWNER TO postgres;

--
-- Name: play; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.play (
                             id_play integer NOT NULL,
                             res_k1 integer,
                             res_k2 integer,
                             id_k1 integer,
                             id_k2 integer,
                             id_bilet integer,
                             id_match integer,
                             date_play date
);


ALTER TABLE public.play OWNER TO postgres;

--
-- Name: play_igrok; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.play_igrok (
                                   id_igrok integer,
                                   goal integer,
                                   goal_peredach integer,
                                   shtraf_time time without time zone,
                                   play_time time without time zone
);


ALTER TABLE public.play_igrok OWNER TO postgres;

--
-- Name: population_club; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.population_club (
                                        id_pop integer NOT NULL,
                                        name_club character varying(20),
                                        count integer
);


ALTER TABLE public.population_club OWNER TO postgres;

--
-- Name: price_igrok; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.price_igrok (
                                    id_igrok integer,
                                    oklad double precision,
                                    premia double precision,
                                    shtraf double precision
);


ALTER TABLE public.price_igrok OWNER TO postgres;

--
-- Name: raspisanie_igrok; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.raspisanie_igrok (
                                         id integer NOT NULL,
                                         raspisanie integer[]
);


ALTER TABLE public.raspisanie_igrok OWNER TO postgres;

--
-- Name: reiting; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.reiting (
                                id integer NOT NULL,
                                name character varying(20),
                                goal integer,
                                goal_p integer,
                                date_play date
);


ALTER TABLE public.reiting OWNER TO postgres;

--
-- Name: stadion; Type: TABLE; Schema: public; Owner: postgres; Tablespace:
--

CREATE TABLE public.stadion (
                                id integer NOT NULL,
                                kolvo integer,
                                cost integer,
                                date_play date,
                                match character(1)
);


ALTER TABLE public.stadion OWNER TO postgres;

--
-- Name: zadacha1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.zadacha1 AS
SELECT info_igrok.name_igrok,
       info_igrok.surename_igrok,
       characteristion.position_igrok,
       price_igrok.oklad,
       price_igrok.premia,
       (play_igrok.goal + play_igrok.goal_peredach) AS sum_goal
FROM public.info_igrok,
     public.play_igrok,
     public.price_igrok,
     public.characteristion
WHERE (((info_igrok.id_igrok = price_igrok.id_igrok) AND (price_igrok.id_igrok = play_igrok.id_igrok)) AND (play_igrok.id_igrok = characteristion.id_igrok));


ALTER TABLE public.zadacha1 OWNER TO postgres;

--
-- Data for Name: bilet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bilet (id_club, kolvo, cost) FROM stdin;
1	1000	699
2	508	799
3	900	799
4	570	599
5	309	999
6	980	699
7	678	750
8	789	570
9	698	850
10	1000	500
\.


--
-- Data for Name: characteristion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.characteristion (id_igrok, number_igrok, position_igrok, size_igrok, xvat) FROM stdin;
1	10	vratar	45	left
2	13	zashitnik	43	rigth
3	7	zashitnik	44	rigth
4	1	napadaushy	41	left
5	2	zashitnik	45	rigth
6	8	vratar	41	rigth
7	3	napadaushy	42	rigth
8	5	napadaushy	44	rigth
9	11	napadaushy	45	left
10	4	zashitnik	41	left
\.


--
-- Data for Name: club; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.club (id_club, name_club) FROM stdin;
1	Alfa
2	Novosibirsk
3	Kemer
4	MoscowCity
5	Belga
6	Omsk
7	KAZAK
8	Solnechny
9	Kirov
10	Komsol
\.


--
-- Data for Name: effective; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.effective (id, name, shtraf, play, effect_percent) FROM stdin;
1	Ivan	00:30:13	01:35:00	75
2	Oleg	00:15:20	01:50:00	87
3	Petr	00:20:30	00:55:00	72
4	Leopold	00:20:30	03:35:00	91
5	Nikita	00:20:30	00:55:00	72
6	Anton	00:05:00	01:35:00	95
7	Ivan	00:15:20	03:35:00	93
8	Sergey	00:05:00	01:35:00	95
9	Anton	00:30:13	01:35:00	75
10	Semen	00:10:30	01:05:00	86
11	Yjugh	00:25:30	01:05:00	71
12	Ltvyo	00:04:47	02:30:43	96
13	Grvvl	00:28:14	02:05:15	81
14	Ftgcs	00:00:21	03:28:15	99
15	Ywtim	00:12:35	01:02:14	83
16	Pqtqp	00:20:45	01:48:44	83
17	Uwrmc	00:08:15	02:56:56	95
18	Iitrb	00:11:42	03:41:35	94
19	Gumek	00:41:37	00:15:54	27
20	Hbnkc	00:34:31	01:09:26	66
21	Ntqcs	00:01:29	00:27:25	94
22	Gurfh	00:14:05	03:54:40	94
23	Loiek	00:21:42	01:35:58	81
24	Yixnx	00:08:24	01:05:08	88
25	Wkqas	00:22:37	02:48:50	88
26	Fwwbn	00:21:20	02:15:10	86
27	Zqbsy	00:09:40	02:21:05	93
28	Ifcfp	00:34:46	00:59:35	63
29	Szshd	00:14:46	01:03:48	81
30	Rukoo	00:15:39	03:38:03	93
31	Kkobw	00:36:12	02:49:26	82
32	Ychhv	00:15:28	01:01:38	79
33	Wsqph	00:02:57	01:45:05	97
34	Uemof	00:35:10	03:24:30	85
35	Mqkri	00:35:16	02:02:44	77
36	Bvdxg	00:27:57	02:34:40	84
37	Ojsne	00:23:13	01:32:42	79
38	Jujvo	00:32:12	01:52:27	77
39	Mkjpn	00:29:55	00:05:03	14
40	Ycnsy	00:42:17	02:13:23	75
41	Jdoaw	00:24:37	00:02:22	8
42	Vojnb	00:45:44	00:34:02	42
43	Jshka	00:25:33	01:04:46	71
44	Tpaqd	00:17:12	01:31:47	84
45	Nsser	00:29:18	02:35:31	84
46	Lfbdn	00:41:49	03:00:13	81
47	Xaxeo	00:23:35	01:57:42	83
48	Khdqw	00:34:15	03:09:24	84
49	Dgodm	00:15:43	03:57:13	93
50	Kkrdb	00:37:20	01:12:09	65
51	Vewsm	00:35:27	00:58:27	62
52	Izptc	00:33:00	02:35:10	82
53	Wsopo	00:19:57	01:49:56	84
54	Utmjy	00:34:33	00:14:44	29
55	Prdoe	00:38:22	02:42:35	80
56	Stikx	00:17:18	03:18:10	91
57	Sykms	00:01:22	01:13:44	98
58	Yqurp	00:20:11	01:09:38	77
59	Aojsu	00:40:48	00:02:16	5
60	Qqevc	00:03:58	02:53:28	97
61	Utcpl	00:21:46	01:47:07	83
62	Hgess	00:33:08	02:53:33	83
63	Bwtpt	00:13:18	01:02:50	82
64	Byxzi	00:38:08	03:10:58	83
\.


--
-- Data for Name: info_igrok; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.info_igrok (id_igrok, name_igrok, surename_igrok, date_igrok, height_igrok, weight_igrok, id_club) FROM stdin;
101	Puznp	Jomnubdgepr	1980-12-23	164	82	\N
102	Izvws	Wewgkhnwtuu	1991-03-03	161	86	\N
103	Dlhbo	Lfjqwuwncyx	1996-04-10	198	91	\N
104	Pxkst	Buxbuwilpgk	1987-07-02	216	67	\N
105	Fkuhl	Kchvuncaerq	1996-07-20	196	79	\N
106	Yvmmy	Imlsvtrwein	1995-02-09	160	65	\N
107	Qhkhk	Gabyjhguabb	1981-11-02	156	82	\N
108	Cwhtm	Exgjxwkoiph	1983-02-14	197	71	\N
109	Wxbzr	Emkogmxtcxb	1996-12-05	176	81	\N
110	Wtuyp	Lkfntyblqui	1985-11-26	183	81	\N
111	Vuryz	Einxifakvpo	1993-08-23	214	76	\N
112	Dhdid	Cvvkmvrpmih	1986-12-03	187	72	\N
113	Rplet	Snjbkaqgnxp	1990-10-19	159	98	\N
114	Dfymj	Vlzmdrqbyvb	1999-03-07	215	63	\N
115	Kpclf	Tjychlhfhsr	1981-03-18	157	86	\N
116	Dvgvj	Mxepbmrofyr	1994-11-26	152	75	\N
117	Rutcu	Bpshgovecrb	1982-02-21	154	90	\N
118	Pixmu	Jyohoilmjoc	1992-04-07	181	86	\N
119	Clvlr	Hghpqwebnmd	1986-08-25	200	64	\N
120	Ybpaf	Yrcgbbkqllc	1980-12-26	197	92	\N
121	Punik	Trtxjjhpqjl	1982-09-16	219	96	\N
11	Yjugh	Moyfdwqaoud	1997-10-14	187	77	2
12	Ltvyo	Jhjsovjqdkf	1986-03-23	168	97	2
13	Grvvl	Cwhqtgxgjeg	1986-06-04	180	79	2
14	Ftgcs	Cbqemjvadlx	1996-07-24	167	64	2
15	Ywtim	Ltxtpznmyeq	1992-10-09	178	66	2
16	Pqtqp	Aouggmyujup	1980-11-14	213	67	2
17	Uwrmc	Hrnpdghhtux	1993-12-22	213	62	2
18	Iitrb	Jcpqxqrgnrn	1996-05-23	182	94	2
21	Ntqcs	Cmbaxhnlgdl	1991-03-03	166	67	3
22	Gurfh	Ixthevovsun	1991-04-04	156	63	3
23	Loiek	Ijpkrpzzsoh	1988-05-06	167	65	3
24	Yixnx	Wahqqgqfwwo	1994-10-15	178	93	3
25	Wkqas	Vareabbfymb	1997-03-22	197	81	3
26	Fwwbn	Vntumygobrl	1982-05-13	174	83	3
27	Zqbsy	Asdlsghyefy	1981-12-14	217	86	3
28	Ifcfp	Hplgckvevlk	1986-06-25	213	74	3
29	Szshd	Vfyjgbpqfnt	1982-09-07	216	94	3
31	Kkobw	Bpecndtpxxj	1995-07-04	180	66	4
32	Ychhv	Ruoddavsfjz	1996-06-08	213	66	4
33	Wsqph	Dfhihktswgg	1982-11-03	215	88	4
34	Uemof	Pppttapryxv	1994-08-20	200	75	4
35	Mqkri	Yzxjssuthir	1995-05-01	163	79	4
36	Bvdxg	Qdjuoduwqnp	1994-02-05	200	91	4
37	Ojsne	Nkrcxwlnfcb	1988-11-11	205	75	4
38	Jujvo	Vbzsrwjmpso	1982-04-21	189	93	4
39	Mkjpn	Gmxytdnqfnn	1992-03-20	177	73	4
40	Ycnsy	Bintwxytuut	1988-06-09	205	65	4
41	Jdoaw	Uvnpyvjfput	1987-05-25	209	90	5
42	Vojnb	Nljhxcmpsov	1981-10-14	198	91	5
43	Jshka	Ngwirnsephb	1998-09-19	182	66	5
44	Tpaqd	Figjlgmtchg	1996-01-15	201	64	5
45	Nsser	Znbcrraxzsc	1993-01-04	204	86	5
46	Lfbdn	Mnfyckhsefj	1982-06-09	183	100	5
47	Xaxeo	Yndmnuyzfxn	1980-08-21	177	74	5
48	Khdqw	Voxfkdkejre	1994-03-24	185	73	5
49	Dgodm	Prfeuxcjilq	1984-04-27	214	77	5
51	Vewsm	Hcfjysmnrji	1998-05-10	156	88	6
52	Izptc	Wxlhkemexdu	1995-08-16	158	72	6
53	Wsopo	Goglmiihwhg	1982-09-11	165	83	6
54	Utmjy	Crldhxslmxy	1987-08-13	188	82	6
55	Prdoe	Xtmcrqisbbq	1995-04-03	184	85	6
56	Stikx	Duoleibtijq	1993-01-25	203	86	6
57	Sykms	Rhgovgwdwfu	1980-09-11	199	88	6
58	Yqurp	Aqdjvwowhqc	1993-05-26	180	81	6
59	Aojsu	Rjkxninnuru	1986-10-17	209	65	6
60	Qqevc	Ikbbjgggxem	1981-09-08	200	89	6
61	Utcpl	Xsqtiubwqcx	1994-05-23	217	86	7
62	Hgess	Kabjywxbvto	1987-06-09	182	71	7
63	Bwtpt	Dkwmgweakpt	1995-12-19	168	87	7
64	Byxzi	Jiktkpjntri	1992-04-23	216	99	7
65	Tgeve	Hcjpbyetkeq	1997-03-26	195	80	7
66	Vxkuf	Wgscmjarkpz	1983-05-16	160	87	7
67	Bvutt	Iwtaannslku	1993-10-03	169	75	7
68	Xglic	Jepscvynbao	1984-05-03	179	89	7
69	Tpxuh	Vnfnycsqbqc	1986-09-07	184	99	7
71	Nycrb	Pdghxxrefst	1999-04-11	198	83	8
72	Sgsrc	Wvxpienzwta	1991-11-13	162	91	8
73	Ipjxv	Rxhrggpuvov	1986-11-23	166	78	8
74	Abmvf	Jnwkducctsh	1994-05-13	182	93	8
75	Vhapc	Tqtmsxmsljh	1985-07-27	207	64	8
76	Uikpn	Mdhxxctjbgc	1994-01-17	182	84	8
77	Oquix	Uoqwunpfgyr	1980-05-21	192	86	8
78	Yaxsv	Jpejearcwtx	1998-02-16	213	81	8
79	Gwyis	Ywofnsmlest	1988-02-17	182	80	8
80	Dnttw	Mnchfwqtmlx	1982-09-15	183	66	8
81	Dycue	Nzckuphuqxo	1994-06-03	193	77	9
82	Hmrdf	Woddmjsvdmc	1992-01-08	188	81	9
83	Jqnpd	Oexgbnmsftv	1987-07-05	175	78	9
84	Qdtnh	Sgyudjbqfkl	1988-05-20	155	74	9
85	Mkcbt	Wkobuaphxxo	1994-09-20	195	79	9
86	Sfrdn	Obeavurrbwp	1994-11-25	191	74	9
87	Roppk	Ituneksugct	1980-01-28	205	100	9
88	Odhco	Vvofhsyykbq	1984-08-20	191	92	9
89	Khkox	Wlwvixywoew	1981-08-17	179	66	9
91	Lughd	Drfsdxjeoyn	1998-10-21	181	62	10
92	Upofr	Fttgyzgzrjj	1992-10-23	201	98	10
93	Vvcvd	Qabwbwoskws	1993-01-19	181	95	10
94	Cphnx	Wdwtccybkdn	1994-03-21	179	66	10
95	Unlnr	Iqmtreagnxo	1982-06-07	155	72	10
96	Vpdwf	Jtuyoiyuppe	1991-09-12	198	65	10
97	Eldzg	Figdbclpjvf	1983-06-18	158	70	10
98	Gocyt	Guogbustpao	1984-03-10	186	85	10
99	Tyxgq	Hvqdpfswqtn	1992-08-05	176	87	10
122	Rcomf	Jhvakkyqpxk	1981-05-13	210	93	\N
123	Pudvh	Zxrgeczffow	1988-01-06	184	79	\N
124	Enqfu	Fmubpvxaqdh	1997-01-17	212	92	\N
125	Cppru	Jjknfsjnkfo	1998-05-27	172	81	\N
126	Xeleu	Pwewmyfgdvt	1992-05-23	171	98	\N
127	Amrdd	Hgbqxmcdxfs	1997-08-21	188	92	\N
128	Cayem	Iwqjlhhrqbw	1985-05-22	171	92	\N
129	Ihsnk	Fjodbkvxbju	1996-03-24	170	90	\N
130	Mrgxf	Lpgypttnxnu	1984-09-15	192	87	\N
131	Npkci	Kcypcwilqsd	1996-12-01	169	99	\N
132	Kwfxa	Ximdemkokgq	1986-02-10	166	88	\N
133	Jukab	Brrfvwlehih	1991-12-27	200	70	\N
134	Dsiig	Qpnlhozsugs	1993-03-15	206	86	\N
135	Grcrr	Ntlsnkntsub	1993-08-02	165	99	\N
136	Jurgk	Vguygqxpxkm	1988-02-24	168	63	\N
137	Xwfqy	Gmeqjhudkko	1996-05-18	209	95	\N
138	Awcfg	Peigqtvnpiy	1986-02-14	209	71	\N
139	Sbpgx	Mwfbefegyxb	1986-02-22	195	86	\N
140	Yrdrx	Cvygofldpgr	1996-02-13	173	79	\N
141	Rtenx	Fbzjvupgobb	1999-04-06	217	80	\N
142	Inyrp	Ywouoplwxjw	1992-07-23	206	77	\N
143	Kvwpu	Jleycjmueqq	1995-09-12	199	100	\N
144	Vdyxo	Chtitpjqykv	1986-08-18	217	92	\N
145	Afyik	Xqhmdtjsntf	1992-04-02	213	84	\N
146	Rrxhy	Gvqnrehbwbn	1989-07-18	186	71	\N
147	Xfbyv	Ilrmfozityt	1994-07-06	174	65	\N
148	Uunbz	Ymvxbmjuhob	1991-02-02	192	96	\N
149	Knqwj	Hvfdvcxxhhn	1983-02-04	155	68	\N
150	Biopm	Ewphvthmyls	1982-09-11	192	72	\N
151	Ulraq	Itsreqxnuat	1981-05-07	207	68	\N
152	Uwahh	Utnflppufho	1986-05-15	185	68	\N
153	Hcndd	Ypukoycbhlq	1994-09-11	202	86	\N
154	Geryd	Hxlgolgnver	1986-10-10	184	75	\N
155	Uganh	Eeikcvcshgu	1983-03-17	193	90	\N
156	Dleie	Dxpwkpgswnj	1983-06-14	161	63	\N
157	Fxedu	Vmcqsctqoyi	1985-05-14	212	84	\N
158	Tfvoq	Emwutbanylt	1985-05-20	190	69	\N
159	Kypre	Qeeugbxrkhr	1986-01-14	213	62	\N
160	Bbtov	Hmbqfpbtwvd	1994-05-19	209	87	\N
161	Gfdvu	Gvszbfwllfj	1997-03-08	201	82	\N
162	Lyptc	Csrsdwyijlp	1993-10-14	184	99	\N
163	Gifym	Urhonnxwdyo	1984-11-24	212	85	\N
164	Tqhqx	Gbiaxfprlhq	1997-08-14	197	69	\N
165	Suygi	Qycuxdjqsmj	1993-11-11	216	62	\N
166	Icodd	Wvlkysepguj	1992-03-18	153	62	\N
167	Cvsqi	Wbyjcgogtbn	1993-04-25	168	75	\N
168	Ohtsq	Pdihedqnvto	1985-05-16	162	98	\N
169	Kleih	Nqgkupjlgvp	1991-11-21	188	90	\N
170	Bpkff	Kvtuihgcujq	1982-11-12	164	94	\N
171	Jhrfk	Ttggtellhro	1996-08-05	158	82	\N
172	Mbybu	Jtwejeupbcy	1995-10-18	179	89	\N
173	Vhtso	Djgfgdbyffm	1996-10-01	177	98	\N
174	Mnzcr	Ziierfdcswl	1993-05-02	153	99	\N
175	Kqwpx	Obncgczbycb	1986-10-13	198	83	\N
176	Gryii	Guccpubwqwp	1984-07-08	175	73	\N
177	Zwqqy	Iogjweiunod	1997-05-18	213	68	\N
178	Vtczb	Ntwfypnlfln	1992-03-08	180	82	\N
179	Efroi	Mjsteskcqih	1985-08-13	204	92	\N
180	Copcv	Vqoqtzhycew	1988-02-03	179	74	\N
181	Nwwfz	Pobqiifprzt	1998-10-24	208	87	\N
182	Uswzd	Pzjdkekdrnm	1992-08-16	153	93	\N
183	Gpmfe	Nxiokfvmtvv	1994-03-22	195	86	\N
184	Dmqqx	Zvyktthjvhi	1988-02-13	156	92	\N
185	Orodu	Dtkdjtndzkd	1997-01-03	188	85	\N
186	Ngvxt	Fxoxfsmrsib	1998-10-18	187	89	\N
187	Rurju	Iqkfyiwmkhh	1998-04-25	167	70	\N
188	Njcct	Kfwiamlglen	1984-03-21	198	84	\N
189	Hjjpn	Rmjbjdmkzuy	1995-07-06	204	87	\N
190	Qbdyn	Fygrmasfppg	1991-01-02	176	90	\N
191	Pnjbn	Bvdmkdnglxw	1985-06-13	186	98	\N
192	Kgbsk	Efsbiedimsl	1987-09-09	160	96	\N
193	Gtvrk	Wwjhymwgtvf	1997-04-06	203	65	\N
194	Ykiiy	Udvwcldhuus	1984-03-12	200	98	\N
195	Muxwb	Fvlxjusvich	1989-04-23	206	92	\N
196	Iycwu	Iervkcrkjiy	1985-09-05	155	89	\N
197	Hcjrn	Qftdlgtvgmu	1984-11-23	162	79	\N
198	Hbrwb	Kcgsdkthdbj	1988-02-16	207	74	\N
199	Czmwh	Oysjyeiuffn	1985-10-25	170	77	\N
200	Wyeff	Wqonmmbcfyq	1982-11-05	204	86	\N
201	Obaet	Boeqgnmhrew	1992-07-19	166	82	\N
202	Dodlq	Ftknjsfnjzr	1985-01-12	177	82	\N
203	Npktv	Tkidbwevgbk	1998-04-13	218	97	\N
204	Xwgys	Lvypofmfwqr	1985-10-11	183	66	\N
205	Ugzhz	Dzhefghcbnb	1983-07-10	191	82	\N
206	Uwrxd	Pccgdbiazel	1997-10-23	153	90	\N
207	Simzl	Vkyxjsjiwrg	1990-06-13	196	78	\N
208	Hqtee	Nsxmacjtemo	1980-03-03	179	80	\N
209	Dxynp	Krvakbevpfg	1985-04-04	198	80	\N
210	Itrqh	Svezkelukil	1988-07-12	184	97	\N
211	Cisbp	Kbiqumotbdy	1991-10-16	166	77	\N
212	Jfgcx	Rgydqppdesv	1997-01-20	178	82	\N
213	Fupwy	Eabuaplvjcc	1995-08-13	186	78	\N
214	Utwdh	Ejrivmuwdrk	1986-08-02	179	96	\N
215	Igeoe	Lpjywsrgldo	1991-05-25	160	88	\N
216	Jhqrr	Cqrsriqwrev	1983-01-20	205	89	\N
217	Gsivf	Cfqvdnqcwup	1985-07-20	201	88	\N
218	Muhnq	Zghupcymixq	1985-04-06	184	83	\N
219	Kcccr	Edijhtljyzs	1992-11-12	194	79	\N
220	Flpbf	Gqilmkyhrag	1981-01-23	187	74	\N
221	Skxys	Cveildykbcy	1994-11-14	215	81	\N
222	Ymotk	Ahbsuhyhrvf	1982-07-13	201	88	\N
223	Ruhwn	Jmgrktvccfi	1995-07-15	202	87	\N
224	Qqtqi	Jbsbsriscbq	1982-10-20	195	64	\N
225	Xydmn	Cqfburoorii	1986-05-25	207	74	\N
226	Qhejt	Htbwojmvjnd	1984-10-03	203	92	\N
227	Nfhey	Ngxesjmltwj	1991-12-26	203	96	\N
228	Dkkas	Gbxgklfflum	1980-03-08	203	67	\N
229	Eqmeh	Ghgyoxotdie	1998-05-11	204	93	\N
230	Tjxks	Rdefnwmswsd	1999-05-13	200	85	\N
231	Ydspc	Xogkmvmomxj	1997-07-08	191	80	\N
232	Ehrhv	Ugwopvuhacc	1982-11-21	164	69	\N
233	Dfeeu	Xqdbloierto	1982-05-16	157	93	\N
234	Eocuc	Kcebukiwiiv	1994-06-04	212	89	\N
235	Gxopw	Dojuagaumzo	1987-04-26	158	78	\N
236	Mvsnb	Kyupkzeqtdd	1988-02-15	161	79	\N
237	Vdttn	Yxdwbhcaffm	1995-04-12	210	82	\N
238	Jkjzu	Fspdnheygxh	1996-04-14	152	65	\N
239	Jaese	Beoqmudjxsj	1984-11-23	163	90	\N
240	Slmgo	Lalffeoobek	1995-09-08	169	89	\N
241	Mtcsr	Bmjmaxnyxqt	1993-09-05	216	73	\N
242	Ogtul	Jtilpsfffgw	1981-01-13	199	73	\N
243	Skxnq	Wuuefpjcabc	1984-10-16	176	86	\N
244	Xgpfx	Cicudfddwyd	1991-08-26	191	67	\N
245	Bicij	Xrxxmdhsxwl	1981-12-16	153	61	\N
246	Xdwgw	Nxucyttpwdg	1991-08-18	203	65	\N
247	Upkjk	Grdcpvvkuph	1998-11-20	159	91	\N
248	Otdmq	Tsriwgvybxe	1984-09-23	206	61	\N
249	Fdxkh	Ldhexzqpxgw	1994-07-24	163	88	\N
250	Duwef	Slyzqrulxer	1992-02-06	215	74	\N
251	Fwjsp	Trrnkueluqn	1981-09-27	170	74	\N
252	Baxyk	Ijgajkpgzlz	1987-05-14	165	97	\N
253	Skyvg	Yrhhfxybfmf	1993-01-09	154	73	\N
254	Cgkpr	Vkwgerbctnq	1998-07-19	180	67	\N
255	Dkymt	Jzvaduxfrqs	1984-04-13	162	61	\N
256	Dzqnf	Osenewxfkoc	1984-06-15	214	87	\N
257	Kfvkz	Plyfxjghznk	1986-12-14	159	61	\N
258	Wyove	Xenheulddql	1986-04-06	196	81	\N
259	Jmdim	Kbmkcfbxqou	1991-06-27	196	64	\N
260	Rayst	Lumqbmhhxwh	1983-07-03	198	98	\N
261	Zgkdz	Yjkcolkhllj	1991-04-05	171	69	\N
262	Suudr	Rcurfoutorz	1982-05-27	182	96	\N
263	Iihus	Owdlfbglsdi	1983-06-14	153	83	\N
264	Bocdg	Wkduhfvitxe	1985-03-20	212	68	\N
265	Cbedz	Lockkurwkwp	1995-12-25	171	73	\N
266	Hayol	Wwwnbpuekzo	1993-02-22	157	63	\N
267	Ipbyq	Kpvjjwosnak	1998-12-23	153	96	\N
268	Lxwls	Opyapivpuib	1999-06-10	159	92	\N
269	Powmf	Ofkqmgybhle	1987-08-16	166	79	\N
270	Mxivt	Jhjsvtskkiv	1989-10-22	167	73	\N
271	Ocqyb	Cxiqoeikyqu	1982-03-23	209	77	\N
272	Gyxyx	Nxivnlulyal	1987-05-12	202	64	\N
273	Yucsq	Xlknmobsfpn	1992-03-10	180	90	\N
274	Cdndv	Nwzwfnmvwkb	1998-02-21	163	60	\N
275	Glgvs	Vhesspsyeac	1987-10-07	210	67	\N
276	Yxzrf	Argpxsmsnxg	1994-06-10	154	89	\N
277	Ufdjj	Qrastglgjxv	1992-07-15	163	98	\N
278	Jftiv	Yaejmmfmncj	1990-10-20	173	94	\N
279	Toepq	Gacwsscipvy	1988-03-24	164	86	\N
280	Evaeq	Bqneznvhzgd	1991-08-17	176	80	\N
281	Nqood	Xejryihmocc	1987-10-11	195	100	\N
282	Urcks	Vucamwkryct	1988-06-09	171	72	\N
283	Nttwx	Fpcytjsijkt	1990-05-12	182	90	\N
284	Clccd	Dlrtonwstko	1985-02-07	205	66	\N
285	Aignw	Hrtbelmfiog	1983-04-04	161	86	\N
286	Dwmsw	Aweenocagis	1983-08-23	201	95	\N
287	Xyzrq	Euatuwughbj	1998-08-11	209	70	\N
288	Fcxwf	Cfowvatuene	1987-06-27	156	79	\N
289	Plgef	Couhpkefrys	1992-11-18	190	94	\N
290	Fgfgl	Icjiscqxfzy	1982-11-21	151	98	\N
291	Iomwt	Etzmtmwkbsf	1988-11-02	200	68	\N
292	Allwd	Srkqqdgguho	1995-02-18	175	77	\N
293	Dqxce	Wttytdfnufv	1982-11-09	178	77	\N
294	Azfqt	Ylguqfbxciu	1986-09-22	217	88	\N
295	Ihfeh	Jwbhircrlzo	1981-09-16	214	70	\N
296	Mdswu	Xeamklokboc	1986-11-01	177	94	\N
297	Rxlff	Pjrbiqtkdjp	1996-11-28	173	61	\N
298	Fhhns	Hhthkcmbyfx	1985-03-09	168	85	\N
299	Nhbiu	Pvhvtctnpde	1981-01-11	201	67	\N
300	Lsifi	Nvstisyflhs	1985-08-11	165	66	\N
301	Rrvvy	Zrleskvfpwt	1991-05-02	164	96	\N
302	Stuuf	Qyffvcryeei	1987-02-04	154	96	\N
303	Xckpg	Hprtgdgepnc	1984-10-13	213	88	\N
304	Tpryd	Bwtjxisidnd	1996-08-04	163	84	\N
305	Awqms	Alucipujelt	1986-11-05	200	85	\N
306	Qbxqm	Ewbqxbcdulb	1986-07-15	152	81	\N
307	Rdwyy	Vsjptmrlqnb	1997-10-24	194	69	\N
308	Bmadn	Qftlvbektbu	1983-12-03	154	85	\N
309	Xwnjc	Erdfpkannfr	1991-06-22	215	62	\N
310	Xcjkb	Duntdioyhus	1984-10-12	187	79	\N
311	Qsnnx	Lqfrvjvvqhp	1987-07-09	201	72	\N
312	Sytbv	Cliemofqykv	1991-12-26	194	84	\N
313	Iuykn	Mnylwvpbsec	1998-07-06	172	73	\N
314	Qicqc	Bwutkcsfprw	1995-10-27	154	70	\N
315	Wrxww	Gtqsrhvqyuf	1995-02-14	158	69	\N
316	Vlgyk	Lwnshpozoew	1983-11-18	164	62	\N
317	Ocbsr	Mplfsnujfzi	1980-03-10	184	65	\N
318	Vwjoo	Pmtkkwsrwoj	1983-09-01	194	72	\N
319	Zrufk	Ohwyywlxbaw	1981-09-14	156	94	\N
320	Pngtt	Yagtetpncbo	1982-02-01	189	78	\N
321	Bliqp	Hxwrxcvdyuj	1981-01-11	212	83	\N
322	Ztnnl	Lqqiymdsryq	1983-07-19	155	69	\N
323	Naymi	Xqsseiyxmon	1993-06-01	211	91	\N
324	Ftrif	Mvsmcxopukp	1996-04-26	161	84	\N
325	Zdlhh	Xswkhfeiafh	1982-09-02	181	78	\N
326	Pfxul	Cjckoexoyao	1991-02-15	193	94	\N
327	Oypwc	Vyojfifrclm	1994-10-11	170	98	\N
328	Dxrhx	Flbfktnbtid	1998-03-16	217	95	\N
329	Uuunk	Kdpgprrqaqw	1999-09-14	204	87	\N
330	Sttth	Yhplkmlctff	1981-07-24	208	98	\N
331	Lmjiu	Frkfzrkeiip	1998-11-11	193	91	\N
332	Upqjb	Ausmhxlubvl	1997-12-16	202	94	\N
333	Ahktt	Qwmhqmvmydg	1991-02-20	204	88	\N
334	Civdj	Tvowgaxmdof	1982-06-14	163	69	\N
335	Crshw	Vnnqtdnmghs	1985-12-21	210	78	\N
336	Vnbcc	Ckirgknjfyf	1998-05-26	164	81	\N
337	Ditfc	Mdxvekxhkdw	1998-09-14	202	76	\N
338	Gylhv	Ufgeuhvtfhs	1996-02-14	203	82	\N
339	Qjxud	Tghmcuwymcc	1997-07-14	169	70	\N
340	Myvgr	Bcjqnembfiw	1981-04-18	188	79	\N
341	Djfne	Vvkpebcqgvu	1992-11-19	218	93	\N
342	Bgyem	Donbueqxnvl	1998-09-09	184	89	\N
343	Cxpfk	Seugbjmfdyi	1988-04-10	166	82	\N
344	Fyqro	Qgjezmjjfbp	1992-11-04	196	89	\N
345	Fcjyl	Ltcusexmsde	1990-10-15	194	95	\N
346	Ksfpa	Uyhaucaadqg	1991-11-04	218	73	\N
347	Ianmb	Rukolqyqmbs	1996-04-22	214	65	\N
348	Anvdo	Eedditsgpvy	1992-03-13	192	98	\N
349	Txxph	Mobieqbvmhl	1994-10-23	196	67	\N
350	Fvhqn	Eepbtxtbwht	1996-10-02	166	89	\N
351	Vvpbh	Bbbyltumyks	1992-10-26	158	96	\N
352	Glxik	Vewqbcosklx	1983-02-02	169	98	\N
353	Nkecl	Nqaorzwrtzw	1997-06-22	152	75	\N
354	Avsct	Tjtbgsrbgqk	1998-10-26	170	79	\N
355	Crgji	Fcinadvubte	1995-06-09	183	80	\N
356	Excgv	Jjjxjrexqqd	1994-07-24	152	68	\N
357	Xetvu	Poysnzwghdn	1987-08-03	160	90	\N
358	Vnktt	Fdjtqbxfykn	1993-08-20	193	80	\N
359	Kppgq	Qintqauehte	1997-11-16	165	84	\N
360	Ddslg	Yzjaidfnwyd	1981-09-09	217	71	\N
361	Gkrby	Snfgjtboset	1982-03-05	169	80	\N
362	Rqrdw	Cjpaoexdkxm	1980-09-17	218	82	\N
363	Lbcbk	Hhytrhgmeku	1980-09-14	202	79	\N
364	Pthvi	Jzklatiadoy	1994-08-25	170	76	\N
365	Rnsrg	Okdgkqbdjpd	1985-05-18	198	71	\N
366	Gdrqb	Eaucpemorcp	1994-09-27	168	79	\N
367	Icxio	Zjgiilksmsv	1985-09-14	190	69	\N
368	Rhima	Urhpzkylecr	1995-05-14	217	71	\N
369	Bgyuy	Ssthkjsrktq	1983-06-05	161	66	\N
370	Wbddm	Gfmnacqeimn	1996-08-04	214	74	\N
371	Jkwiy	Ynlmwdjqbyc	1998-04-15	151	62	\N
372	Kbwoo	Rplcspafise	1998-08-14	208	93	\N
373	Byboc	Jbajvslnjcg	1995-09-13	184	69	\N
374	Kfcqp	Rhelacxfcoe	1985-08-23	182	82	\N
375	Lpuqz	Sjfvpqckkej	1992-02-04	207	78	\N
376	Bouqg	Ocmtbueylty	1991-05-03	189	92	\N
377	Yrsgd	Ujxcwgbvstz	1982-05-13	183	86	\N
378	Hlkio	Eftvxlpubws	1984-02-01	219	67	\N
379	Zuxrx	Ncjrgblkycs	1985-08-02	197	96	\N
380	Kuomb	Awyjgnolmrb	1982-07-14	175	62	\N
381	Xcbll	Okcrsrmijtt	1995-02-20	211	95	\N
382	Sfnpl	Xgpiiwnefak	1988-09-14	176	97	\N
383	Jvvix	Mwlgxfnpxge	1988-04-27	181	75	\N
384	Dxdpw	Vvmwfpwyiir	1983-07-13	202	96	\N
385	Ovugr	Kvtqyjgxlvu	1997-02-19	200	78	\N
386	Ufcvj	Suyfdlvbucu	1987-02-15	212	87	\N
387	Xxbvn	Glcjtybhjgj	1982-03-03	154	88	\N
388	Lhnoc	Cnfhhqqyods	1996-10-19	161	90	\N
389	Yqoti	Rgbxjewmltu	1988-06-10	177	76	\N
390	Egsng	Yyvosjmhjxj	1992-09-08	202	80	\N
391	Iwcwq	Kxpnqcgmaoe	1982-06-12	194	65	\N
392	Ycefq	Aiwdbfdueuf	1988-07-26	217	83	\N
393	Ohioh	Jsmcbjtkkub	1993-11-26	196	67	\N
394	Djrtk	Pofwnlecuvm	1989-04-21	166	89	\N
395	Acrko	Fmqqevbpork	1987-08-16	171	69	\N
396	Kmzym	Eieskfncntm	1996-04-26	176	79	\N
397	Rluin	Iefvguclmqw	1990-07-06	212	70	\N
398	Lagec	Pyunbvqdsqw	1992-05-12	189	85	\N
399	Ujsgz	Wuydnjnxrem	1987-04-23	184	68	\N
400	Cljgi	Zygylrtykaw	1984-11-20	191	68	\N
401	Cvnbr	Syclhgkmvbo	1981-05-23	156	91	\N
402	Uuyrr	Rtsnmttmtnu	1991-02-18	201	67	\N
403	Zvxnf	Mqofxmnfsfn	1988-08-07	192	90	\N
404	Rmnnj	Lvwjoeugqcv	1996-08-02	192	96	\N
405	Kpmll	Priqhosimjv	1991-02-19	162	76	\N
406	Pqvhz	Rruttafmyrf	1987-11-13	203	93	\N
407	Huksq	Qibqupeptnm	1985-10-05	165	79	\N
408	Gxkzt	Uhxnsqkbcgc	1985-08-09	154	98	\N
409	Ecxmy	Wbkxfzuqltw	1982-07-12	172	61	\N
410	Nsgmq	Irgqdijnbqf	1994-10-12	204	69	\N
411	Bjhtt	Qodfwhoyvnx	1993-06-16	208	80	\N
412	Bytob	Cuuepbcxbcg	1992-01-04	207	95	\N
413	Swmdj	Qflfcztngvc	1985-05-18	201	73	\N
414	Hcgoj	Xyyzhvsxbfe	1981-05-26	189	92	\N
415	Dftcc	Spchhykdstm	1997-10-12	157	98	\N
416	Ldvtn	Oxqgtczwbnh	1995-07-20	206	75	\N
417	Qtwfh	Ruuuksdkrta	1982-12-19	189	62	\N
418	Ssfbf	Mfkrmxokjwu	1995-08-04	214	93	\N
419	Ptckx	Ggbhohpfxhv	1983-05-15	197	73	\N
420	Nkypd	Igjrplcgfhr	1981-05-19	161	66	\N
421	Dwqnb	Qyyfcjfgqfa	1996-05-22	189	90	\N
422	Tlrij	Qymoduwvftq	1998-02-02	175	98	\N
423	Qkaud	Wkzeepoefuj	1992-11-04	166	88	\N
424	Xrger	Wabnqlglusp	1981-10-17	183	62	\N
425	Cejlk	Gsyddgdpztd	1987-09-10	188	61	\N
426	Qgvxq	Dujrgwuoudt	1984-07-18	183	78	\N
427	Yexuh	Bqfukmcvcha	1988-10-12	166	70	\N
428	Tvgjq	Bdcjtysjdgq	1981-04-25	205	73	\N
429	Qotgd	Tiuglnhkrrv	1990-02-27	168	72	\N
430	Hnwui	Dcsroeqmbdk	1991-04-11	159	61	\N
431	Ojahn	Cphtchivvvm	1982-10-11	156	80	\N
432	Tulti	Spudvvkzopp	1999-04-16	204	94	\N
433	Piflx	Ppxtzxymdgm	1995-01-07	166	82	\N
434	Zilue	Ghshycmfuqe	1994-11-27	169	64	\N
435	Ggwim	Qkucwiipdxy	1991-07-22	200	82	\N
436	Hdgwf	Qbyclqrebxj	1993-06-06	217	89	\N
437	Jwyop	Cfbavdpogqn	1986-11-16	194	61	\N
438	Doyhh	Veifihfajpk	1987-07-25	207	91	\N
439	Fcitq	Plpnwmxrrhr	1998-07-07	191	69	\N
440	Rjtkc	Dqomspbjlhc	1997-07-16	161	84	\N
441	Ogtph	Ixxtsaoowof	1987-02-10	217	85	\N
442	Nmbtd	Cvdczhoomwo	1993-06-27	154	71	\N
443	Tswpz	Pbtglgnuiwk	1996-11-02	180	72	\N
444	Omfcq	Dvtfkooyqkd	1992-04-19	202	75	\N
445	Eqbdj	Bexsaltlvfw	1981-04-27	214	64	\N
446	Fekwu	Sbpbvhobtuw	1998-06-18	159	77	\N
447	Qadsr	Tlovwjlrvwl	1996-10-08	167	95	\N
448	Bdqcu	Odsaefuiqlj	1998-07-15	170	82	\N
449	Wsmwo	Qllbimxnpbr	1983-08-08	216	80	\N
450	Sfvtg	Unbmiftijdw	1992-03-18	173	72	\N
451	Porsl	Kcveayccwwl	1993-06-12	166	96	\N
452	Kbzcg	Evtsfiyqjhe	1981-04-28	175	80	\N
453	Ugvtq	Nzyyiakmfmq	1990-03-18	210	66	\N
454	Zwlwq	Mojyfhtuxws	1986-08-19	188	97	\N
455	Ojkib	Fonpppfwmhk	1983-02-10	191	94	\N
456	Mqkpi	Wihnajlsdqy	1989-10-03	203	80	\N
457	Zunse	Xshmoifjplt	1983-11-24	209	77	\N
458	Bytbi	Lnxcmwmhkze	1995-06-16	174	83	\N
459	Pmkhd	Whbumktvvqt	1981-05-11	176	82	\N
460	Qqagx	Wlugquqbrnw	1995-06-23	213	65	\N
461	Tpzbn	Hhkmrusfxcy	1981-03-22	191	73	\N
462	Xsman	Glculibkkyn	1992-02-06	213	93	\N
463	Grsin	Hfxrvkrisjq	1998-09-16	201	92	\N
464	Xkgxx	Mzpkwquqxqn	1993-01-27	202	80	\N
465	Stxeg	Pqagchlvieq	1999-02-08	158	99	\N
466	Ubhbf	Gppyolbnnri	1985-11-08	199	61	\N
467	Znszz	Uoseaiwodrf	1983-08-15	178	68	\N
468	Abber	Tqnsriuiksu	1988-05-13	154	83	\N
469	Bfycl	Ghchehocuce	1996-03-24	210	89	\N
470	Pwqci	Tjkzqoocxir	1984-10-16	188	68	\N
471	Zccei	Uwpxkxpofsv	1999-04-14	155	73	\N
472	Vsfkw	Xgevtlciiqg	1991-08-07	163	86	\N
473	Gwlek	Fefkhnmjnnb	1992-03-17	173	73	\N
474	Xwglx	Deoqluhayol	1987-08-21	211	74	\N
475	Wxrgj	Vowcexqtriy	1994-11-19	157	65	\N
476	Yfvdd	Jtbqsditppr	1985-06-16	204	63	\N
477	Smbpt	Dudlgjdjkxg	1996-11-12	180	100	\N
478	Nhptw	Cuupkgdmqbv	1997-08-04	191	72	\N
479	Criit	Ujekcrcdvow	1981-09-22	163	69	\N
480	Fuvsg	Aevdhoewrmt	1989-05-12	156	84	\N
481	Awrjw	Ivkznhqcijy	1997-09-18	194	86	\N
482	Cutcv	Ksgcvhlxzij	1996-02-06	178	85	\N
483	Psdbu	Gnnqthnnujn	1982-08-25	156	98	\N
484	Bpblj	Occeqcgnnbf	1995-11-26	174	94	\N
485	Nyagd	Eyjodltnnfj	1981-03-20	154	65	\N
486	Kjeia	Iumukxrddml	1998-10-20	196	88	\N
487	Hpmkb	Krxdwzdlfje	1986-12-22	198	62	\N
488	Bifet	Lvcmacimbzt	1982-03-24	218	66	\N
489	Vrsmi	Otqxvulxjzp	1987-05-27	216	84	\N
490	Hyidk	Uiffpnlhslh	1984-03-05	187	73	\N
491	Gqhlm	Umsobcncecj	1982-11-27	187	82	\N
492	Flvyy	Znpsloqiuee	1998-04-02	170	99	\N
493	Eownk	Fqmdocbfmqg	1985-04-21	210	90	\N
494	Lztct	Hbgpuoxpoda	1998-07-13	180	98	\N
495	Uvcwm	Xecrylsackx	1985-02-05	194	65	\N
496	Bkedn	Gzthjdrkose	1984-09-21	178	86	\N
497	Liybd	Xfavhkfqyop	1983-02-01	189	87	\N
498	Xmpne	Ioabbepvrkv	1997-12-06	213	60	\N
499	Pgokq	Lpcwdbytnih	1983-03-08	208	68	\N
500	Ecurf	Rhmludlqqjy	1987-05-04	194	80	\N
501	Hazlq	Icctzknbmyv	1981-04-26	156	86	\N
502	Fegdn	Hvgnvegmbcp	1989-09-06	209	72	\N
503	Wwagw	Qjwyvvebpee	1997-03-21	163	79	\N
504	Pkuuq	Gfbzzriltkr	1993-09-15	214	63	\N
505	Evdyf	Iupbotmjrhe	1987-08-19	182	86	\N
506	Mwzmn	Semcbhocdrs	1984-03-07	175	93	\N
507	Eexus	Vfusqcbvlim	1984-10-07	182	77	\N
508	Jacaq	Mqjjsrcoxfs	1997-09-26	159	74	\N
509	Srqtg	Idpprvvnjyk	1997-03-24	208	98	\N
510	Qtzlv	Eeiwwitxkjw	1984-09-12	173	93	\N
511	Ervme	Zyyagipfrws	1991-02-11	172	71	\N
512	Kwbnl	Nekzsyroody	1994-03-12	181	69	\N
513	Jjhys	Mfubtcdcnct	1987-11-02	166	80	\N
514	Nlzez	Idfkntstwva	1999-09-09	187	71	\N
515	Ivpvw	Lrozuotsviy	1989-10-19	157	88	\N
516	Oqgbp	Dmqdcyzwfdo	1994-05-05	206	86	\N
517	Uagbd	Jejsrfpdqon	1997-10-05	171	79	\N
518	Nsxsj	Mihrcibttpt	1988-08-27	215	95	\N
519	Ltgck	Ipiolozfuri	1994-10-09	192	77	\N
520	Xsgaq	Dpgzlhlphwy	1993-04-26	185	85	\N
521	Iihoh	Pwsxxljvkpq	1998-11-03	200	82	\N
522	Loees	Xcejpossudq	1996-02-23	196	63	\N
523	Wndcp	Mtbmjbdeqsf	1994-12-19	155	99	\N
524	Vwyso	Xuvzsghqhqs	1984-06-24	190	93	\N
525	Gcijr	Lbjvlxrylyd	1988-02-23	203	66	\N
526	Okrvd	Gautsoymvho	1994-04-16	179	69	\N
527	Lccpq	Qcotptuhloy	1984-02-26	155	99	\N
528	Aotvh	Imhhlyugofv	1987-06-04	203	69	\N
529	Zwihv	Fpkyhbrapxr	1990-04-07	187	91	\N
530	Qkgmb	Jnedyfrmcxp	1996-02-01	169	89	\N
531	Ylhfi	Jnginghosxi	1985-05-05	187	93	\N
532	Qkhmv	Ckliykytpyl	1996-07-27	158	66	\N
533	Vqbgx	Gtunhvyvvtu	1997-04-26	201	80	\N
534	Oolan	Usnqsmxdubf	1986-01-26	190	84	\N
535	Exwpm	Eauyjndphre	1984-05-06	200	100	\N
536	Gflla	Icwpzqxmejy	1994-10-13	168	85	\N
537	Fdyts	Ysrkjgupzpi	1983-10-20	215	75	\N
538	Ggyrm	Mnghuhgbxay	1984-10-12	175	91	\N
539	Jgmnw	Yxikjoloeuv	1999-04-22	201	60	\N
540	Gvauw	Uyiexfbdesf	1996-06-14	195	72	\N
541	Xwdrw	Oljmvecwute	1994-07-17	154	78	\N
542	Wmlrv	Tjlvfocpsyl	1996-04-07	186	62	\N
543	Htogc	Yklfwwupqvd	1994-08-09	195	69	\N
544	Rlqzo	Imqwoxrtpup	1985-03-04	191	62	\N
545	Ptwev	Lypkitiqlco	1989-02-05	165	66	\N
546	Lphzh	Rgukooruckv	1980-04-11	156	92	\N
547	Hwiue	Qgloftihfrc	1995-11-09	194	87	\N
548	Johfg	Hqthafvuuki	1984-08-12	195	65	\N
549	Kkhei	Uimdwqddprf	1988-05-10	178	62	\N
550	Sucrd	Xfwpcffgmtv	1986-06-28	191	65	\N
551	Wsqni	Pmbcuarohlp	1984-08-03	176	90	\N
552	Polgm	Ilhhpfpbftb	1993-05-13	186	83	\N
553	Gpmhq	Jzvuuhxsble	1981-05-21	158	70	\N
554	Glxbq	Sihcizkqdko	1985-05-13	167	67	\N
555	Igayn	Ueepchxeduq	1981-02-07	185	61	\N
556	Mobpp	Evofhlkfsvc	1995-07-17	197	94	\N
557	Pbiql	Oravhlpumnd	1983-02-17	171	68	\N
558	Qzksm	Pgphfavwpdn	1986-09-26	217	86	\N
559	Bvetw	Mrlfinzkvuc	1984-03-26	211	81	\N
560	Hlwgs	Ugumpfqomdv	1984-10-08	193	83	\N
561	Emfxy	Gmeocfecfat	1990-03-21	155	74	\N
562	Fefqh	Xfodkfqmbjc	1984-06-13	195	72	\N
563	Fizgr	Gbpkswmbsbp	1995-05-13	178	90	\N
564	Mpgsi	Coqtmxixsqz	1998-11-20	195	60	\N
565	Oaeks	Yicfprgwsrg	1986-04-12	209	87	\N
566	Oipqe	Demialsftjd	1993-10-19	188	60	\N
567	Zgqjr	Sokctdrxbrs	1991-11-05	206	70	\N
568	Cbkii	Tbtesojhmxm	1989-03-16	198	97	\N
569	Frcky	Ueugcsuvocn	1983-05-13	185	72	\N
570	Hqsep	Sjllubscyqg	1993-01-04	206	78	\N
571	Hhvzw	Dzgrkjamwjx	1996-01-06	189	85	\N
572	Vyfzg	Urlbseuisdw	1980-10-20	162	81	\N
573	Ldscj	Uchsjuhcxjx	1989-07-12	219	92	\N
574	Trsdq	Vllocuvjvbd	1994-01-13	165	86	\N
575	Viwja	Apyguocmycz	1980-06-05	177	67	\N
576	Woypu	Qqtlglokcgm	1994-08-22	175	84	\N
577	Ygrvr	Feyytbunbrx	1994-09-26	154	96	\N
578	Pfrxv	Ovzkrvokhyh	1982-03-11	188	77	\N
579	Exysi	Nuagjnxiobf	1997-05-18	158	62	\N
580	Qysut	Lemkwhchpdx	1982-03-15	167	63	\N
581	Rujzk	Pnxciugqnck	1997-07-26	166	77	\N
582	Fgrjm	Njflhcvwenc	1997-10-06	209	92	\N
583	Rgytk	Dmpvhqexavv	1992-06-05	168	91	\N
584	Hxlkj	Mhioxxignkc	1996-10-24	214	64	\N
585	Snkui	Jqfqynpxhss	1988-01-14	202	65	\N
586	Qrgri	Ypiibncgrvt	1983-08-14	212	73	\N
587	Etcmh	Cqyqwppgnbw	1998-07-24	191	93	\N
588	Cpuxi	Krjhftmumsp	1995-10-19	160	95	\N
589	Vinhi	Ugmbghshgmc	1985-09-02	212	85	\N
590	Rreym	Ofrksseljgc	1992-07-21	200	69	\N
591	Oxcfs	Lhzeljlvxrd	1998-10-18	173	72	\N
592	Opibg	Scufkbklccz	1982-06-08	179	63	\N
593	Ipwxt	Mlfbigdmddy	1995-09-18	190	70	\N
594	Piopx	Ttmkoiscjve	1995-03-05	208	73	\N
595	Kvlnu	Objutbtfnij	1986-07-26	180	89	\N
596	Fopfg	Iohewulqkyj	1988-04-15	202	86	\N
597	Cwhmz	Xqtvqqdbxzy	1988-09-02	188	86	\N
598	Ozhun	Kmgkltigiix	1985-01-07	210	77	\N
599	Nnhwc	Csiexyfwigq	1982-09-08	165	87	\N
600	Waspj	Tqqtvctkwyj	1994-06-02	183	84	\N
601	Cyesb	Ycgblcujvny	1984-12-15	200	75	\N
602	Feuvv	Ufykrejszhb	1996-03-23	214	70	\N
603	Dtxwh	Zeupkuxvqww	1983-01-13	157	64	\N
604	Tlmie	Vurgxjzdgqn	1986-09-23	206	74	\N
605	Uilmk	Rmdpcesuvjp	1995-04-10	211	63	\N
606	Fmsjd	Kgmifbmatxf	1987-07-04	204	72	\N
607	Zfpua	Fvdpavmroeo	1991-10-26	203	72	\N
608	Mggli	Lnqinahmmdp	1981-06-27	175	68	\N
609	Oiqyc	Cchoajlnltx	1998-07-18	186	84	\N
610	Wwntn	Kxumxqhqcwi	1984-10-22	158	78	\N
611	Asbgi	Mlqccivrfky	1992-12-24	186	96	\N
612	Yoivg	Pneiiztcxlo	1985-05-12	152	91	\N
613	Kdgoq	Qfdqolvcmlj	1991-03-11	176	99	\N
614	Nncko	Uzpykosdsib	1982-05-19	193	69	\N
615	Efrfk	Mwdatxhtrop	1984-07-04	160	87	\N
616	Ovlor	Shuexevnswh	1992-08-04	177	92	\N
617	Oyufv	Hoptmocupum	1996-04-11	218	90	\N
618	Vmogv	Lmqxfjvggux	1995-05-08	212	96	\N
619	Pfdfp	Vpxexqdoyeq	1997-04-27	184	61	\N
620	Kxarr	Rkprbwvwliy	1984-10-04	199	72	\N
621	Dtosz	Ohkpwudhphe	1993-04-01	192	91	\N
622	Tyrya	Lyrlukbbptk	1988-10-20	183	83	\N
623	Utgjo	Piowzelcifx	1998-05-15	216	99	\N
624	Ofjuf	Icqvyezijmj	1982-11-03	185	90	\N
625	Gdvgf	Kroudwmevoy	1994-06-02	178	63	\N
626	Jmoga	Tifmhcbyhpy	1983-02-06	219	66	\N
627	Tntck	Lekphimfkbf	1991-11-05	181	79	\N
628	Sleiq	Wmtxbictcgc	1987-10-19	206	75	\N
629	Mdldk	Srhcekqvsgp	1982-06-20	209	92	\N
630	Dkgcl	Lwpphxdvzww	1984-03-09	190	74	\N
631	Fwhse	Hzkdkruwbyv	1988-06-22	209	96	\N
632	Wveji	Yrxwhbesjdo	1984-03-13	206	97	\N
633	Vgypt	Negurqijbcs	1988-03-21	166	62	\N
634	Kvota	Srjfqpogxep	1997-08-06	215	93	\N
635	Ewpru	Grrhrssrikq	1996-05-21	174	87	\N
636	Wzfap	Fyjctwlsivx	1994-06-26	217	69	\N
637	Lbjqh	Tsuyfbwdnsg	1995-09-18	184	99	\N
638	Ympxr	Otirhgotmus	1982-10-07	191	60	\N
639	Nifjb	Bmnqikgqxmj	1995-02-02	168	70	\N
640	Mmewi	Dvykyycoirr	1985-09-06	168	81	\N
641	Gljkk	Gfxnsjqjnnv	1985-04-25	180	79	\N
642	Kltdl	Inffbxeaxcj	1992-07-19	160	73	\N
643	Ezydr	Ckemfuerywm	1984-11-12	185	90	\N
644	Lcvqd	Dmstfhedwvq	1997-07-16	175	70	\N
645	Prkmp	Uuzvmjcgwqh	1983-04-14	155	68	\N
646	Zncsa	Tjmcflhiioo	1998-11-19	153	92	\N
647	Mlxdh	Shpeypiyuvv	1987-10-03	167	93	\N
648	Mibdq	Jmxljubxgcq	1992-07-12	201	92	\N
649	Gbnjv	Rpgywkexwxv	1997-10-06	155	92	\N
650	Dtpsu	Domjikzmyjn	1988-08-10	208	93	\N
651	Wbmbn	Wtxhokvjjem	1985-08-03	166	91	\N
652	Yrwjf	Fxsppqssqty	1998-02-12	173	65	\N
653	Hvhgw	Csqwhjhvgxl	1994-10-14	189	62	\N
654	Xjoft	Jskgdipgqvj	1994-12-17	208	71	\N
655	Nxysj	Zfewlxkjgtv	1984-03-23	216	77	\N
656	Erfgg	Mgkahvowqti	1995-03-02	182	68	\N
657	Naeiw	Tedttsicryd	1990-02-25	188	80	\N
658	Xlvwf	Alcptpvavrg	1993-04-24	186	74	\N
659	Swkib	Csxqtniiwfe	1986-07-08	157	63	\N
660	Nsjcs	Xannlewzjlq	1983-03-21	159	64	\N
661	Nlddp	Gfymavdlwer	1981-09-20	203	65	\N
662	Knjrb	Gmwbdtvfjmr	1987-11-12	182	91	\N
663	Iqdtk	Nmecyfdchzu	1982-11-09	200	60	\N
664	Rkicg	Wkfvbhlcbje	1983-12-03	171	81	\N
665	Bliba	Btrknnqivhf	1988-08-26	217	92	\N
666	Ctxxi	Zufyktsowyn	1981-08-18	210	72	\N
667	Mubsj	Ibqiuifdtbr	1998-05-25	206	78	\N
668	Puobz	Ekwdiiqxosn	1981-02-07	162	77	\N
669	Hhwfx	Tvmanenmgxk	1987-02-14	202	64	\N
670	Plqps	Sksuumpfkgo	1992-12-06	208	98	\N
671	Xcrtv	Buruqjknnll	1996-02-23	209	98	\N
672	Qrlsj	Twcaqvrbscp	1988-03-01	168	99	\N
673	Glxwk	Xfvkthjoyxh	1983-03-13	183	91	\N
674	Uuesr	Wfxkttwevru	1987-05-10	171	92	\N
675	Umcmv	Zbgnhqisszd	1999-10-11	173	81	\N
676	Syyqx	Tlxvktitvdo	1983-03-17	189	91	\N
677	Uhjrh	Rhughdhrgyg	1986-11-14	176	69	\N
678	Rbzss	Bvpdsldipcj	1992-02-06	186	88	\N
679	Hnalk	Plbuywgjcnx	1984-03-27	154	90	\N
680	Sprli	Xkbcvewdifx	1989-09-18	187	68	\N
681	Nkaqt	Pxuvuitxtyg	1992-07-20	189	71	\N
682	Nmouf	Rowsmprvukc	1998-02-10	199	74	\N
683	Oyheo	Kfjntezkaee	1998-05-27	183	93	\N
684	Ptlyr	Cctgtgbdrqu	1996-01-07	164	64	\N
685	Wtfxl	Limpvemzsdo	1988-08-12	204	95	\N
686	Tshbc	Iconluhnvxg	1983-08-01	179	66	\N
687	Pwkjm	Gpwzgjbajim	1996-02-20	193	61	\N
688	Nyxcp	Ollbcwbvgnv	1999-12-11	208	94	\N
689	Cxxun	Dsrjexsnylo	1996-06-03	199	91	\N
690	Bmcgn	Azeytuhkkjr	1992-12-24	156	85	\N
691	Qqklx	Fwhqqgiqnxc	1981-12-27	163	73	\N
692	Xsklw	Efzdasrkivx	1996-08-21	159	76	\N
693	Wgvjx	Sjyhnbogwgj	1985-04-11	185	85	\N
694	Jwcwt	Pgzpraefwtn	1988-11-02	159	79	\N
695	Wlvsq	Mfyibbtntge	1996-12-13	210	74	\N
696	Vpzvp	Kwmyhybvgsu	1985-03-28	197	76	\N
697	Cicwv	Oitbvomvcpl	1999-02-20	209	100	\N
698	Abpxi	Yjdayfcdrfj	1999-08-10	200	96	\N
699	Gpqpe	Bgmbgyksyie	1998-03-12	171	67	\N
700	Dveye	Sehwrggxnmb	1983-03-20	175	99	\N
701	Mxrrc	Bxnrjvsoxpc	1983-12-21	198	80	\N
702	Mkdfx	Jvvcsyceksw	1993-07-08	204	78	\N
703	Wnbyn	Xofohnxkysu	1985-07-09	207	77	\N
704	Rmwld	Onojuihbull	1984-04-04	213	85	\N
705	Qqgky	Hlxydxybkxh	1998-11-21	180	64	\N
706	Spfjl	Zeklrftytxi	1987-09-25	192	68	\N
707	Svbqw	Fjeeqnelwxd	1987-11-03	181	82	\N
708	Rhlll	Cfvnhygsshw	1994-11-09	169	84	\N
709	Lwvwy	Lbxtdtsbrpk	1986-12-02	191	88	\N
710	Nphqx	Dextcvcvjpw	1987-11-25	216	84	\N
711	Sfosb	Vpdepvrrdnz	1984-02-26	187	80	\N
712	Cnyjn	Kjlwejztvus	1997-06-26	215	88	\N
713	Bvydy	Wpwhjrgbzkh	1987-05-09	158	98	\N
714	Kqgyl	Lffvqmfmxeo	1998-05-28	160	78	\N
715	Liuuy	Mtuuzkgnpdf	1987-07-27	182	100	\N
716	Ormfq	Nbmokcpdqwg	1987-06-22	163	80	\N
717	Eslhh	Oarzpyrxpat	1992-06-18	155	93	\N
718	Wyxbx	Eeeqfephxiu	1989-10-23	215	95	\N
719	Pbkvp	Xnvoxffrvxw	1985-01-12	154	71	\N
720	Slguy	Njnptgeqdwx	1988-07-06	151	78	\N
721	Ygfkj	Trynecdoemo	1987-03-23	187	79	\N
722	Jdsvt	Lhvyvlfqmgr	1996-07-12	214	87	\N
723	Plwgp	Wynffbnnkpt	1983-08-18	164	78	\N
724	Rgnuy	Zhrywycifpu	1996-12-18	203	97	\N
725	Rtahd	Lxmiebbpldc	1997-04-22	159	83	\N
726	Ybynj	Hmzwgivscfq	1983-07-05	173	73	\N
727	Rogru	Khsaochryxp	1997-02-04	203	71	\N
728	Mkvlt	Rumopykufet	1985-05-10	207	67	\N
729	Opyim	Suvundundvt	1994-07-23	185	61	\N
730	Bllob	Cmrgtesihqw	1982-11-04	205	98	\N
731	Wdyvc	Yiwqifyhuxc	1993-07-07	151	77	\N
732	Cocpv	Dookyybcmfl	1981-04-26	182	91	\N
733	Tuhlq	Ngcygdgpxcw	1992-05-10	187	74	\N
734	Zemfh	Ruvgpszfngw	1997-10-12	154	71	\N
735	Tepjf	Temeneqscwa	1987-01-24	181	62	\N
736	Jkkwy	Ijykfcicvpo	1997-05-26	169	71	\N
737	Kmhsu	Dqtjzoqkslc	1982-10-26	181	92	\N
738	Ytvtz	Hlloboezsec	1993-02-07	214	70	\N
739	Bchro	Kjmkscwcndz	1992-03-24	156	100	\N
740	Xiswe	Vdundouxcfj	1985-10-17	216	98	\N
741	Oihsh	Ufiqqvugini	1985-07-18	215	90	\N
742	Oxeli	Fxqtdsdtkuy	1996-03-03	164	91	\N
743	Pqjof	Pdudtgsptig	1993-12-05	187	64	\N
744	Iglbs	Qmekotlwnse	1984-09-12	208	81	\N
745	Kjnbz	Zbphiafofsv	1991-07-18	175	66	\N
746	Gcqpq	Drucmywerpx	1982-09-11	204	69	\N
747	Iufne	Womufavpjfz	1987-11-20	164	94	\N
748	Qtieo	Dskyxjwybmh	1984-04-06	181	91	\N
749	Eqrgt	Uvenwikhrwg	1993-04-02	172	96	\N
750	Cyvlk	Eoltcrxirjp	1987-08-12	212	94	\N
751	Nangd	Rhgjhaoevir	1995-06-24	170	82	\N
752	Swfwi	Vwbltmltvih	1996-07-14	177	87	\N
753	Ihdee	Rnachoknrlb	1997-04-10	160	81	\N
754	Ptesn	Ymvsbmfetoi	1988-07-02	182	87	\N
755	Kwthc	Qhqikxrtnab	1985-02-23	155	67	\N
756	Uosbt	Nrtpsceigcg	1987-06-08	170	98	\N
757	Ijcgr	Hjtdedspeuv	1997-09-23	168	73	\N
758	Nhqtm	Bnoecmwygft	1996-03-02	194	64	\N
759	Skces	Kzxlahfxymw	1984-05-20	206	74	\N
760	Xgdxn	Ebiuroigtdu	1998-10-17	215	85	\N
761	Snncw	Cswpfpjhymy	1988-06-16	175	83	\N
762	Iwyxn	Pwtrypfwtaa	1994-06-04	178	88	\N
763	Whfmj	Nbvmmkqytfw	1992-07-03	214	88	\N
764	Qhwjc	Wulibnygxwg	1981-06-04	160	62	\N
765	Svqfj	Rhmtexfygji	1986-02-02	216	96	\N
766	Cqrzo	Qocfvfcbmqp	1985-01-10	178	61	\N
767	Twgvb	Modgpachqeh	1991-08-19	166	60	\N
768	Yepwl	Ohmwiedpbvx	1986-03-12	216	89	\N
769	Llefe	Ppxxxjtuzaq	1987-03-07	206	80	\N
770	Ctyxm	Klpsbxgyygi	1988-07-06	195	94	\N
771	Nvdzm	Rsjyorlbfim	1998-09-06	158	77	\N
772	Wxmox	Ugkfyxltrvt	1984-09-05	205	66	\N
773	Thlyh	Pxptdypgliu	1980-03-10	188	75	\N
774	Rwpev	Yjmjpfzqmcl	1986-08-03	196	78	\N
775	Wjaen	Jgntinlbbfw	1985-02-23	184	68	\N
776	Ckrcd	Amleuwwvhqj	1987-09-11	163	79	\N
777	Igmea	Dhidwnyyatz	1988-03-26	162	83	\N
778	Vzpwe	Lczqmqcufof	1987-03-11	166	81	\N
779	Pfhrr	Yxhqmvmnmbs	1992-09-26	218	80	\N
780	Cnjwu	Koyotmmniuc	1992-06-11	173	83	\N
781	Irpwt	Potsybyaufj	1991-07-07	218	69	\N
782	Gyuvg	Qqsabkzovkn	1994-09-10	167	76	\N
783	Xdvqv	Fcqcyjqfubv	1993-07-15	180	70	\N
784	Fwkhk	Mssttvurwkp	1986-07-15	207	65	\N
785	Ssfue	Bzcpqtvfiyu	1998-06-19	211	80	\N
786	Mxxfa	Eenunxyankn	1991-06-11	152	84	\N
787	Vppvg	Pvkwbrbknbm	1989-01-27	165	95	\N
788	Rnkmu	Bonwwdstxne	1994-12-05	154	74	\N
789	Rhxry	Vpbgzgtnjkd	1981-12-14	167	64	\N
790	Qprdf	Jpyxdvejudc	1982-12-02	163	73	\N
791	Onoce	Qiqnuurygjh	1996-05-27	165	89	\N
792	Eqwix	Yhdwyopnjpq	1998-03-08	158	80	\N
793	Mrwqe	Xzuouquubig	1997-03-08	155	68	\N
794	Jjkjn	Lqeiilbunfs	1984-10-05	190	96	\N
795	Ppkgl	Tthasfbjxle	1986-04-27	175	62	\N
796	Lnbpd	Czmcvxmxnsy	1984-02-14	199	60	\N
797	Jqfvt	Wsotbsusmkj	1995-03-23	210	93	\N
798	Euvdf	Lbbnelxndsg	1993-11-21	185	61	\N
799	Txaog	Qhbtshscqqn	1998-08-27	170	98	\N
800	Xcjjf	Mbkodoxcfxv	1989-05-23	215	77	\N
801	Cerxk	Znympwxcdnt	1997-11-09	200	64	\N
802	Cplpm	Wqeffcypkzh	1992-03-27	192	73	\N
803	Xprhr	Kdsvnucprmn	1998-10-26	173	87	\N
804	Zjpnr	Xsvaovmphkl	1983-08-23	202	72	\N
805	Jmuwd	Gyedpgmqerp	1981-09-19	182	96	\N
806	Hnmyf	Ojdpqxmsvmk	1987-06-26	183	72	\N
807	Iwixp	Bcjsoyduyby	1999-02-07	176	72	\N
808	Dckze	Mccxpluebpj	1986-12-11	188	77	\N
809	Elsxq	Hvynmpcncuo	1999-07-03	155	84	\N
810	Qjyjm	Lgfvywoqcuj	1998-05-12	208	63	\N
811	Frvcz	Xkbmcmyuwrx	1981-04-19	161	96	\N
812	Vekoh	Wupohfdwhsw	1998-01-23	186	67	\N
813	Hugvu	Ikeghqeaqfp	1981-02-26	207	96	\N
814	Bscfq	Xeexjczviip	1992-05-08	182	61	\N
815	Zghqm	Rgrudyirsoi	1985-03-10	165	61	\N
816	Ycvcx	Gheoycxuxfo	1988-03-15	170	81	\N
817	Rixmm	Rhhxduvvuch	1990-02-23	180	66	\N
818	Jqjdy	Edjlynzrcpp	1982-06-26	216	65	\N
819	Itfsh	Epluzvytscr	1995-09-11	208	64	\N
820	Kfofi	Slrmiskggze	1990-04-02	212	82	\N
821	Enlza	Qsddjvqcpvu	1990-06-09	172	73	\N
822	Yffwx	Evifyvanqei	1980-10-28	205	80	\N
823	Kqdlk	Ikzjoislynh	1988-04-15	151	87	\N
824	Wwjsd	Jzmmuhekmjk	1986-02-27	214	77	\N
825	Lczqr	Zligubqizlu	1986-04-15	217	70	\N
826	Visef	Lwgjuztglmo	1987-09-26	175	72	\N
827	Gvsbi	Ftsnfjtfndu	1981-10-04	206	97	\N
828	Barem	Xhgnvoihmps	1999-07-23	186	93	\N
829	Cuxxl	Vdesfgtxtjo	1995-02-25	158	88	\N
830	Buiax	Wtbgmexjeuk	1994-02-24	166	68	\N
831	Xmvhu	Nruikchsxnt	1987-07-20	213	100	\N
832	Vrrry	Jlhrvvhaymt	1992-08-07	163	70	\N
833	Upyvc	Dgetnxqyhdj	1983-06-03	188	94	\N
834	Wlfba	Xnfdfjgxfff	1991-07-01	167	88	\N
835	Tkhqd	Jfdogflbfgv	1993-11-02	202	96	\N
836	Elnhu	Otlaqtmopio	1997-11-19	207	93	\N
837	Xkcbp	Qxutlcbberu	1999-12-19	170	95	\N
838	Rrgob	Hvbxfbvzqqb	1998-07-04	186	71	\N
839	Nijrl	Hdrbbeinfwu	1999-01-14	210	93	\N
840	Vkwqc	Rnchithumwp	1992-08-01	155	94	\N
841	Oheky	Bkfiyqhkvih	1982-09-09	217	92	\N
842	Ovrdg	Grigypvdnjy	1994-06-19	160	84	\N
843	Cwaac	Gevwxiuaddd	1993-04-19	213	68	\N
844	Arnux	Yqfutiexaro	1986-03-22	178	95	\N
845	Skzwh	Oyejmnvmzcm	1996-11-09	209	63	\N
846	Fmhcj	Pevidtnimeb	1992-10-07	206	67	\N
847	Fqvec	Mqvdjiezwth	1993-01-03	201	79	\N
848	Mkgjl	Bscdjimyxpj	1985-02-12	201	68	\N
849	Mdmsr	Ypznwqfoldh	1988-02-03	213	66	\N
850	Wzifo	Ypqrlbioqov	1987-03-25	216	86	\N
851	Rqowv	Qwjtdrymklt	1992-09-08	183	70	\N
852	Jfbpp	Lxhpjofnmuy	1999-01-05	183	60	\N
853	Ovkvf	Nynxysxhvkt	1995-11-07	168	97	\N
854	Oqjlp	Pxtldhkjanc	1981-11-18	174	82	\N
855	Yunvr	Kuufjwndiuj	1988-10-07	178	86	\N
856	Kjniz	Tjlqtcbhepl	1995-07-13	189	70	\N
857	Flwrb	Titlfsfmuko	1981-02-05	155	95	\N
858	Yvbbr	Qlfjysavsur	1994-03-20	157	79	\N
859	Jdvir	Tslokbrxgle	1981-05-19	159	63	\N
860	Siikh	Fhvlveevucm	1980-11-11	180	88	\N
861	Vkwig	Nzeypljudnq	1981-09-13	196	85	\N
862	Idrsj	Juumcjowjrb	1995-12-08	211	77	\N
863	Hdtss	Efwsihuwrub	1981-05-19	186	93	\N
864	Mqbhf	Hiuycejpeok	1993-12-21	198	85	\N
865	Xykox	Qahkeobsdlz	1984-01-19	161	94	\N
866	Deyax	Vwxpscmfyns	1988-11-20	155	83	\N
867	Ehbvy	Hhlffdiysod	1980-11-08	174	99	\N
868	Muoyh	Ynprrxcjoof	1991-07-03	200	84	\N
869	Utrgh	Kdcsxkhzwrd	1986-04-15	195	64	\N
870	Dhksf	Xbokzdgozho	1995-11-22	152	87	\N
871	Ynnci	Yotghvpoboi	1997-11-04	209	87	\N
872	Afahy	Mluothpvjga	1995-06-16	185	94	\N
873	Nkruu	Cldgvkjlymg	1991-04-26	160	79	\N
874	Opjcl	Hfpdpchllfs	1981-05-02	162	73	\N
875	Iwwhq	Nmqxcpcroar	1991-11-25	203	76	\N
876	Wrzby	Mxlpxoumwec	1982-02-27	198	97	\N
877	Upppc	Mpfievwdadu	1991-10-25	194	75	\N
878	Cvubd	Vydgyljrxcp	1981-07-23	212	99	\N
879	Doruc	Ugovennukpg	1992-03-26	184	92	\N
880	Tmwli	Ehndugywszq	1981-11-02	175	89	\N
881	Fheop	Vwdxbbhckef	1996-04-23	188	65	\N
882	Wyknb	Kqmxmrrfkqo	1997-03-08	189	83	\N
883	Esdls	Lzidbqvbjfc	1994-08-14	199	82	\N
884	Czhki	Bydsvqoqxvk	1981-06-03	216	91	\N
885	Pgryo	Pcunkfrgiow	1988-07-20	158	63	\N
886	Lbegb	Omhupfavfbn	1992-02-10	170	80	\N
887	Agyjf	Xkoqjkexdud	1986-10-14	174	70	\N
888	Gsydi	Qdjmdfdyskp	1989-04-03	214	81	\N
889	Bnqkq	Szmdjwrufnb	1983-06-22	212	74	\N
890	Wkdge	Bpdzfgxgqyi	1991-01-06	219	97	\N
891	Nabyv	Jitfffmtgfq	1992-10-06	200	99	\N
892	Drciv	Nxqttlxpbcb	1985-11-25	184	75	\N
893	Isteg	Gfpyrwgbseo	1989-07-16	153	75	\N
894	Tkecg	Tvktodzepkc	1982-11-24	153	96	\N
895	Qxcmn	Dmmotecdpyb	1991-02-11	199	71	\N
896	Oxthf	Zfnigsxjjmh	1985-09-16	213	92	\N
897	Agbyp	Xgnpfkuuodn	1998-11-22	187	84	\N
898	Etkbd	Jhlppwjxnal	1991-06-19	176	90	\N
899	Butel	Ieagxnixroj	1995-06-09	209	64	\N
900	Elotn	Dipzhxppygy	1983-01-06	192	61	\N
901	Esmtt	Cctelydbwin	1996-09-26	171	94	\N
902	Rqrqe	Rnctpqvgusn	1982-03-27	163	77	\N
903	Szytp	Ehzqetynwqw	1981-02-26	153	61	\N
904	Vdwnu	Psbvsjnbudy	1982-11-04	189	66	\N
905	Nujxe	Kcebebxunmf	1992-09-14	173	92	\N
906	Cydof	Hzghkztfygj	1997-11-22	174	85	\N
907	Hsmwf	Gsnxngrowmz	1982-10-18	205	71	\N
908	Qbpis	Esfyhqwrzhl	1989-08-02	174	78	\N
909	Pnlnh	Lphimeqbypb	1988-03-06	197	80	\N
910	Xugnb	Eoehvqvygnc	1993-01-06	179	77	\N
911	Hkmva	Fxpwefjwues	1999-03-06	189	61	\N
912	Gsriy	Oxktriizogi	1994-05-15	213	97	\N
913	Wxhbk	Fvtdmdcsxpk	1992-09-03	177	97	\N
914	Rqdrd	Ipbtnpucvli	1996-05-25	217	91	\N
915	Rqjzq	Jduaesjlmbg	1993-07-25	170	73	\N
916	Ivxoo	Rgtcoxdffeq	1984-08-24	152	73	\N
917	Hqlub	Bufecramkco	1985-07-22	173	66	\N
918	Drmsq	Bfoelmymgue	1986-06-27	189	75	\N
919	Tcoud	Kckcmzmkwtq	1987-01-22	169	90	\N
920	Mnznz	Ytqovmpmubg	1985-03-13	166	71	\N
921	Sgtoe	Egeojstygtq	1991-03-14	157	88	\N
922	Pvoqs	Lnvwkjvxrfz	1986-03-21	160	79	\N
923	Xeykk	Ghoxhaiydrm	1990-07-04	174	71	\N
924	Prcvk	Ncjrbqyqkon	1984-02-24	156	89	\N
925	Ubbwj	Toblxgfxesk	1983-07-04	202	80	\N
926	Ickzc	Xspiulzdouv	1988-07-08	169	60	\N
927	Omevy	Ccmgetlyafo	1991-08-19	200	93	\N
928	Ydnqo	Yzckecgyurb	1993-09-18	160	79	\N
929	Dluke	Utarefsctog	1984-02-28	201	97	\N
930	Nwsxq	Jxkpmurkunr	1993-06-10	157	85	\N
931	Oxyeq	Dyduwzhdtpm	1995-04-04	155	83	\N
932	Tnbte	Whhqoqpjcow	1985-06-13	166	89	\N
933	Ieptz	Tfmfitzcfqi	1995-08-05	164	83	\N
934	Vfejy	Nzosvhvoiuf	1981-01-09	162	89	\N
935	Zqend	Ysxufyksqnh	1991-05-15	211	73	\N
936	Cpiuz	Pwpibmmxcld	1992-09-26	190	82	\N
937	Dmdfe	Nocqfzjjhpr	1990-08-02	175	95	\N
938	Hojck	Exxxkugfiiv	1989-12-12	177	65	\N
939	Gtypv	Ggmekiswrlw	1986-09-12	185	82	\N
940	Xkgkm	Nqdzfoymovr	1984-11-16	196	95	\N
941	Tsbii	Egsrmxgjcgh	1995-10-13	172	61	\N
942	Fleqs	Hbvahydljod	1994-10-15	164	93	\N
943	Otjef	Ntmgavtgvwb	1987-11-11	165	69	\N
944	Iwmhh	Vfhymqnomxx	1984-11-23	183	63	\N
945	Hpcvy	Nfiphbskvby	1996-11-27	169	66	\N
946	Kjmra	Rbcbecdqfni	1992-07-17	162	78	\N
947	Ougcm	Ylmuipqdxqe	1982-02-19	175	80	\N
948	Hkcpn	Qqduxiebnil	1986-01-04	154	89	\N
949	Wqxsd	Jtkxvmykwpb	1998-03-23	216	92	\N
950	Smqti	Usdwunkksfc	1987-11-09	196	77	\N
951	Vikfe	Nzsgmhfrucf	1998-09-16	170	82	\N
952	Abajn	Qsxkktceszb	1984-06-14	192	63	\N
953	Mnyso	Xmsumwhodjx	1994-09-17	204	83	\N
954	Tlpei	Okjpwwgdatp	1994-07-18	184	91	\N
955	Tzyxo	Bofibzdjggt	1982-03-14	199	85	\N
956	Qwdpj	Eeffxwwqsrg	1985-12-11	155	92	\N
957	Wxuvu	Ctfnoykbwhu	1988-10-11	175	97	\N
958	Ymgel	Ceevjpvnlbj	1987-03-09	181	73	\N
959	Dhbfu	Yuqhgfobirs	1999-05-10	218	92	\N
960	Dfnnr	Yvsbzbjnkkt	1983-04-05	176	83	\N
961	Nzlvg	Bbchfsyzetd	1980-05-19	153	65	\N
962	Mchnk	Wjhdhcpydqr	1998-04-11	152	78	\N
963	Tylvc	Yooiprgmfte	1988-07-14	160	62	\N
964	Sngse	Cyjshdysqug	1996-02-17	163	62	\N
965	Uaccd	Bvqoxdtxlxf	1990-11-09	212	82	\N
966	Whsad	Ftkyicwrqbn	1995-08-22	174	91	\N
967	Bguft	Dkgligmdlux	1984-08-17	212	81	\N
968	Rphyx	Brywmmgbmjp	1986-08-21	171	86	\N
969	Kujqx	Yhjxqtmtbby	1998-06-18	199	74	\N
970	Plims	Mcawtjgssrp	1997-03-12	191	90	\N
971	Uyxur	Aaezihexnxg	1991-07-16	200	73	\N
972	Cyobr	Acjhvmpiyfi	1993-06-12	201	73	\N
973	Qdbme	Ppobzllmsqy	1995-06-12	188	84	\N
974	Pmfnc	Ksuvubxwwti	1996-08-18	180	70	\N
975	Phoyy	Yfpolmkopuk	1997-05-17	187	66	\N
976	Twnxk	Hfjibtjawre	1994-06-20	168	73	\N
977	Klmgk	Ogmlbvvhjij	1993-04-25	163	98	\N
978	Vqwlk	Kyremknklme	1988-03-09	161	64	\N
979	Cboai	Mqqqfjreics	1997-06-07	152	67	\N
980	Nepkc	Ckuuwxedhfb	1987-11-22	186	99	\N
981	Utehq	Clovhkhymbh	1991-05-03	171	80	\N
982	Dnvxm	Qgqohboseef	1987-10-13	213	83	\N
983	Hifiw	Dcshkxjfjpc	1993-06-13	176	69	\N
984	Elefw	Pjhbigsfars	1984-09-14	163	66	\N
985	Qmxve	Rfgmwrffkhp	1986-06-03	187	68	\N
986	Gmrru	Qlhfnxufyig	1984-02-20	170	69	\N
987	Npwho	Xwnpkasbkos	1986-02-02	207	87	\N
988	Jbmvk	Reowjvfxbwp	1995-08-18	175	93	\N
989	Trrqg	Diwjimsuzeq	1998-12-10	180	85	\N
990	Cgyuu	Trrexsucbgb	1987-01-21	152	89	\N
991	Dmohe	Ygfupnvtvgw	1989-02-03	154	73	\N
992	Vmmrs	Mmvxgptegxp	1994-06-25	178	76	\N
993	Ofgqv	Ndjofqyebth	1989-02-27	167	78	\N
994	Sxmtm	Kztujlffotw	1990-05-25	170	64	\N
995	Pwnbs	Dckgsimevju	1988-10-24	171	87	\N
996	Zjslj	Hifkizzxjrb	1997-11-22	186	70	\N
997	Mdvgn	Fevkrscdtbr	1988-02-14	175	62	\N
998	Bkttw	Ediwienwpwu	1996-08-26	200	94	\N
999	Mrbaz	Jkvkrxomwdm	1987-06-19	151	84	\N
1000	Jcney	Athbqctpnnl	1984-02-27	151	82	\N
1001	Lremu	Cwxkxaslkhf	1991-04-07	185	99	\N
1002	Wxhhe	Pqhgktovpom	1984-02-22	173	76	\N
1003	Kleak	Nwkgtyvccvy	1995-08-20	210	86	\N
1004	Hvclm	Ktccqhrhqby	1994-04-01	152	82	\N
1005	Mdcty	Oudcnyppueh	1995-10-24	176	72	\N
1006	Jjluv	Qxtxqoqtnxk	1986-02-04	169	84	\N
1007	Ubwvv	Nxdngflxvqf	1995-07-24	188	99	\N
1008	Nvlfq	Vdyrkstlwxm	1996-04-19	211	75	\N
1009	Thdhw	Qopsltxefyt	1993-11-07	200	98	\N
1010	Etclx	Byenplloecs	1989-05-20	187	95	\N
1011	Umvun	Vlpmjcwthqj	1995-03-20	158	91	\N
1012	Ktnuc	Hxrqbiomgrv	1990-06-18	204	83	\N
1013	Fsiwy	Elsutkhoiob	1981-08-28	194	65	\N
1014	Nubor	Jeugeozvmnx	1992-12-12	162	62	\N
1015	Vlupy	Hshxwpvwtnr	1995-11-12	153	84	\N
1	Ivan	Ivanov	1999-01-01	170	70	1
2	Oleg	Petrov	1996-03-10	180	90	1
3	Petr	Sidorov	1995-04-11	203	85	1
4	Leopold	Nichaev	1988-05-12	160	63	1
5	Nikita	Kovrov	1989-11-11	171	71	1
6	Anton	Vlasov	2000-11-02	165	73	1
7	Ivan	Lopirov	1991-04-01	200	85	1
8	Sergey	Ivanov	1993-03-03	172	87	1
9	Anton	Radkov	1994-10-11	183	90	1
10	Semen	Petrov	1995-11-10	189	94	1
19	Gumek	Zutgxyqixoc	1980-10-06	183	73	2
20	Hbnkc	Levxkvekxdp	1984-04-11	167	83	2
30	Rukoo	Zqbalvntpro	1992-10-24	177	97	3
50	Kkrdb	Ysxrfmtpjsi	1991-08-08	188	93	5
70	Torgu	Rlxcuuffuxs	1980-04-05	158	64	7
90	Ujkhe	Gqzmmyqbecu	1985-10-15	188	90	9
100	Lhmjn	Vwxjrarhmzv	1995-05-18	218	74	10
\.


--
-- Data for Name: match; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.match (id_match, match_h) FROM stdin;
1	h
2	v
3	v
4	h
5	h
6	h
7	v
8	v
9	v
10	v
\.


--
-- Data for Name: nagrada_igrok; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nagrada_igrok (id, nagrada) FROM stdin;
1	{"Gorod 1place","Oblast 3place","Gorod 2place"}
3	{"Gorod 1place","Oblast 1place"}
4	{"Oblast 3place"}
5	{"Oblast 1place","Mir 3place"}
5	{"Oblast 1place","Mir 3place"}
2	{"Mir 3place","Oblast 1place","Gorod 1place"}
\.


--
-- Data for Name: play; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.play (id_play, res_k1, res_k2, id_k1, id_k2, id_bilet, id_match, date_play) FROM stdin;
1	1	3	1	2	1	1	2019-02-01
2	2	3	3	4	2	2	2019-03-02
3	3	0	5	6	3	3	2019-04-03
4	2	2	7	8	4	4	2019-05-04
5	3	1	9	10	5	5	2019-06-05
6	3	0	1	3	6	6	2019-07-06
7	2	2	2	4	7	7	2019-08-07
8	1	3	5	7	8	8	2019-09-08
9	3	2	6	8	9	9	2019-10-09
10	2	3	9	1	10	10	2019-11-10
\.


--
-- Data for Name: play_igrok; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.play_igrok (id_igrok, goal, goal_peredach, shtraf_time, play_time) FROM stdin;
1	2	5	00:30:13	01:35:00
2	7	14	00:15:20	01:50:00
3	10	17	00:20:30	00:55:00
4	8	21	00:20:30	03:35:00
5	3	11	00:20:30	00:55:00
6	0	4	00:05:00	01:35:00
7	11	22	00:15:20	03:35:00
8	10	17	00:05:00	01:35:00
9	9	13	00:30:13	01:35:00
10	8	16	00:10:30	01:05:00
11	1	2	00:25:30	01:05:00
12	10	3	00:04:47	02:30:43
13	14	3	00:28:14	02:05:15
14	14	2	00:00:21	03:28:15
15	1	22	00:12:35	01:02:14
16	0	3	00:20:45	01:48:44
17	5	10	00:08:15	02:56:56
18	6	23	00:11:42	03:41:35
19	13	13	00:41:37	00:15:54
20	2	24	00:34:31	01:09:26
21	6	17	00:01:29	00:27:25
22	2	15	00:14:05	03:54:40
23	5	10	00:21:42	01:35:58
24	10	10	00:08:24	01:05:08
25	6	7	00:22:37	02:48:50
26	15	15	00:21:20	02:15:10
27	9	18	00:09:40	02:21:05
28	14	13	00:34:46	00:59:35
29	12	8	00:14:46	01:03:48
30	9	13	00:15:39	03:38:03
31	12	16	00:36:12	02:49:26
32	8	4	00:15:28	01:01:38
33	10	10	00:02:57	01:45:05
34	5	17	00:35:10	03:24:30
35	5	2	00:35:16	02:02:44
36	1	9	00:27:57	02:34:40
37	13	1	00:23:13	01:32:42
38	9	23	00:32:12	01:52:27
39	1	13	00:29:55	00:05:03
40	15	21	00:42:17	02:13:23
41	3	2	00:24:37	00:02:22
42	3	4	00:45:44	00:34:02
43	14	10	00:25:33	01:04:46
44	11	3	00:17:12	01:31:47
45	3	18	00:29:18	02:35:31
46	14	11	00:41:49	03:00:13
47	15	3	00:23:35	01:57:42
48	13	23	00:34:15	03:09:24
49	14	3	00:15:43	03:57:13
50	14	2	00:37:20	01:12:09
51	8	24	00:35:27	00:58:27
52	9	4	00:33:00	02:35:10
53	4	24	00:19:57	01:49:56
54	0	16	00:34:33	00:14:44
55	12	17	00:38:22	02:42:35
56	2	11	00:17:18	03:18:10
57	12	21	00:01:22	01:13:44
58	5	5	00:20:11	01:09:38
59	10	17	00:40:48	00:02:16
60	0	16	00:03:58	02:53:28
61	3	18	00:21:46	01:47:07
62	3	6	00:33:08	02:53:33
63	11	14	00:13:18	01:02:50
64	7	10	00:38:08	03:10:58
\.


--
-- Data for Name: population_club; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.population_club (id_pop, name_club, count) FROM stdin;
1	Alfa	2980
2	Novosibirsk	1678
3	Kemer	1488
4	MoscowCity	1186
5	Belga	1689
6	Omsk	1598
7	KAZAK	1359
8	Solnechny	1268
9	Kirov	1309
10	Komsol	309
\.


--
-- Data for Name: price_igrok; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_igrok (id_igrok, oklad, premia, shtraf) FROM stdin;
1	\N	\N	\N
1	10000	7000	3000
2	15000	21000	1500
3	15000	27000	2000
4	15000	29000	2000
5	15000	14000	2000
6	10000	4000	500
7	15000	33000	1500
8	20000	27000	500
9	20000	22000	3000
10	10000	24000	1000
\.


--
-- Data for Name: raspisanie_igrok; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.raspisanie_igrok (id, raspisanie) FROM stdin;
1	{{1,0,2,0,0,1,2},{1,2,0,1,2,0,0},{0,1,2,1,2,0,2},{0,0,0,1,2,2,2}}
2	{{0,1,2,0,0,1,2},{1,2,0,1,2,0,0},{1,2,2,1,0,0,0},{0,2,0,1,2,1,2}}
3	{{1,0,1,0,2,1,2},{1,2,0,1,2,1,0},{0,1,2,1,2,0,2},{1,0,2,1,2,1,2}}
4	{{1,0,2,0,0,1,2},{1,1,0,1,2,2,0},{0,2,2,1,1,0,0},{0,2,0,1,1,1,2}}
6	{{1,0,2,1,0,1,2},{1,2,1,1,2,0,0},{1,1,2,1,2,0,2},{0,0,0,1,2,2,2}}
5	{{1,2,2,0,0,2,2},{2,1,2,0,0,0,1},{1,0,1,2,2,1,0},{1,1,1,0,2,0,0}}
\.


--
-- Data for Name: reiting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reiting (id, name, goal, goal_p, date_play) FROM stdin;
1	Ivan	2	5	2019-02-01
2	Oleg	7	14	2019-02-01
3	Petr	10	17	2019-03-02
4	Leopold	8	21	2019-03-02
5	Nikita	3	11	2019-04-03
6	Anton	0	4	2019-04-03
7	Ivan	11	22	2019-05-04
8	Sergey	10	17	2019-05-04
\.


--
-- Data for Name: stadion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stadion (id, kolvo, cost, date_play, match) FROM stdin;
1	1000	699	2019-02-01	h
3	900	799	2019-04-03	v
6	980	699	2019-07-06	h
7	678	750	2019-08-07	v
8	789	570	2019-09-08	v
9	698	850	2019-10-09	v
10	1000	500	2019-11-10	v
\.


--
-- Name: bilet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY public.bilet
    ADD CONSTRAINT bilet_pkey PRIMARY KEY (id_club);


--
-- Name: club_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_pkey PRIMARY KEY (id_club);


--
-- Name: effective_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY public.effective
    ADD CONSTRAINT effective_pkey PRIMARY KEY (id);


--
-- Name: info_igrok_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY public.info_igrok
    ADD CONSTRAINT info_igrok_pkey PRIMARY KEY (id_igrok);


--
-- Name: match_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY public.match
    ADD CONSTRAINT match_pkey PRIMARY KEY (id_match);


--
-- Name: play_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY public.play
    ADD CONSTRAINT play_pkey PRIMARY KEY (id_play);


--
-- Name: population_club_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY public.population_club
    ADD CONSTRAINT population_club_pkey PRIMARY KEY (id_pop);


--
-- Name: reiting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY public.reiting
    ADD CONSTRAINT reiting_pkey PRIMARY KEY (id);


--
-- Name: stadion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace:
--

ALTER TABLE ONLY public.stadion
    ADD CONSTRAINT stadion_pkey PRIMARY KEY (id);


--
-- Name: characteristion_id_igrok_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characteristion
    ADD CONSTRAINT characteristion_id_igrok_fkey FOREIGN KEY (id_igrok) REFERENCES public.info_igrok(id_igrok);


--
-- Name: info_igrok_id_club_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.info_igrok
    ADD CONSTRAINT info_igrok_id_club_fkey FOREIGN KEY (id_club) REFERENCES public.club(id_club);


--
-- Name: nagrada_igrok_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nagrada_igrok
    ADD CONSTRAINT nagrada_igrok_id_fkey FOREIGN KEY (id) REFERENCES public.info_igrok(id_igrok);


--
-- Name: play_id_bilet_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.play
    ADD CONSTRAINT play_id_bilet_fkey FOREIGN KEY (id_bilet) REFERENCES public.bilet(id_club);


--
-- Name: play_id_k1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.play
    ADD CONSTRAINT play_id_k1_fkey FOREIGN KEY (id_k1) REFERENCES public.club(id_club);


--
-- Name: play_id_k2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.play
    ADD CONSTRAINT play_id_k2_fkey FOREIGN KEY (id_k2) REFERENCES public.club(id_club);


--
-- Name: play_id_match_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.play
    ADD CONSTRAINT play_id_match_fkey FOREIGN KEY (id_match) REFERENCES public.match(id_match);


--
-- Name: play_igrok_id_igrok_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.play_igrok
    ADD CONSTRAINT play_igrok_id_igrok_fkey FOREIGN KEY (id_igrok) REFERENCES public.info_igrok(id_igrok);


--
-- Name: price_igrok_id_igrok_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_igrok
    ADD CONSTRAINT price_igrok_id_igrok_fkey FOREIGN KEY (id_igrok) REFERENCES public.info_igrok(id_igrok);


--
-- Name: raspisanie_igrok_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raspisanie_igrok
    ADD CONSTRAINT raspisanie_igrok_id_fkey FOREIGN KEY (id) REFERENCES public.info_igrok(id_igrok);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;

-- Проверка 1
select zpstadion_max();
select * from stadion;

-- Проверка 2
select zpstadion_avg();
select * from stadion;

-- Проверка 3
select zpstadion_min();
select * from stadion;

-- Проверка 4
select population();
select * from population_club;

-- Проверка 5
select reiting('01-02-2019','06-06-2019');
select * from reiting;

-- Проверка 6
select effective();
select * from effective;

--
-- PostgreSQL database dump complete
--

