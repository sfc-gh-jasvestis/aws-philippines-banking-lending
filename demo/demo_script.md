# Philippines Bank Lending - Loan Book Collections

**Philippines - Bank Lending**
Use case: Loan-book repayment risk and collections for a bank

> Loan-book repayment monitoring for 200 retail and MSME borrowers of a fictional Philippine bank across 5 cities: dynamic tables, a holdout-evaluated missed-instalment classifier, a missed-instalment forecast, deposit-account inflow anomalies and grounded AI answers.

## Why Snowflake

- **Dynamic tables** reconcile instalments due, missed instalments, PAR 30 and promise-to-pay from RAW borrower data, with checks in `run_core.py`
- **Missed-instalment classification** gives a holdout-evaluated next-14-day probability per borrower
- **Missed-instalment forecast** projects 14 days of portfolio-wide missed instalments with prediction intervals, for collection-team staffing
- **Grounded AI**: the Cortex Agent (Analyst over a semantic view, plus Search over playbooks) shows its SQL and playbook citations
- **Live repayments**: a native simulator (Snowflake only) or Firehose, S3 and Snowpipe (AWS build), then an alert and email

## What is built

| | |
|---|---|
| Dimension table | `RAW.BORROWERS` (200 rows) |
| Fact table | `RAW.LOAN_DAILY` (18,000 borrower-days, 90 days) |
| Curated layer | `CURATED.KPI_SUMMARY`, `PERFORMANCE_SUMMARY`, `PRODUCT_SUMMARY`, `TREND_ANALYSIS` |
| ML | `ML.MISS_RISK_SCORES`, `ML.MISS_RISK_HOLDOUT_METRICS`, `ML.MISSED_FORECAST`, `ML.DEPOSIT_INFLOW_ANOMALIES` |

Cities: Quezon City, Cebu City, Davao City, Iloilo City, Cagayan de Oro.
Loan products: Salary Loan, Personal Loan, MSME Credit Line, Auto Loan, Agri-Fishery Loan.

## KPI cards (live from `CURATED.KPI_SUMMARY`; no fallback values)

| Card | Value from the seeded data |
|---|---|
| On-time Repayment Rate | 83.3% |
| Instalments Due | 2,062 |
| Missed Instalments | 345 |
| PAR 30 | 6.7% |
| Outstanding (PHP mn) | 34.3 |
| Promise-to-Pay Rate | 43.8% |
| Borrowers | 200 |
| Document Coverage | 59.8% |
| Documents Pending | 88 |

Values are synthetic. A rebuild reproduces them because the data is HASH-seeded; dates are relative to the build day.

## Demo flow

1. Executive Cockpit: KPIs, daily instalments due against missed, instalments by product, borrower table
2. Predictive: holdout metrics, risk bands, 14-day missed-instalment forecast, deposit-account inflow drops
3. Collections: promise-to-pay rate, document coverage and pending documents, internal credit score against missed instalments, then generate the action memo
4. Live Repayments: run `CALL APP.SIMULATE_REPAYMENTS(20)` (Snowflake only) or `python aws/publish_repayments.py --count 20` (AWS build). Then run `EXECUTE ALERT APP.LIVE_REPAYMENT_ALERT` and show the alert log and email.
5. Ask AI: the Cortex Agent answers metric questions through the semantic view and cites playbooks from Cortex Search. The SQL is shown.
6. QuickSight (AWS build): the same Snowflake tables through DIRECT_QUERY
7. Architecture: both builds side by side

## Talking points

- About one instalment in six is missed (83.3% on time). PAR 30 is 6.7% of outstanding, concentrated in a small cohort of borrowers who stopped paying.
- Agri-Fishery Loan carries the highest PAR 30 (10.7%) and the lowest on-time rate (77.7%), which fits a seasonal cash-flow product. Davao City has the lowest on-time rate of the five cities (79.9%).
- Deposit-account inflows fall before missed instalments in this data, which is why the inflow trend is a model feature and an anomaly signal.
- The risk model is evaluated on a time-based holdout: precision 0.37 and recall 0.26 at 0.5, against a 0.24 base rate. Present it as triage for collectors, not a credit decision.
- Borrowers already more than 30 days past due are excluded from training and evaluation, because their next missed instalment is not a prediction.

## Business impact

Use only the sourced references in `README.md` (Business Impact).
