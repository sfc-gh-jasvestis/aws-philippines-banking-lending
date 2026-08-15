-- ============================================================================
-- 04_DYNAMIC_TABLES.SQL — Curated layer for Digital Lending & Credit Scoring Platform
-- ============================================================================
USE DATABASE DIGITAL_LENDING;
USE SCHEMA CURATED;

-- APPLICANT_360: Unified applicant profile combining bureau, bank statements, and employment
-- Source: APPLICATIONS, BUREAU_DATA, BANK_STATEMENTS, EMPLOYER_DATA
CREATE OR REPLACE DYNAMIC TABLE CURATED.APPLICANT_360
  TARGET_LAG = '5 minutes'
  WAREHOUSE = LENDING_WH
AS
SELECT * FROM RAW.APPLICATIONS;
-- TODO: Replace with actual join/aggregation logic per demo

-- PORTFOLIO_HEALTH: Portfolio quality metrics (NPL, PAR, vintage analysis)
-- Source: LOAN_PORTFOLIO, COLLECTIONS
CREATE OR REPLACE DYNAMIC TABLE CURATED.PORTFOLIO_HEALTH
  TARGET_LAG = '5 minutes'
  WAREHOUSE = LENDING_WH
AS
SELECT * FROM RAW.LOAN_PORTFOLIO;
-- TODO: Replace with actual join/aggregation logic per demo

-- CREDIT_FEATURES: Engineered features for credit scoring model
-- Source: APPLICANT_360, BUREAU_DATA, BANK_STATEMENTS
CREATE OR REPLACE DYNAMIC TABLE CURATED.CREDIT_FEATURES
  TARGET_LAG = '5 minutes'
  WAREHOUSE = LENDING_WH
AS
SELECT * FROM RAW.APPLICANT_360;
-- TODO: Replace with actual join/aggregation logic per demo

-- DECISION_METRICS: Lending decision KPIs (approval rate, time-to-decision, conversion)
-- Source: APPLICATIONS, LOAN_PORTFOLIO
CREATE OR REPLACE DYNAMIC TABLE CURATED.DECISION_METRICS
  TARGET_LAG = '5 minutes'
  WAREHOUSE = LENDING_WH
AS
SELECT * FROM RAW.APPLICATIONS;
-- TODO: Replace with actual join/aggregation logic per demo

