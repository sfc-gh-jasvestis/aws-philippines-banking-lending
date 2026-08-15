-- ============================================================================
-- 03_STAGING.SQL — Generate synthetic data for Digital Lending & Credit Scoring Platform
-- Country: PHILIPPINES | Currency: PHP
-- ============================================================================
USE DATABASE DIGITAL_LENDING;
USE SCHEMA RAW;

-- Data generation scripts are demo-specific.
-- See the handcrafted SQL in the aws-malaysia-semiconductor-yield demo for
-- the full pattern: GENERATOR + UNIFORM + LATERAL for distribution,
-- Cortex Complete for text generation, engineered key demo numbers.

-- Target row counts:
-- APPLICATIONS: 450,000 rows — 12 months of loan applications with demographics
-- BUREAU_DATA: 380,000 rows — Credit bureau records (CIC, TransUnion)
-- BANK_STATEMENTS: 1,200,000 rows — Uploaded bank statement data (6 months per applicant)
-- LOAN_PORTFOLIO: 285,000 rows — Active and closed loans with repayment history
-- COLLECTIONS: 42,000 rows — Delinquent accounts with collection activity
-- EMPLOYER_DATA: 85,000 rows — Verified employment data from DOLE/SSS
