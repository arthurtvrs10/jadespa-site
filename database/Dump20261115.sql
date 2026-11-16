CREATE DATABASE  IF NOT EXISTS `jade_spa` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `jade_spa`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: jade_spa
-- ------------------------------------------------------
-- Server version	8.0.4-rc-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `agendamentos`
--

DROP TABLE IF EXISTS `agendamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agendamentos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cliente_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cliente_nome` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `criado_em` datetime(6) NOT NULL,
  `data` date DEFAULT NULL,
  `dia_semana` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `horario` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nome_item` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `profissional` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agendamentos`
--

LOCK TABLES `agendamentos` WRITE;
/*!40000 ALTER TABLE `agendamentos` DISABLE KEYS */;
INSERT INTO `agendamentos` VALUES (1,'mirelyalmeida@gmail.com','Mirely Almeida da Silva','2026-11-08 21:50:55.793702','2026-11-09',NULL,'10:00','Sessão de Meditação Guiada','Sem preferência','Cancelado','TRATAMENTO'),(3,'mirelyalmeida@gmail.com','Mirely Almeida','2026-11-08 22:29:28.794898',NULL,'Sexta-feira','17:00 às 18:00','Pilates','A definir','Concluído','AULA'),(4,'mirelyalmeida@gmail.com','Mirely Almeida da Silva','2026-11-08 22:39:06.548724','2026-11-09',NULL,'18:30','Massagem Relaxante','Sem preferência','Concluído','TRATAMENTO'),(5,'mirelyalmeida@gmail.com','Mirely Almeida','2026-11-08 22:39:33.637682',NULL,'Quarta-feira','17:00 às 18:00','Pilates','A definir','Concluído','AULA'),(6,'chloealves@gmail.com','Chloe Alves','2026-11-08 22:43:36.616642',NULL,'Segunda-feira','18:00 às 19:00','Yoga','A definir','Confirmado','AULA'),(7,'chloealves@gmail.com','Chloe Alves','2026-11-08 22:43:53.353715','2026-11-09',NULL,'10:00','Massagem Relaxante','Sem preferência','Confirmado','TRATAMENTO'),(8,'theodoroalvees@gmail.com','Theodoro Alves','2026-11-09 17:22:56.314750','2026-11-10',NULL,'14:00','Massagem Relaxante','Sem preferência','Confirmado','TRATAMENTO'),(9,'theodoroalvees@gmail.com','Theodor Alves','2026-11-09 17:23:43.072658',NULL,'Sexta-feira','14:00 às 16:00','Cerâmica Fria','A definir','Confirmado','AULA'),(10,'theodoroalvees@gmail.com','Theodoro Alves','2026-11-09 18:35:08.968949','2026-11-10',NULL,'08:30','Tratamento Facial','Sem preferência','Confirmado','TRATAMENTO'),(11,'theodoroalvees@gmail.com','Theodoro Alves','2026-11-09 18:39:58.712209','2026-12-22',NULL,'08:30','Sessão de Meditação Guiada','Sem preferência','Confirmado','TRATAMENTO'),(12,'clientejade@gmail.com','cliente jade','2026-11-10 02:23:02.403676','2026-11-11',NULL,'10:00','Massagem Relaxante','Sem preferência','Cancelado','TRATAMENTO'),(13,'clientejade@gmail.com','cliente jade','2026-11-10 02:24:08.310687',NULL,'Sábado','14:00 às 16:00','Cerâmica Fria','A definir','Confirmado','AULA');
/*!40000 ALTER TABLE `agendamentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assinaturas`
--

DROP TABLE IF EXISTS `assinaturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assinaturas` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cliente_id` bigint(20) NOT NULL,
  `plano_id` bigint(20) NOT NULL,
  `data_inicio` datetime NOT NULL,
  `data_fim` datetime DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_assinatura_plano` (`plano_id`),
  KEY `idx_assinatura_cliente_status` (`cliente_id`,`status`),
  CONSTRAINT `fk_assinatura_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  CONSTRAINT `fk_assinatura_plano` FOREIGN KEY (`plano_id`) REFERENCES `planos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assinaturas`
--

LOCK TABLES `assinaturas` WRITE;
/*!40000 ALTER TABLE `assinaturas` DISABLE KEYS */;
INSERT INTO `assinaturas` VALUES (1,6,2,'2026-11-10 02:01:18','2026-11-10 02:16:52','ENCERRADA'),(2,6,1,'2026-11-10 02:16:52',NULL,'ATIVA'),(3,1,2,'2026-11-14 18:25:40','2026-11-14 20:42:40','ENCERRADA'),(4,7,2,'2026-11-14 19:37:23','2026-11-14 19:37:47','ENCERRADA'),(5,7,3,'2026-11-14 19:37:47','2026-11-14 19:45:46','ENCERRADA'),(6,7,1,'2026-11-14 19:45:46',NULL,'ATIVA'),(7,1,3,'2026-11-14 20:42:40',NULL,'ATIVA');
/*!40000 ALTER TABLE `assinaturas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aulas`
--

DROP TABLE IF EXISTS `aulas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aulas` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ativo` bit(1) NOT NULL,
  `descricao` text COLLATE utf8mb4_unicode_ci,
  `dia_semana` enum('FRIDAY','MONDAY','SATURDAY','SUNDAY','THURSDAY','TUESDAY','WEDNESDAY') COLLATE utf8mb4_unicode_ci NOT NULL,
  `horario_fim` time NOT NULL,
  `horario_inicio` time NOT NULL,
  `nome` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vagas` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aulas`
--

LOCK TABLES `aulas` WRITE;
/*!40000 ALTER TABLE `aulas` DISABLE KEYS */;
INSERT INTO `aulas` VALUES (1,_binary '','Práticas de alongamento, respiração e movimentos para melhorar o equilíbrio e o bem-estar.','MONDAY','09:00:00','08:00:00','Yoga',10),(2,_binary '','Práticas de alongamento, respiração e movimentos para melhorar o equilíbrio e o bem-estar.','MONDAY','19:00:00','18:00:00','Yoga',10),(3,_binary '','Práticas de alongamento, respiração e movimentos para melhorar o equilíbrio e o bem-estar.','WEDNESDAY','09:00:00','08:00:00','Yoga',10),(4,_binary '','Práticas de alongamento, respiração e movimentos para melhorar o equilíbrio e o bem-estar.','WEDNESDAY','19:00:00','18:00:00','Yoga',10),(5,_binary '','Exercícios que trabalham força, postura, flexibilidade e consciência corporal.','WEDNESDAY','10:00:00','09:00:00','Pilates',10),(6,_binary '','Exercícios que trabalham força, postura, flexibilidade e consciência corporal.','WEDNESDAY','18:00:00','17:00:00','Pilates',10),(7,_binary '','Exercícios que trabalham força, postura, flexibilidade e consciência corporal.','FRIDAY','10:00:00','09:00:00','Pilates',10),(8,_binary '','Exercícios que trabalham força, postura, flexibilidade e consciência corporal.','FRIDAY','18:00:00','17:00:00','Pilates',10),(9,_binary '','Uma atividade criativa para relaxar e desenvolver novas habilidades, criando peças feitas à mão.','FRIDAY','16:00:00','14:00:00','Cerâmica Fria',10),(10,_binary '','Uma atividade criativa para relaxar e desenvolver novas habilidades, criando peças feitas à mão.','FRIDAY','18:00:00','16:00:00','Cerâmica Fria',10),(11,_binary '','Uma atividade criativa para relaxar e desenvolver novas habilidades, criando peças feitas à mão.','SATURDAY','11:00:00','09:00:00','Cerâmica Fria',10),(12,_binary '','Uma atividade criativa para relaxar e desenvolver novas habilidades, criando peças feitas à mão.','SATURDAY','16:00:00','14:00:00','Cerâmica Fria',10);
/*!40000 ALTER TABLE `aulas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `criado_em` datetime(6) NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nome` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `senha_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK1c96wv36rk2hwui7qhjks3mvg` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'2026-11-02 23:19:52.380917','mirelyalmeida@gmail.com','Mirely Almeida da Silva','$2a$10$7NPlLnh0vbjTRPSuSwplReOzy29cYRKDEDP5wh0b9py0bsTvTstke','Ativo','61 99478-8562',NULL),(2,'2026-11-02 23:35:44.756205','theodoroalvees@gmail.com','Theodoro Alves','$2a$10$Yeq5KDmV2qoyP6SEeZgIg.StNjo5Pxy6fvTz.aplS9Yh8H/nT0DWe','Ativo','61 92514-7832',NULL),(3,'2026-11-05 16:22:53.184380','luisacamp@gmail.com','Luisa Campos','$2a$10$4JIry7kax00bWTsB5hB02umlmsdvkh0ibmDDGw1S3BwddeIFXiRRS','Ativo','61 92567-1285',NULL),(4,'2026-11-08 22:42:45.505712','chloealves@gmail.com','Chloe Alves','$2a$10$eOQWHnwwBe30A2r79FmCEeXYsf3sFE1isTbOn4AlCUGM.ppal4boi','Ativo','61 9 6852-4781',NULL),(5,'2026-11-09 21:23:51.575455','manualmeida@gmail.com','Manuella Almeida','$2a$10$S2uv/3Qb6NWMY0FnsEv.KOTCgQb5AGNuTeXPdz.X0OMhsIAUBxLJ2','Ativo','61 9 6784-2365',NULL),(6,'2026-11-09 23:23:50.743451','clientejade@gmail.com','cliente jade','$2a$10$kK6R1/TZCkhBumow020k6eGMICt8r.URmF8y4HjE0yWf.oIfSxSBe','Ativo','61 92365-4587','2006-09-14'),(7,'2026-11-10 09:36:22.046385','testejade@gmail.com','Teste jade','$2a$10$iSPGYkEYX2bPCFVQv3L7guA4kL.hnIz2ftymxY.gERWQ05qrSUQMS','Ativo','61 9 9999-9999','2004-01-09'),(8,'2026-11-14 20:09:35.596630','novousuario@gmail.com','Novo Usuário','$2a$10$wWhnVLFSMyKFmkU/G97l1OKloMY3D8RHNJIUWiZhHCXKwMSCkVahG','Ativo','61 9 3674-8541','1997-01-02');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificacoes`
--

DROP TABLE IF EXISTS `notificacoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificacoes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cliente_email` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `criada_em` datetime(6) NOT NULL,
  `lida` bit(1) NOT NULL,
  `mensagem` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `titulo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_notificacoes_cliente_email` (`cliente_email`),
  KEY `idx_notificacoes_criada_em` (`criada_em`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacoes`
--

LOCK TABLES `notificacoes` WRITE;
/*!40000 ALTER TABLE `notificacoes` DISABLE KEYS */;
INSERT INTO `notificacoes` VALUES (1,'theodoroalvees@gmail.com','2026-11-09 18:39:59.046284',_binary '','Tratamento: Sessão de Meditação Guiada — 2026-12-22 às 08:30. Seu agendamento foi confirmado.','TRATAMENTO','Agendamento confirmado'),(2,'clientejade@gmail.com','2026-11-10 02:01:17.830348',_binary '','Seu pagamento de demonstração foi aprovado e seu plano Jade Equilíbrio está ativo.','PLANO','Plano aprovado!'),(3,'clientejade@gmail.com','2026-11-10 02:16:52.187370',_binary '','Seu pagamento de demonstração foi aprovado e seu plano Jade Essencial está ativo.','PLANO','Plano aprovado!'),(4,'clientejade@gmail.com','2026-11-10 02:23:02.456522',_binary '','Tratamento: Massagem Relaxante — 2026-11-11 às 10:00. Seu agendamento foi confirmado.','TRATAMENTO','Agendamento confirmado'),(5,'clientejade@gmail.com','2026-11-10 02:24:08.341822',_binary '','Aula: Cerâmica Fria — Sábado às 14:00 às 16:00. Seu agendamento foi confirmado.','AULA','Inscrição em aula confirmada'),(6,'clientejade@gmail.com','2026-11-14 17:46:38.749058',_binary '\0','Tratamento: Massagem Relaxante — 2026-11-11 às 10:00. O cancelamento foi registrado com sucesso.','CANCELAMENTO','Agendamento cancelado'),(7,'mirelyalmeida@gmail.com','2026-11-14 18:25:39.708941',_binary '','Seu pagamento de demonstração foi aprovado e seu plano Jade Equilíbrio está ativo.','PLANO','Plano aprovado!'),(8,'testejade@gmail.com','2026-11-14 19:37:23.449465',_binary '','Seu pagamento de demonstração foi aprovado e seu plano Jade Equilíbrio está ativo.','PLANO','Plano aprovado!'),(9,'testejade@gmail.com','2026-11-14 19:37:47.126745',_binary '','Seu pagamento de demonstração foi aprovado e seu plano Jade Premium está ativo.','PLANO','Plano aprovado!'),(10,'testejade@gmail.com','2026-11-14 19:45:45.667132',_binary '','Seu pagamento de demonstração foi aprovado e seu plano Jade Essencial está ativo.','PLANO','Plano aprovado!'),(11,'mirelyalmeida@gmail.com','2026-11-14 20:29:53.444873',_binary '','Tratamento: Sessão de Meditação Guiada — 2026-11-09 às 10:00. O cancelamento foi registrado com sucesso.','CANCELAMENTO','Agendamento cancelado'),(12,'mirelyalmeida@gmail.com','2026-11-14 20:42:39.683788',_binary '\0','Seu pagamento de demonstração foi aprovado e seu plano Jade Premium está ativo.','PLANO','Plano aprovado!');
/*!40000 ALTER TABLE `notificacoes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planos`
--

DROP TABLE IF EXISTS `planos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `planos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor` decimal(10,2) NOT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planos`
--

LOCK TABLES `planos` WRITE;
/*!40000 ALTER TABLE `planos` DISABLE KEYS */;
INSERT INTO `planos` VALUES (1,'Jade Essencial','Para quem quer começar a cuidar de si.',299.90,1),(2,'Jade Equilíbrio','Para quem busca uma rotina mais completa de bem-estar.',549.90,1),(3,'Jade Premium','Para uma experiência completa de cuidado e relaxamento.',769.90,1);
/*!40000 ALTER TABLE `planos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicos`
--

DROP TABLE IF EXISTS `servicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ativo` bit(1) NOT NULL,
  `categoria` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_unicode_ci,
  `duracao_minutos` int(11) NOT NULL,
  `nome` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sessoes_por_mes` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicos`
--

LOCK TABLES `servicos` WRITE;
/*!40000 ALTER TABLE `servicos` DISABLE KEYS */;
INSERT INTO `servicos` VALUES (1,_binary '','Massagem','Movimentos suaves para aliviar as tensões e proporcionar um momento de tranquilidade.',60,'Massagem Relaxante',2),(2,_binary '','Tratamento Facial','Uma sessão personalizada para cuidar da pele de acordo com suas necessidades.',60,'Tratamento Facial',1),(3,_binary '','Bem-estar','Um momento de pausa com orientação para praticar atenção plena e respiração.',30,'Meditação Guiada',2);
/*!40000 ALTER TABLE `servicos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitacoes_troca_plano`
--

DROP TABLE IF EXISTS `solicitacoes_troca_plano`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitacoes_troca_plano` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cliente_id` bigint(20) NOT NULL,
  `plano_id` bigint(20) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comprovante` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observacao_admin` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_solicitacao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data_analise` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_solicitacao_plano` (`plano_id`),
  KEY `idx_solicitacao_status` (`status`),
  KEY `idx_solicitacao_cliente` (`cliente_id`),
  CONSTRAINT `fk_solicitacao_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  CONSTRAINT `fk_solicitacao_plano` FOREIGN KEY (`plano_id`) REFERENCES `planos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitacoes_troca_plano`
--

LOCK TABLES `solicitacoes_troca_plano` WRITE;
/*!40000 ALTER TABLE `solicitacoes_troca_plano` DISABLE KEYS */;
INSERT INTO `solicitacoes_troca_plano` VALUES (1,6,2,549.90,'APROVADA','PIX_SIMULADO',NULL,'2026-11-10 01:37:58','2026-11-10 02:01:18'),(2,6,1,299.90,'APROVADA','PIX_SIMULADO',NULL,'2026-11-10 02:16:28','2026-11-10 02:16:52'),(3,6,2,549.90,'AGUARDANDO_COMPROVANTE',NULL,NULL,'2026-11-10 02:18:03',NULL),(4,1,2,549.90,'APROVADA','PIX_SIMULADO',NULL,'2026-11-14 18:24:49','2026-11-14 18:25:40'),(5,1,3,769.90,'APROVADA','PIX_SIMULADO',NULL,'2026-11-14 18:26:09','2026-11-14 20:42:40'),(6,7,2,549.90,'APROVADA','PIX_SIMULADO',NULL,'2026-11-14 18:58:05','2026-11-14 19:37:23'),(7,7,3,769.90,'APROVADA','PIX_SIMULADO',NULL,'2026-11-14 19:37:40','2026-11-14 19:37:47'),(8,7,1,299.90,'APROVADA','PIX_SIMULADO',NULL,'2026-11-14 19:45:37','2026-11-14 19:45:46');
/*!40000 ALTER TABLE `solicitacoes_troca_plano` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-15 22:34:13
