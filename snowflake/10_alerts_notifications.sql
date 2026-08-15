-- ============================================================================
-- 10_ALERTS_NOTIFICATIONS.SQL — Alerts for Digital Lending & Credit Scoring Platform
-- ============================================================================
USE DATABASE DIGITAL_LENDING;
USE SCHEMA APP;

-- Notification integration (email)
CREATE OR REPLACE NOTIFICATION INTEGRATION aws_philippines_banking_lending_EMAIL_INT
  TYPE = EMAIL
  ENABLED = TRUE
  ALLOWED_RECIPIENTS = ('jonathan.asvestis@snowflake.com');

-- Alert: NPL_SPIKE_ALERT
CREATE OR REPLACE ALERT APP.NPL_SPIKE_ALERT
  WAREHOUSE = LENDING_WH
  SCHEDULE = '5 MINUTE'
  COMMENT = 'NPL ratio exceeding threshold'
IF (EXISTS (
  SELECT 1 FROM CURATED.APPLICANT_360
  WHERE 1=1 -- Condition: NPL_RATIO > 5% for any product segment
))
THEN
  CALL SYSTEM$SEND_EMAIL(
    'aws_philippines_banking_lending_EMAIL_INT',
    'jonathan.asvestis@snowflake.com',
    '[ALERT] Digital Lending & Credit Scoring Platform: NPL ratio exceeding threshold',
    'NPL ratio exceeding threshold'
  );

ALTER ALERT APP.NPL_SPIKE_ALERT RESUME;

-- Alert: MODEL_DRIFT_ALERT
CREATE OR REPLACE ALERT APP.MODEL_DRIFT_ALERT
  WAREHOUSE = LENDING_WH
  SCHEDULE = '5 MINUTE'
  COMMENT = 'Credit model performance degrading'
IF (EXISTS (
  SELECT 1 FROM CURATED.APPLICANT_360
  WHERE 1=1 -- Condition: KS_STATISTIC_CHANGE > 0.05 quarter-over-quarter
))
THEN
  CALL SYSTEM$SEND_EMAIL(
    'aws_philippines_banking_lending_EMAIL_INT',
    'jonathan.asvestis@snowflake.com',
    '[ALERT] Digital Lending & Credit Scoring Platform: Credit model performance degrading',
    'Credit model performance degrading'
  );

ALTER ALERT APP.MODEL_DRIFT_ALERT RESUME;

