-- ============================================================================
-- 08_AGENT.SQL — Cortex Agent for Digital Lending & Credit Scoring Platform
-- ============================================================================
USE DATABASE DIGITAL_LENDING;
USE SCHEMA APP;

CREATE OR REPLACE CORTEX AGENT APP.LENDING_INTELLIGENCE_AGENT
  COMMENT = 'Digital Lending & Credit Scoring Platform AI Assistant'
  MODEL = 'claude-opus-4-8'
  TOOLS = (
    SEMANTIC_VIEW_TOOL(SEMANTIC_VIEW => 'DIGITAL_LENDING.APP.LENDING_ANALYTICS'),    CORTEX_SEARCH_TOOL(CORTEX_SEARCH_SERVICE => 'DIGITAL_LENDING.SEARCH.LENDING_POLICY_SEARCH', TOOL_DESCRIPTION => 'Search documents for Banking & Insurance information')
  )
  SYSTEM_PROMPT = 'You are the Digital Lending Intelligence Agent for a Philippine bank processing 450K loan applications annually with ₱48B total portfolio.';
