# Digital Lending & Credit Scoring Platform

**Philippines - Banking & Insurance**
Use case: Digital Lending

> Philippine digital lending grew 45% in 2023 — Snowflake builds applicant 360 profiles with Dynamic Tables, scores creditworthiness with ML.CLASSIFICATION, and enables real-time lending decisions at scale.

## Why Snowflake

Snowflake consolidates applicant data into Dynamic Table 360 views, scores credit risk with ML.CLASSIFICATION replacing SageMaker, and provides end-to-end lending intelligence from application to disbursement

- **Dynamic Tables for applicant 360** - Real-time unified profile from 4 data sources — always fresh, no ETL
- **ML.CLASSIFICATION for credit scoring** - Native credit model replacing SageMaker — SQL-based, no ML ops
- **AI_CLASSIFY on bank statements** - Automatic transaction categorization reveals true income/expenses
- **Collection priority scoring** - Second ML model for delinquent account prioritization
- **Philippine digital lending context** - GCash/Maya era with CIC bureau data and BSP requirements

## What is deployed

| | |
|---|---|
| Database | `PH_BANKING_LENDING` |
| Service | `PH_BANKING_LENDING_APP` |
| Compute pool | `SEA_DEMOS_PHILIPPINES_POOL` |
| Dimension table | `RAW.COLLECTIONS` (20 rows) |
| Fact table | `RAW.BANK_STATEMENTS` (250,000 rows, 90 days) |
| Curated layer | `CURATED.PERFORMANCE_SUMMARY`, `CURATED.TREND_ANALYSIS`, `CURATED.KPI_SUMMARY` |
| Currency | PHP (₱) |

Regions in play: Metro Manila, Cebu, Davao, Pampanga, Iloilo
Segments: Salary Loan, SME Loan, Motorcycle Loan, Credit Card

Dynamic tables are created suspended and refreshed on demand:

```bash
./refresh_demo_data.sh PH_BANKING_LENDING
```

## KPI cards

Every card below is served live from `CURATED.KPI_SUMMARY`. The app keeps the
original literal as a fallback, so it still renders if Snowflake is unreachable.

| Card | Value | Backed by |
|---|---|---|
| Loan Portfolio | `₱284B` | total across Collections |
| NPL Ratio | `3.2%` | average per event |
| Disbursements (MTD) | `₱12.4B` | total across Collections |
| Borrowers Active | `1.8M` | total across Collections |
| Expected Loss | `₱4.8B` | total across Collections |
| Migration to Stage 2 | `+2.4%` | average per event |
| Collection Rate | `94%` | average per event |


## Demo flow

1. Executive Cockpit
2. Credit Decisioning
3. Portfolio Health
4. Ask AI
5. Architecture & Data

## Talking points

- **₱48B** - total lending portfolio
- **450,000** - loan applications processed annually
- **4.2 hours** - average time-to-decision for digital applications
- **3.8%** - overall NPL ratio (below 5% threshold)
- **0.48 KS** - credit scoring model discrimination power
- **68%** - digital channel approval rate

## Business impact

- Philippine digital lending grew 45% in 2023 driven by fintech and online banks (BSP)
- AI-powered credit scoring improves lending decisions by 20-30% vs traditional scorecards (McKinsey Banking)
- Real-time data integration reduces time-to-decision by 70-90% (Accenture Banking)
- Philippine banking NPL ratio was 3.4% in 2023 — digital lenders averaging 4-6% (BSP)

---
Generated from `generator/demo_specs/aws-philippines-banking-lending.json`. Do not hand-edit: run
`python3 generator/gen_repo_docs.py aws-philippines-banking-lending` instead.
