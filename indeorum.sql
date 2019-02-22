/*
Navicat PGSQL Data Transfer

Source Server         : desenvolvimento
Source Server Version : 90204
Source Host           : localhost:5432
Source Database       : indeorum
Source Schema         : public

Target Server Type    : PGSQL
Target Server Version : 90204
File Encoding         : 65001

Date: 2019-02-21 21:22:04
*/


-- ----------------------------
-- Sequence structure for article_types_id_seq
-- ----------------------------
DROP SEQUENCE "public"."article_types_id_seq";
CREATE SEQUENCE "public"."article_types_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 113854
 CACHE 1;
SELECT setval('"public"."article_types_id_seq"', 113854, true);

-- ----------------------------
-- Sequence structure for authors_id_seq
-- ----------------------------
DROP SEQUENCE "public"."authors_id_seq";
CREATE SEQUENCE "public"."authors_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 32187
 CACHE 1;
SELECT setval('"public"."authors_id_seq"', 32187, true);

-- ----------------------------
-- Sequence structure for institution_id_seq
-- ----------------------------
DROP SEQUENCE "public"."institution_id_seq";
CREATE SEQUENCE "public"."institution_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 90776
 CACHE 1;
SELECT setval('"public"."institution_id_seq"', 90776, true);

-- ----------------------------
-- Sequence structure for jobs_id_seq
-- ----------------------------
DROP SEQUENCE "public"."jobs_id_seq";
CREATE SEQUENCE "public"."jobs_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 642
 CACHE 1;
SELECT setval('"public"."jobs_id_seq"', 642, true);

-- ----------------------------
-- Sequence structure for producoes_id_seq
-- ----------------------------
DROP SEQUENCE "public"."producoes_id_seq";
CREATE SEQUENCE "public"."producoes_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 120299
 CACHE 1;
SELECT setval('"public"."producoes_id_seq"', 120299, true);

-- ----------------------------
-- Sequence structure for registros_id_seq
-- ----------------------------
DROP SEQUENCE "public"."registros_id_seq";
CREATE SEQUENCE "public"."registros_id_seq"
 INCREMENT 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 START 944933
 CACHE 1;
SELECT setval('"public"."registros_id_seq"', 944933, true);

-- ----------------------------
-- Table structure for imp_registros
-- ----------------------------
DROP TABLE IF EXISTS "public"."imp_registros";
CREATE TABLE "public"."imp_registros" (
"id" serial NOT NULL,
"name" varchar(200) COLLATE "default",
"jobs" varchar(100) COLLATE "default",
"institution" varchar(100) COLLATE "default",
"publication_date" date,
"article_type" varchar(100) COLLATE "default",
"start_date" date,
"end_date" date
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for instituicoes
-- ----------------------------
DROP TABLE IF EXISTS "public"."instituicoes";
CREATE TABLE "public"."instituicoes" (
"id" serial NOT NULL,
"descricao" varchar(150) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for pesquisadores
-- ----------------------------
DROP TABLE IF EXISTS "public"."pesquisadores";
CREATE TABLE "public"."pesquisadores" (
"id" serial NOT NULL,
"nome" varchar(150) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for producoes
-- ----------------------------
DROP TABLE IF EXISTS "public"."producoes";
CREATE TABLE "public"."producoes" (
"id" serial NOT NULL,
"pesquisador_id" int4 NOT NULL,
"trabalho_id" int4 NOT NULL,
"instituicao_id" int4,
"tipo_artigo_id" int4,
"data_inicial" date,
"data_final" date,
"data_publicacao" date
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for tipos_artigos
-- ----------------------------
DROP TABLE IF EXISTS "public"."tipos_artigos";
CREATE TABLE "public"."tipos_artigos" (
"id" serial NOT NULL,
"descricao" varchar(150) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Table structure for trabalhos
-- ----------------------------
DROP TABLE IF EXISTS "public"."trabalhos";
CREATE TABLE "public"."trabalhos" (
"id" serial NOT NULL,
"descricao" varchar(150) COLLATE "default"
)
WITH (OIDS=FALSE)

;

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------
ALTER SEQUENCE "public"."article_types_id_seq" OWNED BY "tipos_artigos"."id";
ALTER SEQUENCE "public"."authors_id_seq" OWNED BY "pesquisadores"."id";
ALTER SEQUENCE "public"."institution_id_seq" OWNED BY "instituicoes"."id";
ALTER SEQUENCE "public"."jobs_id_seq" OWNED BY "trabalhos"."id";
ALTER SEQUENCE "public"."producoes_id_seq" OWNED BY "producoes"."id";
ALTER SEQUENCE "public"."registros_id_seq" OWNED BY "imp_registros"."id";

-- ----------------------------
-- Primary Key structure for table imp_registros
-- ----------------------------
ALTER TABLE "public"."imp_registros" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table instituicoes
-- ----------------------------
ALTER TABLE "public"."instituicoes" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table pesquisadores
-- ----------------------------
ALTER TABLE "public"."pesquisadores" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table producoes
-- ----------------------------
ALTER TABLE "public"."producoes" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table tipos_artigos
-- ----------------------------
ALTER TABLE "public"."tipos_artigos" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table trabalhos
-- ----------------------------
ALTER TABLE "public"."trabalhos" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Key structure for table "public"."producoes"
-- ----------------------------
ALTER TABLE "public"."producoes" ADD FOREIGN KEY ("instituicao_id") REFERENCES "public"."instituicoes" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."producoes" ADD FOREIGN KEY ("trabalho_id") REFERENCES "public"."trabalhos" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."producoes" ADD FOREIGN KEY ("pesquisador_id") REFERENCES "public"."pesquisadores" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."producoes" ADD FOREIGN KEY ("tipo_artigo_id") REFERENCES "public"."tipos_artigos" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
