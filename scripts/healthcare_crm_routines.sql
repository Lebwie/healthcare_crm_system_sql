-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: healthcare_crm
-- ------------------------------------------------------
-- Server version	9.3.0

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
-- Temporary view structure for view `billing_summary`
--

DROP TABLE IF EXISTS `billing_summary`;
/*!50001 DROP VIEW IF EXISTS `billing_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `billing_summary` AS SELECT 
 1 AS `patient_id`,
 1 AS `patient_name`,
 1 AS `total_bills`,
 1 AS `total_amount_due`,
 1 AS `total_paid`,
 1 AS `total_pending`,
 1 AS `total_overdue`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `doctor_schedule`
--

DROP TABLE IF EXISTS `doctor_schedule`;
/*!50001 DROP VIEW IF EXISTS `doctor_schedule`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `doctor_schedule` AS SELECT 
 1 AS `doctor_id`,
 1 AS `doctor_name`,
 1 AS `specialization`,
 1 AS `department`,
 1 AS `available_day`,
 1 AS `start_time`,
 1 AS `end_time`,
 1 AS `appointments_scheduled`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `patient_appointment_summary`
--

DROP TABLE IF EXISTS `patient_appointment_summary`;
/*!50001 DROP VIEW IF EXISTS `patient_appointment_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patient_appointment_summary` AS SELECT 
 1 AS `patient_id`,
 1 AS `patient_name`,
 1 AS `phone`,
 1 AS `email`,
 1 AS `total_appointments`,
 1 AS `completed_appointments`,
 1 AS `cancelled_appointments`,
 1 AS `last_appointment_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `billing_summary`
--

/*!50001 DROP VIEW IF EXISTS `billing_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `billing_summary` AS select `p`.`patient_id` AS `patient_id`,concat(`p`.`first_name`,' ',`p`.`last_name`) AS `patient_name`,count(`b`.`billing_id`) AS `total_bills`,sum(`b`.`amount_due`) AS `total_amount_due`,sum((case when (`b`.`status` = 'Paid') then `b`.`amount_due` else 0 end)) AS `total_paid`,sum((case when (`b`.`status` = 'Pending') then `b`.`amount_due` else 0 end)) AS `total_pending`,sum((case when (`b`.`status` = 'Overdue') then `b`.`amount_due` else 0 end)) AS `total_overdue` from (`patients` `p` left join `billing` `b` on((`p`.`patient_id` = `b`.`patient_id`))) group by `p`.`patient_id`,`p`.`first_name`,`p`.`last_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `doctor_schedule`
--

/*!50001 DROP VIEW IF EXISTS `doctor_schedule`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `doctor_schedule` AS select `d`.`doctor_id` AS `doctor_id`,concat(`d`.`first_name`,' ',`d`.`last_name`) AS `doctor_name`,`d`.`specialization` AS `specialization`,`dept`.`name` AS `department`,`da`.`available_day` AS `available_day`,`da`.`start_time` AS `start_time`,`da`.`end_time` AS `end_time`,count(`a`.`appointment_id`) AS `appointments_scheduled` from (((`doctors` `d` join `departments` `dept` on((`d`.`department_id` = `dept`.`department_id`))) left join `doctor_availability` `da` on((`d`.`doctor_id` = `da`.`doctor_id`))) left join `appointments` `a` on(((`d`.`doctor_id` = `a`.`doctor_id`) and (`a`.`appointment_date` >= curdate()) and (`a`.`status` = 'Scheduled')))) group by `d`.`doctor_id`,`d`.`first_name`,`d`.`last_name`,`d`.`specialization`,`dept`.`name`,`da`.`available_day`,`da`.`start_time`,`da`.`end_time` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `patient_appointment_summary`
--

/*!50001 DROP VIEW IF EXISTS `patient_appointment_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `patient_appointment_summary` AS select `p`.`patient_id` AS `patient_id`,concat(`p`.`first_name`,' ',`p`.`last_name`) AS `patient_name`,`p`.`phone` AS `phone`,`p`.`email` AS `email`,count(`a`.`appointment_id`) AS `total_appointments`,count((case when (`a`.`status` = 'Completed') then 1 end)) AS `completed_appointments`,count((case when (`a`.`status` = 'Cancelled') then 1 end)) AS `cancelled_appointments`,max(`a`.`appointment_date`) AS `last_appointment_date` from (`patients` `p` left join `appointments` `a` on((`p`.`patient_id` = `a`.`patient_id`))) group by `p`.`patient_id`,`p`.`first_name`,`p`.`last_name`,`p`.`phone`,`p`.`email` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-07 22:32:28
