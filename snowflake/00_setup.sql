-- Generated from generator/demo_specs/aws-philippines-banking-lending.json
-- Regenerate with: python3 generator/gen_repo_docs.py aws-philippines-banking-lending
-- This is the schema that is actually deployed for PH_BANKING_LENDING.

-- PH_BANKING_LENDING  (Digital Lending & Credit Scoring Platform)
-- generated from generator/demo_specs/aws-philippines-banking-lending.json - do not hand-edit
CREATE DATABASE IF NOT EXISTS PH_BANKING_LENDING;
CREATE SCHEMA IF NOT EXISTS PH_BANKING_LENDING.RAW;
CREATE SCHEMA IF NOT EXISTS PH_BANKING_LENDING.CURATED;
CREATE SCHEMA IF NOT EXISTS PH_BANKING_LENDING.APP;
USE DATABASE PH_BANKING_LENDING;

-- 5 real regions; entity names carry their region so the two always agree
