# Demo Script: Digital Lending & Credit Scoring Platform
## ~4-Minute Recorded Walkthrough
**Format**: Screen recording with voiceover
**Target**: Customer meeting / booth loop / social share
**Narrative**: "Snowflake consolidates applicant data into Dynamic Table 360 views, scores credit risk with ML.CLASSIFICATION replacing SageMaker, and provides end-to-end lending intelligence from application to disbursement"
**Demo Mode**: Open app with `?demo=true` for presenter notes

---

## Two Personas

| Persona | Role | Tool | What they care about |
|---|---|---|---|
| **Victoria Isabel Zobel-Ayala** | Head of Consumer Lending | React App (SPCS) | Portfolio quality, approval rates, time-to-decision, NPL ratios, regulatory capital |
| **Benedict Luis Sy Jr.** | Credit Risk Modeler | Amazon QuickSight | Model accuracy, score calibration, feature drift, segment performance, bias monitoring |

---

## What's Built

| Layer | Component | Detail |
|---|---|---|
| **RAW** | 6 tables | APPLICATIONS (450000), BUREAU_DATA (380000), BANK_STATEMENTS (1200000), LOAN_PORTFOLIO (285000), COLLECTIONS (42000), EMPLOYER_DATA (85000) |
| **CURATED** | 4 Dynamic Tables | APPLICANT_360, PORTFOLIO_HEALTH, CREDIT_FEATURES, DECISION_METRICS |
| **ML** | ML.CLASSIFICATION + ML.CLASSIFICATION | Forecasting + anomaly detection |
| **AI** | COMPLETE, AI_CLASSIFY | Classification + extraction |
| **Search** | Cortex Search | 85000 documents indexed |
| **Agent** | LENDING_INTELLIGENCE_AGENT | Semantic View + Search tools |


---

## The Story

Philippine digital lending exploded in 2023 — growing 45% as GCash, Maya, and online banks made borrowing accessible. A Philippine universal bank processes 450,000 applications annually but struggles with fragmented data: credit bureau in one system, bank statements in another, employment verification in a third. Snowflake's Dynamic Tables build applicant 360 profiles in real-time, enabling ML-powered credit decisions in 4 hours instead of 3 days.

---

## Script

### [0:00–0:45] EXECUTIVE COCKPIT

**Show**: Executive Cockpit tab

> "₱48 billion total lending portfolio — 285,000 active loans across personal, auto, and home."

**Action**: Point at ₱48B portfolio KPI

### [0:45–1:30] CREDIT DECISIONING

**Show**: Credit Decisioning tab

> "ML.CLASSIFICATION trained on 285K historical loans — KS statistic 0.48 (strong model)."

**Action**: Show model performance metrics (KS, AUC, Gini)

### [1:30–2:15] PORTFOLIO HEALTH

**Show**: Portfolio Health tab

> "Vintage analysis: Q1 2024 cohort performing worst — approval criteria too loose during campaign."

**Action**: Show vintage analysis chart

### [2:15–3:00] ASK AI

**Show**: Ask AI tab

> "Victoria asks: 'What's driving the NPL increase in personal loans?'"

**Action**: Type: 'What is driving personal loan NPL increase?'

### [3:00–3:45] ARCHITECTURE & DATA

**Show**: Architecture & Data tab

> "Multi-source data → Dynamic Tables (applicant 360) → ML.CLASSIFICATION → real-time decisions."

**Action**: Walk through architecture diagram


---

## Key Demo Differentiators

1. **Dynamic Tables for applicant 360** — Real-time unified profile from 4 data sources — always fresh, no ETL
2. **ML.CLASSIFICATION for credit scoring** — Native credit model replacing SageMaker — SQL-based, no ML ops
3. **AI_CLASSIFY on bank statements** — Automatic transaction categorization reveals true income/expenses
4. **Collection priority scoring** — Second ML model for delinquent account prioritization
5. **Philippine digital lending context** — GCash/Maya era with CIC bureau data and BSP requirements


---

## Demo Prep Checklist

### Data Verification
- [ ] `SELECT COUNT(*) FROM DIGITAL_LENDING.RAW.APPLICATIONS` → 450000
- [ ] `SELECT COUNT(*) FROM DIGITAL_LENDING.RAW.BANK_STATEMENTS` → 1200000
- [ ] `SELECT COUNT(*) FROM DIGITAL_LENDING.CURATED.APPLICANT_360` → 450000

### ML Model Verification
- [ ] `SELECT COUNT(*) FROM DIGITAL_LENDING.ML.CREDIT_SCORER_RESULTS` → >0
- [ ] `SELECT COUNT(*) FROM DIGITAL_LENDING.ML.COLLECTION_PRIORITY_RESULTS` → 42000

### AI/Agent Verification
- [ ] `SELECT COUNT(*) FROM DIGITAL_LENDING.AI.BANK_STATEMENT_CLASSIFICATION` → 1200000

