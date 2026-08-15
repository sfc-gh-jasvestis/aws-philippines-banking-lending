-- ============================================================================
-- 07_SEMANTIC_VIEW.SQL — Semantic View for Digital Lending & Credit Scoring Platform
-- ============================================================================
USE DATABASE DIGITAL_LENDING;
USE SCHEMA APP;

CREATE OR REPLACE SEMANTIC VIEW APP.LENDING_ANALYTICS
  COMMENT = 'Digital lending, credit scoring, portfolio health, and collections analytics'
AS
  TABLES (
    CURATED.APPLICANT_360 AS applicant_360,CURATED.PORTFOLIO_HEALTH AS portfolio_health,CURATED.CREDIT_FEATURES AS credit_features,CURATED.DECISION_METRICS AS decision_metrics
  );
