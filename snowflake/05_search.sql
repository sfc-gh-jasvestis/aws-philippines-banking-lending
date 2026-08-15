-- ============================================================================
-- 05_SEARCH.SQL — Cortex Search for Digital Lending & Credit Scoring Platform
-- ============================================================================
USE DATABASE DIGITAL_LENDING;
USE SCHEMA SEARCH;

CREATE OR REPLACE CORTEX SEARCH SERVICE SEARCH.LENDING_POLICY_SEARCH
  ON COMPANY_PROFILE
  ATTRIBUTES INDUSTRY, SIZE_CATEGORY, STABILITY_RATING
  WAREHOUSE = LENDING_WH
  TARGET_LAG = '1 hour'
AS (
  SELECT * FROM RAW.EMPLOYER_DATA
);
