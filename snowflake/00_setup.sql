-- ============================================================================
-- Digital Lending & Credit Scoring Platform
-- Philippine digital lending grew 45% in 2023 — Snowflake builds applicant 360 profiles with Dynamic Tables, scores creditworthiness with ML.CLASSIFICATION, and enables real-time lending decisions at scale.
-- ============================================================================
USE ROLE ACCOUNTADMIN;
CREATE DATABASE IF NOT EXISTS DIGITAL_LENDING;
CREATE WAREHOUSE IF NOT EXISTS LENDING_WH WAREHOUSE_SIZE = 'MEDIUM' AUTO_SUSPEND = 120 AUTO_RESUME = TRUE;
USE DATABASE DIGITAL_LENDING;
CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS CURATED;
CREATE SCHEMA IF NOT EXISTS ML;
CREATE SCHEMA IF NOT EXISTS AI;
CREATE SCHEMA IF NOT EXISTS SEARCH;
CREATE SCHEMA IF NOT EXISTS APP;

USE WAREHOUSE LENDING_WH;
