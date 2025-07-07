-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema healthcare_crm
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema healthcare_crm
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `healthcare_crm` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `healthcare_crm` ;

-- -----------------------------------------------------
-- Table `healthcare_crm`.`patients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`patients` (
  `patient_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `gender` ENUM('Male', 'Female', 'Other') NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `address` VARCHAR(255) NULL DEFAULT NULL,
  `city` VARCHAR(100) NULL DEFAULT NULL,
  `state` VARCHAR(100) NULL DEFAULT NULL,
  `zip_code` VARCHAR(20) NULL DEFAULT NULL,
  `registration_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`patient_id`),
  INDEX `idx_patient_name` (`last_name` ASC, `first_name` ASC) VISIBLE,
  INDEX `idx_patient_phone` (`phone` ASC) VISIBLE,
  INDEX `idx_patient_email` (`email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`departments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`departments` (
  `department_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`department_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`doctors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`doctors` (
  `doctor_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `gender` ENUM('Male', 'Female', 'Other') NOT NULL,
  `specialization` VARCHAR(100) NULL DEFAULT NULL,
  `department_id` INT NULL DEFAULT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `joining_date` DATE NULL DEFAULT NULL,
  `status` ENUM('Active', 'Inactive', 'On Leave') NULL DEFAULT 'Active',
  PRIMARY KEY (`doctor_id`),
  INDEX `idx_doctor_specialization` (`specialization` ASC) VISIBLE,
  INDEX `idx_doctor_department` (`department_id` ASC) VISIBLE,
  CONSTRAINT `doctors_ibfk_1`
    FOREIGN KEY (`department_id`)
    REFERENCES `healthcare_crm`.`departments` (`department_id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`clinics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`clinics` (
  `clinic_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `address` VARCHAR(255) NULL DEFAULT NULL,
  `city` VARCHAR(100) NULL DEFAULT NULL,
  `state` VARCHAR(100) NULL DEFAULT NULL,
  `zip_code` VARCHAR(20) NULL DEFAULT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`clinic_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`appointments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`appointments` (
  `appointment_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `doctor_id` INT NOT NULL,
  `appointment_date` DATE NOT NULL,
  `appointment_time` TIME NOT NULL,
  `clinic_id` INT NULL DEFAULT NULL,
  `status` ENUM('Scheduled', 'Completed', 'Cancelled', 'No Show') NULL DEFAULT 'Scheduled',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`appointment_id`),
  INDEX `clinic_id` (`clinic_id` ASC) VISIBLE,
  INDEX `idx_appointment_date` (`appointment_date` ASC) VISIBLE,
  INDEX `idx_appointment_patient` (`patient_id` ASC) VISIBLE,
  INDEX `idx_appointment_doctor` (`doctor_id` ASC) VISIBLE,
  INDEX `idx_appointments_date_status` (`appointment_date` ASC, `status` ASC) VISIBLE,
  CONSTRAINT `appointments_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE,
  CONSTRAINT `appointments_ibfk_2`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `healthcare_crm`.`doctors` (`doctor_id`)
    ON DELETE CASCADE,
  CONSTRAINT `appointments_ibfk_3`
    FOREIGN KEY (`clinic_id`)
    REFERENCES `healthcare_crm`.`clinics` (`clinic_id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`billing`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`billing` (
  `billing_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `appointment_id` INT NULL DEFAULT NULL,
  `amount_due` DECIMAL(10,2) NOT NULL,
  `due_date` DATE NULL DEFAULT NULL,
  `status` ENUM('Pending', 'Paid', 'Overdue', 'Cancelled') NULL DEFAULT 'Pending',
  PRIMARY KEY (`billing_id`),
  INDEX `appointment_id` (`appointment_id` ASC) VISIBLE,
  INDEX `idx_billing_patient` (`patient_id` ASC) VISIBLE,
  INDEX `idx_billing_due_date` (`due_date` ASC) VISIBLE,
  INDEX `idx_billing_status` (`status` ASC) VISIBLE,
  INDEX `idx_billing_patient_status` (`patient_id` ASC, `status` ASC) VISIBLE,
  CONSTRAINT `billing_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE,
  CONSTRAINT `billing_ibfk_2`
    FOREIGN KEY (`appointment_id`)
    REFERENCES `healthcare_crm`.`appointments` (`appointment_id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`campaigns`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`campaigns` (
  `campaign_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `start_date` DATE NULL DEFAULT NULL,
  `end_date` DATE NULL DEFAULT NULL,
  `status` ENUM('Draft', 'Active', 'Completed', 'Cancelled') NULL DEFAULT 'Draft',
  PRIMARY KEY (`campaign_id`),
  INDEX `idx_campaign_dates` (`start_date` ASC, `end_date` ASC) VISIBLE,
  INDEX `idx_campaign_status` (`status` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`diagnosis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`diagnosis` (
  `diagnosis_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `doctor_id` INT NOT NULL,
  `diagnosis_date` DATE NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `disease_name` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`diagnosis_id`),
  INDEX `idx_diagnosis_patient` (`patient_id` ASC) VISIBLE,
  INDEX `idx_diagnosis_doctor` (`doctor_id` ASC) VISIBLE,
  INDEX `idx_diagnosis_date` (`diagnosis_date` ASC) VISIBLE,
  INDEX `idx_diagnosis_patient_date` (`patient_id` ASC, `diagnosis_date` ASC) VISIBLE,
  CONSTRAINT `diagnosis_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE,
  CONSTRAINT `diagnosis_ibfk_2`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `healthcare_crm`.`doctors` (`doctor_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`doctor_availability`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`doctor_availability` (
  `availability_id` INT NOT NULL AUTO_INCREMENT,
  `doctor_id` INT NOT NULL,
  `available_day` ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL,
  PRIMARY KEY (`availability_id`),
  INDEX `idx_availability_doctor` (`doctor_id` ASC) VISIBLE,
  INDEX `idx_availability_day` (`available_day` ASC) VISIBLE,
  CONSTRAINT `doctor_availability_ibfk_1`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `healthcare_crm`.`doctors` (`doctor_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`emergency_contacts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`emergency_contacts` (
  `contact_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `name` VARCHAR(150) NOT NULL,
  `relation` VARCHAR(50) NULL DEFAULT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`contact_id`),
  INDEX `idx_emergency_patient` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `emergency_contacts_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`feedback` (
  `feedback_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `doctor_id` INT NULL DEFAULT NULL,
  `rating` INT NULL DEFAULT NULL,
  `comments` TEXT NULL DEFAULT NULL,
  `feedback_date` DATE NOT NULL,
  PRIMARY KEY (`feedback_id`),
  INDEX `idx_feedback_patient` (`patient_id` ASC) VISIBLE,
  INDEX `idx_feedback_doctor` (`doctor_id` ASC) VISIBLE,
  INDEX `idx_feedback_rating` (`rating` ASC) VISIBLE,
  INDEX `idx_feedback_doctor_rating` (`doctor_id` ASC, `rating` ASC) VISIBLE,
  CONSTRAINT `feedback_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE,
  CONSTRAINT `feedback_ibfk_2`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `healthcare_crm`.`doctors` (`doctor_id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`follow_ups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`follow_ups` (
  `followup_id` INT NOT NULL AUTO_INCREMENT,
  `appointment_id` INT NOT NULL,
  `patient_id` INT NOT NULL,
  `doctor_id` INT NOT NULL,
  `followup_date` DATE NOT NULL,
  `notes` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`followup_id`),
  INDEX `doctor_id` (`doctor_id` ASC) VISIBLE,
  INDEX `idx_followup_appointment` (`appointment_id` ASC) VISIBLE,
  INDEX `idx_followup_patient` (`patient_id` ASC) VISIBLE,
  INDEX `idx_followup_date` (`followup_date` ASC) VISIBLE,
  CONSTRAINT `follow_ups_ibfk_1`
    FOREIGN KEY (`appointment_id`)
    REFERENCES `healthcare_crm`.`appointments` (`appointment_id`)
    ON DELETE CASCADE,
  CONSTRAINT `follow_ups_ibfk_2`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE,
  CONSTRAINT `follow_ups_ibfk_3`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `healthcare_crm`.`doctors` (`doctor_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`hospitals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`hospitals` (
  `hospital_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `address` VARCHAR(255) NULL DEFAULT NULL,
  `city` VARCHAR(100) NULL DEFAULT NULL,
  `state` VARCHAR(100) NULL DEFAULT NULL,
  `zip_code` VARCHAR(20) NULL DEFAULT NULL,
  `contact_number` VARCHAR(20) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`hospital_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`insurance_providers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`insurance_providers` (
  `provider_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `contact_number` VARCHAR(20) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `address` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`provider_id`),
  INDEX `idx_provider_name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`insurance_claims`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`insurance_claims` (
  `claim_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `provider_id` INT NOT NULL,
  `appointment_id` INT NULL DEFAULT NULL,
  `claim_date` DATE NOT NULL,
  `claim_amount` DECIMAL(10,2) NULL DEFAULT NULL,
  `status` ENUM('Pending', 'Approved', 'Rejected', 'Processing') NULL DEFAULT 'Pending',
  PRIMARY KEY (`claim_id`),
  INDEX `appointment_id` (`appointment_id` ASC) VISIBLE,
  INDEX `idx_claim_patient` (`patient_id` ASC) VISIBLE,
  INDEX `idx_claim_provider` (`provider_id` ASC) VISIBLE,
  INDEX `idx_claim_date` (`claim_date` ASC) VISIBLE,
  CONSTRAINT `insurance_claims_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE,
  CONSTRAINT `insurance_claims_ibfk_2`
    FOREIGN KEY (`provider_id`)
    REFERENCES `healthcare_crm`.`insurance_providers` (`provider_id`)
    ON DELETE CASCADE,
  CONSTRAINT `insurance_claims_ibfk_3`
    FOREIGN KEY (`appointment_id`)
    REFERENCES `healthcare_crm`.`appointments` (`appointment_id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`invoices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`invoices` (
  `invoice_id` INT NOT NULL AUTO_INCREMENT,
  `billing_id` INT NOT NULL,
  `invoice_date` DATE NOT NULL,
  `total_amount` DECIMAL(10,2) NOT NULL,
  `tax_amount` DECIMAL(10,2) NULL DEFAULT '0.00',
  `net_amount` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`invoice_id`),
  INDEX `idx_invoice_billing` (`billing_id` ASC) VISIBLE,
  INDEX `idx_invoice_date` (`invoice_date` ASC) VISIBLE,
  CONSTRAINT `invoices_ibfk_1`
    FOREIGN KEY (`billing_id`)
    REFERENCES `healthcare_crm`.`billing` (`billing_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`lab_tests`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`lab_tests` (
  `test_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `cost` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`test_id`),
  INDEX `idx_test_name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`roles` (
  `role_id` INT NOT NULL AUTO_INCREMENT,
  `role_name` VARCHAR(50) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE INDEX `role_name` (`role_name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `role_id` INT NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `username` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email` (`email` ASC) VISIBLE,
  INDEX `role_id` (`role_id` ASC) VISIBLE,
  INDEX `idx_username` (`username` ASC) VISIBLE,
  INDEX `idx_email` (`email` ASC) VISIBLE,
  CONSTRAINT `users_ibfk_1`
    FOREIGN KEY (`role_id`)
    REFERENCES `healthcare_crm`.`roles` (`role_id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`login_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`login_history` (
  `login_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `login_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `logout_time` TIMESTAMP NULL DEFAULT NULL,
  `ip_address` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`login_id`),
  INDEX `idx_login_user` (`user_id` ASC) VISIBLE,
  INDEX `idx_login_time` (`login_time` ASC) VISIBLE,
  CONSTRAINT `login_history_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `healthcare_crm`.`users` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`medical_devices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`medical_devices` (
  `device_id` INT NOT NULL AUTO_INCREMENT,
  `device_name` VARCHAR(150) NOT NULL,
  `serial_number` VARCHAR(100) NULL DEFAULT NULL,
  `assigned_to_patient_id` INT NULL DEFAULT NULL,
  `assigned_date` DATE NULL DEFAULT NULL,
  `returned_date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`device_id`),
  UNIQUE INDEX `serial_number` (`serial_number` ASC) VISIBLE,
  INDEX `idx_device_patient` (`assigned_to_patient_id` ASC) VISIBLE,
  INDEX `idx_device_serial` (`serial_number` ASC) VISIBLE,
  CONSTRAINT `medical_devices_ibfk_1`
    FOREIGN KEY (`assigned_to_patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`medical_records`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`medical_records` (
  `record_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `record_date` DATE NOT NULL,
  `summary` TEXT NULL DEFAULT NULL,
  `document_url` VARCHAR(500) NULL DEFAULT NULL,
  PRIMARY KEY (`record_id`),
  INDEX `idx_record_patient` (`patient_id` ASC) VISIBLE,
  INDEX `idx_record_date` (`record_date` ASC) VISIBLE,
  INDEX `idx_medical_records_patient_date` (`patient_id` ASC, `record_date` ASC) VISIBLE,
  CONSTRAINT `medical_records_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`medications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`medications` (
  `medication_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `dosage` VARCHAR(50) NULL DEFAULT NULL,
  `manufacturer` VARCHAR(100) NULL DEFAULT NULL,
  `expiry_date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`medication_id`),
  INDEX `idx_medication_name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`notifications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`notifications` (
  `notification_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `message` TEXT NOT NULL,
  `status` ENUM('Unread', 'Read', 'Archived') NULL DEFAULT 'Unread',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  INDEX `idx_notification_user` (`user_id` ASC) VISIBLE,
  INDEX `idx_notification_status` (`status` ASC) VISIBLE,
  CONSTRAINT `notifications_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `healthcare_crm`.`users` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`patient_family_members`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`patient_family_members` (
  `member_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `name` VARCHAR(150) NOT NULL,
  `relation` VARCHAR(50) NULL DEFAULT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  `date_of_birth` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`member_id`),
  INDEX `idx_family_patient` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `patient_family_members_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`payments` (
  `payment_id` INT NOT NULL AUTO_INCREMENT,
  `billing_id` INT NOT NULL,
  `payment_date` DATE NOT NULL,
  `payment_method` ENUM('Cash', 'Credit Card', 'Debit Card', 'Insurance', 'Bank Transfer') NOT NULL,
  `amount_paid` DECIMAL(10,2) NOT NULL,
  `transaction_id` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  INDEX `idx_payment_billing` (`billing_id` ASC) VISIBLE,
  INDEX `idx_payment_date` (`payment_date` ASC) VISIBLE,
  INDEX `idx_payments_date` (`payment_date` ASC) VISIBLE,
  CONSTRAINT `payments_ibfk_1`
    FOREIGN KEY (`billing_id`)
    REFERENCES `healthcare_crm`.`billing` (`billing_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`prescriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`prescriptions` (
  `prescription_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `doctor_id` INT NOT NULL,
  `medication_id` INT NOT NULL,
  `dosage` VARCHAR(100) NULL DEFAULT NULL,
  `frequency` VARCHAR(100) NULL DEFAULT NULL,
  `start_date` DATE NULL DEFAULT NULL,
  `end_date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`prescription_id`),
  INDEX `medication_id` (`medication_id` ASC) VISIBLE,
  INDEX `idx_prescription_patient` (`patient_id` ASC) VISIBLE,
  INDEX `idx_prescription_doctor` (`doctor_id` ASC) VISIBLE,
  INDEX `idx_prescriptions_patient_doctor` (`patient_id` ASC, `doctor_id` ASC) VISIBLE,
  CONSTRAINT `prescriptions_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE,
  CONSTRAINT `prescriptions_ibfk_2`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `healthcare_crm`.`doctors` (`doctor_id`)
    ON DELETE CASCADE,
  CONSTRAINT `prescriptions_ibfk_3`
    FOREIGN KEY (`medication_id`)
    REFERENCES `healthcare_crm`.`medications` (`medication_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`referrals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`referrals` (
  `referral_id` INT NOT NULL AUTO_INCREMENT,
  `referred_by_doctor_id` INT NOT NULL,
  `referred_to_doctor_id` INT NOT NULL,
  `patient_id` INT NOT NULL,
  `referral_date` DATE NOT NULL,
  `notes` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`referral_id`),
  INDEX `idx_referral_from_doctor` (`referred_by_doctor_id` ASC) VISIBLE,
  INDEX `idx_referral_to_doctor` (`referred_to_doctor_id` ASC) VISIBLE,
  INDEX `idx_referral_patient` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `referrals_ibfk_1`
    FOREIGN KEY (`referred_by_doctor_id`)
    REFERENCES `healthcare_crm`.`doctors` (`doctor_id`)
    ON DELETE CASCADE,
  CONSTRAINT `referrals_ibfk_2`
    FOREIGN KEY (`referred_to_doctor_id`)
    REFERENCES `healthcare_crm`.`doctors` (`doctor_id`)
    ON DELETE CASCADE,
  CONSTRAINT `referrals_ibfk_3`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`subscriptions` (
  `subscription_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `campaign_id` INT NOT NULL,
  `subscribed_on` DATE NOT NULL,
  `unsubscribed_on` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`subscription_id`),
  INDEX `idx_subscription_patient` (`patient_id` ASC) VISIBLE,
  INDEX `idx_subscription_campaign` (`campaign_id` ASC) VISIBLE,
  CONSTRAINT `subscriptions_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE,
  CONSTRAINT `subscriptions_ibfk_2`
    FOREIGN KEY (`campaign_id`)
    REFERENCES `healthcare_crm`.`campaigns` (`campaign_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`support_tickets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`support_tickets` (
  `ticket_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `issue_type` VARCHAR(100) NULL DEFAULT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `status` ENUM('Open', 'In Progress', 'Resolved', 'Closed') NULL DEFAULT 'Open',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`ticket_id`),
  INDEX `idx_ticket_user` (`user_id` ASC) VISIBLE,
  INDEX `idx_ticket_status` (`status` ASC) VISIBLE,
  INDEX `idx_ticket_created` (`created_at` ASC) VISIBLE,
  CONSTRAINT `support_tickets_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `healthcare_crm`.`users` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`test_results`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`test_results` (
  `result_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `test_id` INT NOT NULL,
  `test_date` DATE NOT NULL,
  `result` TEXT NULL DEFAULT NULL,
  `doctor_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`result_id`),
  INDEX `doctor_id` (`doctor_id` ASC) VISIBLE,
  INDEX `idx_result_patient` (`patient_id` ASC) VISIBLE,
  INDEX `idx_result_test` (`test_id` ASC) VISIBLE,
  INDEX `idx_result_date` (`test_date` ASC) VISIBLE,
  INDEX `idx_test_results_patient_date` (`patient_id` ASC, `test_date` ASC) VISIBLE,
  CONSTRAINT `test_results_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `healthcare_crm`.`patients` (`patient_id`)
    ON DELETE CASCADE,
  CONSTRAINT `test_results_ibfk_2`
    FOREIGN KEY (`test_id`)
    REFERENCES `healthcare_crm`.`lab_tests` (`test_id`)
    ON DELETE CASCADE,
  CONSTRAINT `test_results_ibfk_3`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `healthcare_crm`.`doctors` (`doctor_id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`treatments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`treatments` (
  `treatment_id` INT NOT NULL AUTO_INCREMENT,
  `diagnosis_id` INT NOT NULL,
  `treatment_plan` TEXT NULL DEFAULT NULL,
  `start_date` DATE NULL DEFAULT NULL,
  `end_date` DATE NULL DEFAULT NULL,
  `status` ENUM('Planned', 'In Progress', 'Completed', 'Cancelled') NULL DEFAULT 'Planned',
  PRIMARY KEY (`treatment_id`),
  INDEX `idx_treatment_diagnosis` (`diagnosis_id` ASC) VISIBLE,
  INDEX `idx_treatment_dates` (`start_date` ASC, `end_date` ASC) VISIBLE,
  CONSTRAINT `treatments_ibfk_1`
    FOREIGN KEY (`diagnosis_id`)
    REFERENCES `healthcare_crm`.`diagnosis` (`diagnosis_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `healthcare_crm`.`user_roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`user_roles` (
  `user_role_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NULL DEFAULT NULL,
  `role_id` INT NULL DEFAULT NULL,
  `assigned_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_role_id`),
  UNIQUE INDEX `unique_user_role` (`user_id` ASC, `role_id` ASC) VISIBLE,
  INDEX `role_id` (`role_id` ASC) VISIBLE,
  CONSTRAINT `user_roles_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `healthcare_crm`.`users` (`user_id`)
    ON DELETE CASCADE,
  CONSTRAINT `user_roles_ibfk_2`
    FOREIGN KEY (`role_id`)
    REFERENCES `healthcare_crm`.`roles` (`role_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `healthcare_crm` ;

-- -----------------------------------------------------
-- Placeholder table for view `healthcare_crm`.`billing_summary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`billing_summary` (`patient_id` INT, `patient_name` INT, `total_bills` INT, `total_amount_due` INT, `total_paid` INT, `total_pending` INT, `total_overdue` INT);

-- -----------------------------------------------------
-- Placeholder table for view `healthcare_crm`.`doctor_schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`doctor_schedule` (`doctor_id` INT, `doctor_name` INT, `specialization` INT, `department` INT, `available_day` INT, `start_time` INT, `end_time` INT, `appointments_scheduled` INT);

-- -----------------------------------------------------
-- Placeholder table for view `healthcare_crm`.`patient_appointment_summary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `healthcare_crm`.`patient_appointment_summary` (`patient_id` INT, `patient_name` INT, `phone` INT, `email` INT, `total_appointments` INT, `completed_appointments` INT, `cancelled_appointments` INT, `last_appointment_date` INT);

-- -----------------------------------------------------
-- procedure GetPatientMedicalHistory
-- -----------------------------------------------------

DELIMITER $$
USE `healthcare_crm`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPatientMedicalHistory`(IN patient_id_param INT)
BEGIN
    SELECT 
        mr.record_date,
        mr.summary,
        d.description as diagnosis,
        d.disease_name,
        CONCAT(doc.first_name, ' ', doc.last_name) as doctor_name,
        doc.specialization
    FROM Medical_Records mr
    LEFT JOIN Diagnosis d ON mr.patient_id = d.patient_id
    LEFT JOIN Doctors doc ON d.doctor_id = doc.doctor_id
    WHERE mr.patient_id = patient_id_param
    ORDER BY mr.record_date DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ProcessPayment
-- -----------------------------------------------------

DELIMITER $$
USE `healthcare_crm`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcessPayment`(
    IN p_billing_id INT,
    IN p_payment_method VARCHAR(50),
    IN p_amount_paid DECIMAL(10,2),
    IN p_transaction_id VARCHAR(100)
)
BEGIN
    DECLARE bill_amount DECIMAL(10,2);
    DECLARE current_status VARCHAR(50);
    
    -- Get current bill details
    SELECT amount_due, status INTO bill_amount, current_status
    FROM Billing WHERE billing_id = p_billing_id;
    
    IF current_status = 'Paid' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bill already paid';
    ELSEIF p_amount_paid < bill_amount THEN
        -- Partial payment
        INSERT INTO Payments (billing_id, payment_date, payment_method, amount_paid, transaction_id)
        VALUES (p_billing_id, CURDATE(), p_payment_method, p_amount_paid, p_transaction_id);
        
        UPDATE Billing 
        SET amount_due = amount_due - p_amount_paid,
            status = CASE WHEN (amount_due - p_amount_paid) <= 0 THEN 'Paid' ELSE 'Pending' END
        WHERE billing_id = p_billing_id;
        
        SELECT 'Partial payment processed' AS message;
    ELSE
        -- Full payment
        INSERT INTO Payments (billing_id, payment_date, payment_method, amount_paid, transaction_id)
        VALUES (p_billing_id, CURDATE(), p_payment_method, p_amount_paid, p_transaction_id);
        
        UPDATE Billing 
        SET amount_due = 0, status = 'Paid'
        WHERE billing_id = p_billing_id;
        
        SELECT 'Payment processed successfully' AS message;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ScheduleAppointment
-- -----------------------------------------------------

DELIMITER $$
USE `healthcare_crm`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ScheduleAppointment`(
    IN p_patient_id INT,
    IN p_doctor_id INT,
    IN p_appointment_date DATE,
    IN p_appointment_time TIME,
    IN p_clinic_id INT
)
BEGIN
    DECLARE appointment_exists INT DEFAULT 0;
    DECLARE doctor_available INT DEFAULT 0;
    
    -- Check if appointment slot is already taken
    SELECT COUNT(*) INTO appointment_exists
    FROM Appointments 
    WHERE doctor_id = p_doctor_id 
    AND appointment_date = p_appointment_date 
    AND appointment_time = p_appointment_time
    AND status = 'Scheduled';
    
    -- Check if doctor is available on that day
    SELECT COUNT(*) INTO doctor_available
    FROM Doctor_Availability da
    WHERE da.doctor_id = p_doctor_id
    AND da.available_day = DAYNAME(p_appointment_date)
    AND p_appointment_time BETWEEN da.start_time AND da.end_time;
    
    IF appointment_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment slot already taken';
    ELSEIF doctor_available = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Doctor not available at this time';
    ELSE
        INSERT INTO Appointments (patient_id, doctor_id, appointment_date, appointment_time, clinic_id, status)
        VALUES (p_patient_id, p_doctor_id, p_appointment_date, p_appointment_time, p_clinic_id, 'Scheduled');
        SELECT 'Appointment scheduled successfully' AS message;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `healthcare_crm`.`billing_summary`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `healthcare_crm`.`billing_summary`;
USE `healthcare_crm`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `healthcare_crm`.`billing_summary` AS select `p`.`patient_id` AS `patient_id`,concat(`p`.`first_name`,' ',`p`.`last_name`) AS `patient_name`,count(`b`.`billing_id`) AS `total_bills`,sum(`b`.`amount_due`) AS `total_amount_due`,sum((case when (`b`.`status` = 'Paid') then `b`.`amount_due` else 0 end)) AS `total_paid`,sum((case when (`b`.`status` = 'Pending') then `b`.`amount_due` else 0 end)) AS `total_pending`,sum((case when (`b`.`status` = 'Overdue') then `b`.`amount_due` else 0 end)) AS `total_overdue` from (`healthcare_crm`.`patients` `p` left join `healthcare_crm`.`billing` `b` on((`p`.`patient_id` = `b`.`patient_id`))) group by `p`.`patient_id`,`p`.`first_name`,`p`.`last_name`;

-- -----------------------------------------------------
-- View `healthcare_crm`.`doctor_schedule`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `healthcare_crm`.`doctor_schedule`;
USE `healthcare_crm`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `healthcare_crm`.`doctor_schedule` AS select `d`.`doctor_id` AS `doctor_id`,concat(`d`.`first_name`,' ',`d`.`last_name`) AS `doctor_name`,`d`.`specialization` AS `specialization`,`dept`.`name` AS `department`,`da`.`available_day` AS `available_day`,`da`.`start_time` AS `start_time`,`da`.`end_time` AS `end_time`,count(`a`.`appointment_id`) AS `appointments_scheduled` from (((`healthcare_crm`.`doctors` `d` join `healthcare_crm`.`departments` `dept` on((`d`.`department_id` = `dept`.`department_id`))) left join `healthcare_crm`.`doctor_availability` `da` on((`d`.`doctor_id` = `da`.`doctor_id`))) left join `healthcare_crm`.`appointments` `a` on(((`d`.`doctor_id` = `a`.`doctor_id`) and (`a`.`appointment_date` >= curdate()) and (`a`.`status` = 'Scheduled')))) group by `d`.`doctor_id`,`d`.`first_name`,`d`.`last_name`,`d`.`specialization`,`dept`.`name`,`da`.`available_day`,`da`.`start_time`,`da`.`end_time`;

-- -----------------------------------------------------
-- View `healthcare_crm`.`patient_appointment_summary`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `healthcare_crm`.`patient_appointment_summary`;
USE `healthcare_crm`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `healthcare_crm`.`patient_appointment_summary` AS select `p`.`patient_id` AS `patient_id`,concat(`p`.`first_name`,' ',`p`.`last_name`) AS `patient_name`,`p`.`phone` AS `phone`,`p`.`email` AS `email`,count(`a`.`appointment_id`) AS `total_appointments`,count((case when (`a`.`status` = 'Completed') then 1 end)) AS `completed_appointments`,count((case when (`a`.`status` = 'Cancelled') then 1 end)) AS `cancelled_appointments`,max(`a`.`appointment_date`) AS `last_appointment_date` from (`healthcare_crm`.`patients` `p` left join `healthcare_crm`.`appointments` `a` on((`p`.`patient_id` = `a`.`patient_id`))) group by `p`.`patient_id`,`p`.`first_name`,`p`.`last_name`,`p`.`phone`,`p`.`email`;
USE `healthcare_crm`;

DELIMITER $$
USE `healthcare_crm`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `healthcare_crm`.`check_doctor_availability`
BEFORE INSERT ON `healthcare_crm`.`appointments`
FOR EACH ROW
BEGIN
    DECLARE available_count INT DEFAULT 0;
    
    SELECT COUNT(*) INTO available_count
    FROM Doctor_Availability da
    WHERE da.doctor_id = NEW.doctor_id
    AND da.available_day = DAYNAME(NEW.appointment_date)
    AND NEW.appointment_time BETWEEN da.start_time AND da.end_time;
    
    IF available_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Doctor not available at scheduled time';
    END IF;
END$$

USE `healthcare_crm`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `healthcare_crm`.`create_invoice_after_billing`
AFTER INSERT ON `healthcare_crm`.`billing`
FOR EACH ROW
BEGIN
    DECLARE tax_rate DECIMAL(5,2) DEFAULT 0.18; -- 18% tax rate
    DECLARE tax_amt DECIMAL(10,2);
    DECLARE net_amt DECIMAL(10,2);
    
    SET tax_amt = NEW.amount_due * tax_rate;
    SET net_amt = NEW.amount_due + tax_amt;
    
    INSERT INTO Invoices (billing_id, invoice_date, total_amount, tax_amount, net_amount)
    VALUES (NEW.billing_id, CURDATE(), NEW.amount_due, tax_amt, net_amt);
END$$

USE `healthcare_crm`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `healthcare_crm`.`update_billing_after_payment`
AFTER INSERT ON `healthcare_crm`.`payments`
FOR EACH ROW
BEGIN
    DECLARE total_paid DECIMAL(10,2);
    DECLARE bill_amount DECIMAL(10,2);
    
    SELECT SUM(amount_paid) INTO total_paid
    FROM Payments
    WHERE billing_id = NEW.billing_id;
    
    SELECT amount_due INTO bill_amount
    FROM Billing
    WHERE billing_id = NEW.billing_id;
    
    UPDATE Billing
    SET status = CASE 
        WHEN total_paid >= bill_amount THEN 'Paid'
        ELSE 'Pending'
    END
    WHERE billing_id = NEW.billing_id;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
