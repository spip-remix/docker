-- MySQL dump 10.13  Distrib 5.7.32, for Linux (x86_64)
--
-- Host: localhost    Database: spip
-- ------------------------------------------------------
-- Server version	5.7.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `spip_articles`
--

DROP TABLE IF EXISTS `spip_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_articles` (
  `id_article` bigint(21) NOT NULL AUTO_INCREMENT,
  `surtitre` text NOT NULL,
  `titre` text NOT NULL,
  `soustitre` text NOT NULL,
  `id_rubrique` bigint(21) NOT NULL DEFAULT '0',
  `descriptif` text NOT NULL,
  `chapo` mediumtext NOT NULL,
  `texte` longtext NOT NULL,
  `ps` mediumtext NOT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `statut` varchar(10) NOT NULL DEFAULT '0',
  `id_secteur` bigint(21) NOT NULL DEFAULT '0',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `export` varchar(10) DEFAULT 'oui',
  `date_redac` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `visites` int(11) NOT NULL DEFAULT '0',
  `referers` int(11) NOT NULL DEFAULT '0',
  `popularite` double NOT NULL DEFAULT '0',
  `accepter_forum` char(3) NOT NULL DEFAULT '',
  `date_modif` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lang` varchar(10) NOT NULL DEFAULT '',
  `langue_choisie` varchar(3) DEFAULT 'non',
  `id_trad` bigint(21) NOT NULL DEFAULT '0',
  `nom_site` tinytext NOT NULL,
  `url_site` text NOT NULL,
  `virtuel` text NOT NULL,
  PRIMARY KEY (`id_article`),
  KEY `id_rubrique` (`id_rubrique`),
  KEY `id_secteur` (`id_secteur`),
  KEY `id_trad` (`id_trad`),
  KEY `lang` (`lang`),
  KEY `statut` (`statut`,`date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_auteurs`
--

DROP TABLE IF EXISTS `spip_auteurs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_auteurs` (
  `id_auteur` bigint(21) NOT NULL AUTO_INCREMENT,
  `nom` text NOT NULL,
  `bio` text NOT NULL,
  `email` tinytext NOT NULL,
  `nom_site` tinytext NOT NULL,
  `url_site` text NOT NULL,
  `login` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `pass` tinytext NOT NULL,
  `low_sec` tinytext NOT NULL,
  `statut` varchar(255) NOT NULL DEFAULT '0',
  `webmestre` varchar(3) NOT NULL DEFAULT 'non',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pgp` text NOT NULL,
  `htpass` tinytext NOT NULL,
  `en_ligne` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `alea_actuel` tinytext,
  `alea_futur` tinytext,
  `prefs` text,
  `cookie_oubli` tinytext,
  `source` varchar(10) NOT NULL DEFAULT 'spip',
  `lang` varchar(10) NOT NULL DEFAULT '',
  `imessage` varchar(3) DEFAULT NULL,
  `messagerie` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id_auteur`),
  KEY `login` (`login`),
  KEY `statut` (`statut`),
  KEY `en_ligne` (`en_ligne`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_auteurs_liens`
--

DROP TABLE IF EXISTS `spip_auteurs_liens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_auteurs_liens` (
  `id_auteur` bigint(21) NOT NULL DEFAULT '0',
  `id_objet` bigint(21) NOT NULL DEFAULT '0',
  `objet` varchar(25) NOT NULL DEFAULT '',
  `vu` varchar(6) NOT NULL DEFAULT 'non',
  PRIMARY KEY (`id_auteur`,`id_objet`,`objet`),
  KEY `id_auteur` (`id_auteur`),
  KEY `id_objet` (`id_objet`),
  KEY `objet` (`objet`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_breves`
--

DROP TABLE IF EXISTS `spip_breves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_breves` (
  `id_breve` bigint(21) NOT NULL AUTO_INCREMENT,
  `date_heure` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `titre` text NOT NULL,
  `texte` longtext NOT NULL,
  `lien_titre` text NOT NULL,
  `lien_url` text NOT NULL,
  `statut` varchar(6) NOT NULL DEFAULT '0',
  `id_rubrique` bigint(21) NOT NULL DEFAULT '0',
  `lang` varchar(10) NOT NULL DEFAULT '',
  `langue_choisie` varchar(3) DEFAULT 'non',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_breve`),
  KEY `id_rubrique` (`id_rubrique`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_depots`
--

DROP TABLE IF EXISTS `spip_depots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_depots` (
  `id_depot` bigint(21) NOT NULL AUTO_INCREMENT,
  `titre` text NOT NULL,
  `descriptif` text NOT NULL,
  `type` varchar(10) NOT NULL DEFAULT '',
  `url_serveur` varchar(255) NOT NULL DEFAULT '',
  `url_brouteur` varchar(255) NOT NULL DEFAULT '',
  `url_archives` varchar(255) NOT NULL DEFAULT '',
  `url_commits` varchar(255) NOT NULL DEFAULT '',
  `xml_paquets` varchar(255) NOT NULL DEFAULT '',
  `sha_paquets` varchar(40) NOT NULL DEFAULT '',
  `nbr_paquets` int(11) NOT NULL DEFAULT '0',
  `nbr_plugins` int(11) NOT NULL DEFAULT '0',
  `nbr_autres` int(11) NOT NULL DEFAULT '0',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_depot`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_depots_plugins`
--

DROP TABLE IF EXISTS `spip_depots_plugins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_depots_plugins` (
  `id_depot` bigint(21) NOT NULL,
  `id_plugin` bigint(21) NOT NULL,
  PRIMARY KEY (`id_depot`,`id_plugin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_documents`
--

DROP TABLE IF EXISTS `spip_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_documents` (
  `id_document` bigint(21) NOT NULL AUTO_INCREMENT,
  `id_vignette` bigint(21) NOT NULL DEFAULT '0',
  `extension` varchar(10) NOT NULL DEFAULT '',
  `titre` text NOT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `descriptif` text NOT NULL,
  `fichier` text NOT NULL,
  `taille` bigint(20) DEFAULT NULL,
  `largeur` int(11) DEFAULT NULL,
  `hauteur` int(11) DEFAULT NULL,
  `duree` int(11) DEFAULT NULL,
  `media` varchar(10) NOT NULL DEFAULT 'file',
  `mode` varchar(10) NOT NULL DEFAULT 'document',
  `distant` varchar(3) DEFAULT 'non',
  `statut` varchar(10) NOT NULL DEFAULT '0',
  `credits` text NOT NULL,
  `date_publication` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `brise` tinyint(4) DEFAULT '0',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_document`),
  KEY `id_vignette` (`id_vignette`),
  KEY `mode` (`mode`),
  KEY `extension` (`extension`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_documents_liens`
--

DROP TABLE IF EXISTS `spip_documents_liens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_documents_liens` (
  `id_document` bigint(21) NOT NULL DEFAULT '0',
  `id_objet` bigint(21) NOT NULL DEFAULT '0',
  `objet` varchar(25) NOT NULL DEFAULT '',
  `vu` enum('non','oui') NOT NULL DEFAULT 'non',
  `rang_lien` int(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_document`,`id_objet`,`objet`),
  KEY `id_document` (`id_document`),
  KEY `id_objet` (`id_objet`),
  KEY `objet` (`objet`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_forum`
--

DROP TABLE IF EXISTS `spip_forum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_forum` (
  `id_forum` bigint(21) NOT NULL AUTO_INCREMENT,
  `id_objet` bigint(21) NOT NULL DEFAULT '0',
  `objet` varchar(25) NOT NULL DEFAULT '',
  `id_parent` bigint(21) NOT NULL DEFAULT '0',
  `id_thread` bigint(21) NOT NULL DEFAULT '0',
  `date_heure` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_thread` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `titre` text NOT NULL,
  `texte` mediumtext NOT NULL,
  `auteur` text NOT NULL,
  `email_auteur` text NOT NULL,
  `nom_site` text NOT NULL,
  `url_site` text NOT NULL,
  `statut` varchar(8) NOT NULL DEFAULT '0',
  `ip` varchar(40) NOT NULL DEFAULT '',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_auteur` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_forum`),
  KEY `id_auteur` (`id_auteur`),
  KEY `id_parent` (`id_parent`),
  KEY `id_thread` (`id_thread`),
  KEY `optimal` (`statut`,`id_parent`,`id_objet`,`objet`,`date_heure`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_groupes_mots`
--

DROP TABLE IF EXISTS `spip_groupes_mots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_groupes_mots` (
  `id_groupe` bigint(21) NOT NULL AUTO_INCREMENT,
  `titre` text NOT NULL,
  `descriptif` text NOT NULL,
  `texte` longtext NOT NULL,
  `unseul` varchar(3) NOT NULL DEFAULT '',
  `obligatoire` varchar(3) NOT NULL DEFAULT '',
  `tables_liees` text NOT NULL,
  `minirezo` varchar(3) NOT NULL DEFAULT '',
  `comite` varchar(3) NOT NULL DEFAULT '',
  `forum` varchar(3) NOT NULL DEFAULT '',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_groupe`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_jobs`
--

DROP TABLE IF EXISTS `spip_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_jobs` (
  `id_job` bigint(21) NOT NULL AUTO_INCREMENT,
  `descriptif` text NOT NULL,
  `fonction` varchar(255) NOT NULL,
  `args` longblob NOT NULL,
  `md5args` char(32) NOT NULL DEFAULT '',
  `inclure` varchar(255) NOT NULL,
  `priorite` smallint(6) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_job`),
  KEY `date` (`date`),
  KEY `status` (`status`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_jobs_liens`
--

DROP TABLE IF EXISTS `spip_jobs_liens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_jobs_liens` (
  `id_job` bigint(21) NOT NULL DEFAULT '0',
  `id_objet` bigint(21) NOT NULL DEFAULT '0',
  `objet` varchar(25) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_job`,`id_objet`,`objet`),
  KEY `id_job` (`id_job`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_messages`
--

DROP TABLE IF EXISTS `spip_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_messages` (
  `id_message` bigint(21) NOT NULL AUTO_INCREMENT,
  `titre` text NOT NULL,
  `texte` longtext NOT NULL,
  `type` varchar(6) NOT NULL DEFAULT '',
  `date_heure` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_fin` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `rv` varchar(3) NOT NULL DEFAULT '',
  `statut` varchar(6) NOT NULL DEFAULT '0',
  `id_auteur` bigint(21) NOT NULL DEFAULT '0',
  `destinataires` text NOT NULL,
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_message`),
  KEY `id_auteur` (`id_auteur`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_meta`
--

DROP TABLE IF EXISTS `spip_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_meta` (
  `nom` varchar(255) NOT NULL,
  `valeur` text,
  `impt` enum('non','oui') NOT NULL DEFAULT 'oui',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`nom`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_mots`
--

DROP TABLE IF EXISTS `spip_mots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_mots` (
  `id_mot` bigint(21) NOT NULL AUTO_INCREMENT,
  `titre` text NOT NULL,
  `descriptif` text NOT NULL,
  `texte` longtext NOT NULL,
  `id_groupe` bigint(21) NOT NULL DEFAULT '0',
  `type` text NOT NULL,
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_mot`),
  KEY `id_groupe` (`id_groupe`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_mots_liens`
--

DROP TABLE IF EXISTS `spip_mots_liens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_mots_liens` (
  `id_mot` bigint(21) NOT NULL DEFAULT '0',
  `id_objet` bigint(21) NOT NULL DEFAULT '0',
  `objet` varchar(25) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_mot`,`id_objet`,`objet`),
  KEY `id_mot` (`id_mot`),
  KEY `id_objet` (`id_objet`),
  KEY `objet` (`objet`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_paquets`
--

DROP TABLE IF EXISTS `spip_paquets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_paquets` (
  `id_paquet` bigint(21) NOT NULL AUTO_INCREMENT,
  `id_plugin` bigint(21) NOT NULL,
  `prefixe` varchar(30) NOT NULL DEFAULT '',
  `logo` varchar(255) NOT NULL DEFAULT '',
  `version` varchar(24) NOT NULL DEFAULT '',
  `version_base` varchar(24) NOT NULL DEFAULT '',
  `compatibilite_spip` varchar(24) NOT NULL DEFAULT '',
  `branches_spip` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `auteur` text NOT NULL,
  `credit` text NOT NULL,
  `licence` text NOT NULL,
  `copyright` text NOT NULL,
  `lien_doc` text NOT NULL,
  `lien_demo` text NOT NULL,
  `lien_dev` text NOT NULL,
  `etat` varchar(16) NOT NULL DEFAULT '',
  `etatnum` int(1) NOT NULL DEFAULT '0',
  `dependances` text NOT NULL,
  `procure` text NOT NULL,
  `date_crea` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modif` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_depot` bigint(21) NOT NULL DEFAULT '0',
  `nom_archive` varchar(255) NOT NULL DEFAULT '',
  `nbo_archive` int(11) NOT NULL DEFAULT '0',
  `maj_archive` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `src_archive` varchar(255) NOT NULL DEFAULT '',
  `traductions` text NOT NULL,
  `actif` varchar(3) NOT NULL DEFAULT 'non',
  `installe` varchar(3) NOT NULL DEFAULT 'non',
  `recent` int(2) NOT NULL DEFAULT '0',
  `maj_version` varchar(255) NOT NULL DEFAULT '',
  `superieur` varchar(3) NOT NULL DEFAULT 'non',
  `obsolete` varchar(3) NOT NULL DEFAULT 'non',
  `attente` varchar(3) NOT NULL DEFAULT 'non',
  `constante` varchar(30) NOT NULL DEFAULT '',
  `signature` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_paquet`),
  KEY `id_plugin` (`id_plugin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_petitions`
--

DROP TABLE IF EXISTS `spip_petitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_petitions` (
  `id_petition` bigint(21) NOT NULL AUTO_INCREMENT,
  `id_article` bigint(21) NOT NULL DEFAULT '0',
  `email_unique` char(3) NOT NULL DEFAULT '',
  `site_obli` char(3) NOT NULL DEFAULT '',
  `site_unique` char(3) NOT NULL DEFAULT '',
  `message` char(3) NOT NULL DEFAULT '',
  `texte` longtext NOT NULL,
  `statut` varchar(10) NOT NULL DEFAULT 'publie',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_petition`),
  UNIQUE KEY `id_article` (`id_article`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_plugins`
--

DROP TABLE IF EXISTS `spip_plugins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_plugins` (
  `id_plugin` bigint(21) NOT NULL AUTO_INCREMENT,
  `prefixe` varchar(30) NOT NULL DEFAULT '',
  `nom` text NOT NULL,
  `slogan` text NOT NULL,
  `categorie` varchar(100) NOT NULL DEFAULT '',
  `tags` text NOT NULL,
  `vmax` varchar(24) NOT NULL DEFAULT '',
  `date_crea` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modif` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `compatibilite_spip` varchar(24) NOT NULL DEFAULT '',
  `branches_spip` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_plugin`),
  KEY `prefixe` (`prefixe`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_referers`
--

DROP TABLE IF EXISTS `spip_referers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_referers` (
  `referer_md5` bigint(20) unsigned NOT NULL,
  `date` date NOT NULL,
  `referer` varchar(255) DEFAULT NULL,
  `visites` int(10) unsigned NOT NULL,
  `visites_jour` int(10) unsigned NOT NULL,
  `visites_veille` int(10) unsigned NOT NULL,
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`referer_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_referers_articles`
--

DROP TABLE IF EXISTS `spip_referers_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_referers_articles` (
  `id_article` int(10) unsigned NOT NULL,
  `referer_md5` bigint(20) unsigned NOT NULL,
  `referer` varchar(255) NOT NULL DEFAULT '',
  `visites` int(10) unsigned NOT NULL,
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_article`,`referer_md5`),
  KEY `referer_md5` (`referer_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_resultats`
--

DROP TABLE IF EXISTS `spip_resultats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_resultats` (
  `recherche` char(16) NOT NULL DEFAULT '',
  `id` int(10) unsigned NOT NULL,
  `points` int(10) unsigned NOT NULL DEFAULT '0',
  `table_objet` varchar(30) NOT NULL DEFAULT '',
  `serveur` char(16) NOT NULL DEFAULT '',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_rubriques`
--

DROP TABLE IF EXISTS `spip_rubriques`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_rubriques` (
  `id_rubrique` bigint(21) NOT NULL AUTO_INCREMENT,
  `id_parent` bigint(21) NOT NULL DEFAULT '0',
  `titre` text NOT NULL,
  `descriptif` text NOT NULL,
  `texte` longtext NOT NULL,
  `id_secteur` bigint(21) NOT NULL DEFAULT '0',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `statut` varchar(10) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lang` varchar(10) NOT NULL DEFAULT '',
  `langue_choisie` varchar(3) DEFAULT 'non',
  `statut_tmp` varchar(10) NOT NULL DEFAULT '0',
  `date_tmp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `profondeur` smallint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_rubrique`),
  KEY `lang` (`lang`),
  KEY `id_parent` (`id_parent`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_signatures`
--

DROP TABLE IF EXISTS `spip_signatures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_signatures` (
  `id_signature` bigint(21) NOT NULL AUTO_INCREMENT,
  `id_petition` bigint(21) NOT NULL DEFAULT '0',
  `date_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `nom_email` text NOT NULL,
  `ad_email` text NOT NULL,
  `nom_site` text NOT NULL,
  `url_site` text NOT NULL,
  `message` mediumtext NOT NULL,
  `statut` varchar(10) NOT NULL DEFAULT '0',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_signature`),
  KEY `id_petition` (`id_petition`),
  KEY `statut` (`statut`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_syndic`
--

DROP TABLE IF EXISTS `spip_syndic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_syndic` (
  `id_syndic` bigint(21) NOT NULL AUTO_INCREMENT,
  `id_rubrique` bigint(21) NOT NULL DEFAULT '0',
  `id_secteur` bigint(21) NOT NULL DEFAULT '0',
  `nom_site` text NOT NULL,
  `url_site` text NOT NULL,
  `url_syndic` text NOT NULL,
  `descriptif` text NOT NULL,
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `syndication` varchar(3) NOT NULL DEFAULT '',
  `statut` varchar(10) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_syndic` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_index` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `moderation` varchar(3) DEFAULT 'non',
  `miroir` varchar(3) DEFAULT 'non',
  `oubli` varchar(3) DEFAULT 'non',
  `resume` varchar(3) DEFAULT 'oui',
  PRIMARY KEY (`id_syndic`),
  KEY `id_rubrique` (`id_rubrique`),
  KEY `id_secteur` (`id_secteur`),
  KEY `statut` (`statut`,`date_syndic`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_syndic_articles`
--

DROP TABLE IF EXISTS `spip_syndic_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_syndic_articles` (
  `id_syndic_article` bigint(21) NOT NULL AUTO_INCREMENT,
  `id_syndic` bigint(21) NOT NULL DEFAULT '0',
  `titre` text NOT NULL,
  `url` text NOT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lesauteurs` text NOT NULL,
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `statut` varchar(10) NOT NULL DEFAULT '0',
  `descriptif` text NOT NULL,
  `lang` varchar(10) NOT NULL DEFAULT '',
  `url_source` tinytext NOT NULL,
  `source` tinytext NOT NULL,
  `tags` text NOT NULL,
  PRIMARY KEY (`id_syndic_article`),
  KEY `id_syndic` (`id_syndic`),
  KEY `statut` (`statut`),
  KEY `url` (`url`(255))
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_types_documents`
--

DROP TABLE IF EXISTS `spip_types_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_types_documents` (
  `extension` varchar(10) NOT NULL DEFAULT '',
  `titre` text NOT NULL,
  `descriptif` text NOT NULL,
  `mime_type` varchar(100) NOT NULL DEFAULT '',
  `inclus` enum('non','image','embed') NOT NULL DEFAULT 'non',
  `upload` enum('oui','non') NOT NULL DEFAULT 'oui',
  `media_defaut` varchar(10) NOT NULL DEFAULT 'file',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`extension`),
  KEY `inclus` (`inclus`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_urls`
--

DROP TABLE IF EXISTS `spip_urls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_urls` (
  `id_parent` bigint(21) NOT NULL DEFAULT '0',
  `url` varchar(255) NOT NULL,
  `type` varchar(25) NOT NULL DEFAULT 'article',
  `id_objet` bigint(21) NOT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `segments` smallint(3) NOT NULL DEFAULT '1',
  `perma` tinyint(1) NOT NULL DEFAULT '0',
  `langue` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_parent`,`url`),
  KEY `type` (`type`,`id_objet`),
  KEY `langue` (`langue`),
  KEY `url` (`url`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_versions`
--

DROP TABLE IF EXISTS `spip_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_versions` (
  `id_version` bigint(21) NOT NULL DEFAULT '0',
  `id_objet` bigint(21) NOT NULL DEFAULT '0',
  `objet` varchar(25) NOT NULL DEFAULT '',
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_auteur` varchar(23) NOT NULL DEFAULT '',
  `titre_version` text NOT NULL,
  `permanent` char(3) NOT NULL DEFAULT '',
  `champs` text NOT NULL,
  PRIMARY KEY (`id_version`,`id_objet`,`objet`),
  KEY `id_version` (`id_version`),
  KEY `id_objet` (`id_objet`),
  KEY `objet` (`objet`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_versions_fragments`
--

DROP TABLE IF EXISTS `spip_versions_fragments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_versions_fragments` (
  `id_fragment` int(10) unsigned NOT NULL DEFAULT '0',
  `version_min` int(10) unsigned NOT NULL DEFAULT '0',
  `version_max` int(10) unsigned NOT NULL DEFAULT '0',
  `id_objet` bigint(21) NOT NULL,
  `objet` varchar(25) NOT NULL DEFAULT '',
  `compress` tinyint(4) NOT NULL,
  `fragment` longblob,
  PRIMARY KEY (`id_objet`,`objet`,`id_fragment`,`version_min`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_visites`
--

DROP TABLE IF EXISTS `spip_visites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_visites` (
  `date` date NOT NULL,
  `visites` int(10) unsigned NOT NULL DEFAULT '0',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spip_visites_articles`
--

DROP TABLE IF EXISTS `spip_visites_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spip_visites_articles` (
  `date` date NOT NULL,
  `id_article` int(10) unsigned NOT NULL,
  `visites` int(10) unsigned NOT NULL DEFAULT '0',
  `maj` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`date`,`id_article`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-01 14:16:31
