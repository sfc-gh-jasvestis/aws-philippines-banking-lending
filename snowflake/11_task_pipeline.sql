-- ============================================================================
-- 11_TASK_PIPELINE.SQL — Task DAG for Digital Lending & Credit Scoring Platform
-- ============================================================================
USE DATABASE DIGITAL_LENDING;
USE SCHEMA APP;

CREATE OR REPLACE TASK APP.TASK_BUILD_360
  WAREHOUSE = LENDING_WH
  SCHEDULE = 'USING CRON 0 */4 * * * UTC'
  COMMENT = 'Refresh applicant 360 profiles with latest data'
AS
  SELECT 1; -- Replace with actual refresh logic

CREATE OR REPLACE TASK APP.TASK_SCORE_APPLICANTS
  WAREHOUSE = LENDING_WH
  AFTER APP.TASK_BUILD_360
  COMMENT = 'Score pending applications with credit model'
AS
  SELECT 1; -- Replace with actual refresh logic

CREATE OR REPLACE TASK APP.TASK_MONITOR_PORTFOLIO
  WAREHOUSE = LENDING_WH
  SCHEDULE = 'USING CRON 0 6 * * * UTC'
  COMMENT = 'Refresh portfolio health metrics and collection priorities'
AS
  SELECT 1; -- Replace with actual refresh logic

ALTER TASK APP.TASK_MONITOR_PORTFOLIO RESUME;
ALTER TASK APP.TASK_SCORE_APPLICANTS RESUME;
ALTER TASK APP.TASK_BUILD_360 RESUME;
