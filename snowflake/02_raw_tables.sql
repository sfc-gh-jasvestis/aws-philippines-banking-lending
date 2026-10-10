-- Synthetic borrower-day observations for the consumer and MSME loan book of a fictional Philippine bank.
-- Nothing is seeded as a prediction. Randomness is HASH-seeded, so every rebuild
-- is reproducible: per-borrower cash-flow stress cycles that show up first in
-- deposit-account inflows and then in missed instalments, a small default cohort,
-- weekly or fortnightly instalment schedules, a regional income shock, and
-- collection contacts.
USE DATABASE IDENTIFIER($DEMO_DB);
USE SCHEMA RAW;
USE WAREHOUSE IDENTIFIER($DEMO_WH);

CREATE TABLE RAW.BORROWERS AS
WITH borrowers AS (
  SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS BORROWER_INDEX
  FROM TABLE(GENERATOR(ROWCOUNT => 200))
), draws AS (
  SELECT BORROWER_INDEX,
         MOD(ABS(HASH(BORROWER_INDEX, 'phbank_score')), 1000000) / 1e6 AS U_SCORE,
         MOD(ABS(HASH(BORROWER_INDEX, 'phbank_book')), 1000000) / 1e6 AS U_BOOK,
         MOD(ABS(HASH(BORROWER_INDEX, 'phbank_size')), 1000000) / 1e6 AS U_SIZE,
         MOD(ABS(HASH(BORROWER_INDEX, 'phbank_interval')), 1000000) / 1e6 AS U_INTERVAL,
         MOD(ABS(HASH(BORROWER_INDEX, 'phbank_rate')), 1000000) / 1e6 AS U_RATE,
         MOD(ABS(HASH(BORROWER_INDEX, 'phbank_phase')), 1000000) / 1e6 AS U_PHASE,
         MOD(ABS(HASH(BORROWER_INDEX, 'phbank_period')), 1000000) / 1e6 AS U_PERIOD,
         MOD(ABS(HASH(BORROWER_INDEX, 'phbank_wallet')), 1000000) / 1e6 AS U_WALLET,
         MOD(ABS(HASH(BORROWER_INDEX, 'phbank_default')), 1000000) / 1e6 AS U_DEFAULT,
         MOD(ABS(HASH(BORROWER_INDEX, 'phbank_onset')), 1000000) / 1e6 AS U_ONSET
  FROM borrowers
)
SELECT 'PHB-' || LPAD(BORROWER_INDEX::VARCHAR, 4, '0') AS ID,
       'Synthetic borrower ' || LPAD(BORROWER_INDEX::VARCHAR, 4, '0') AS NAME,
       -- Deterministic spread (5 and 8 are coprime): every city and product is present.
       CASE MOD(BORROWER_INDEX, 5) WHEN 0 THEN 'Quezon City' WHEN 1 THEN 'Cebu City'
            WHEN 2 THEN 'Davao City' WHEN 3 THEN 'Iloilo City' ELSE 'Cagayan de Oro' END AS REGION,
       CASE MOD(BORROWER_INDEX, 8) WHEN 0 THEN 'Salary Loan' WHEN 1 THEN 'Salary Loan' WHEN 2 THEN 'Salary Loan'
            WHEN 3 THEN 'Personal Loan' WHEN 4 THEN 'Personal Loan' WHEN 5 THEN 'MSME Credit Line'
            WHEN 6 THEN 'Auto Loan' ELSE 'Agri-Fishery Loan' END AS CATEGORY,
       BORROWER_INDEX,
       -- Synthetic internal credit score (0-100): deposit, payroll and bill-payment history.
       ROUND(35 + U_SCORE * 60, 0) AS CREDIT_SCORE,
       1 + FLOOR(U_BOOK * 24) AS MONTHS_ON_BOOK,
       ROUND(CASE MOD(BORROWER_INDEX, 8) WHEN 0 THEN 60000 WHEN 1 THEN 60000 WHEN 2 THEN 60000
                  WHEN 3 THEN 180000 WHEN 4 THEN 180000 WHEN 5 THEN 750000
                  WHEN 6 THEN 950000 ELSE 250000 END * (0.6 + 0.8 * U_SIZE), -3) AS PRINCIPAL_PHP,
       7 * (1 + FLOOR(U_INTERVAL * 2)) AS INSTALMENT_INTERVAL_DAYS,
       -- Base probability of missing an instalment: weaker scores miss more; ~12% are chronic.
       (0.02 + (1 - U_SCORE) * 0.10) * IFF(U_RATE > 0.88, 2.5, 1) AS BASE_MISS_RATE,
       U_PHASE AS STRESS_PHASE,
       30 + FLOOR(U_PERIOD * 30) AS STRESS_PERIOD_DAYS,
       ROUND(CASE MOD(BORROWER_INDEX, 8) WHEN 0 THEN 2400 WHEN 1 THEN 2400 WHEN 2 THEN 2400
                  WHEN 3 THEN 3800 WHEN 4 THEN 3800 WHEN 5 THEN 21000
                  WHEN 6 THEN 9500 ELSE 6200 END * (0.7 + 0.6 * U_WALLET), -1) AS BASE_DEPOSIT_INFLOW_PHP,
       -- About 7% of borrowers (more among weak scores) stop paying from a seeded onset day.
       IFF(U_DEFAULT < 0.03 + 0.08 * (1 - U_SCORE), 15 + FLOOR(U_ONSET * 65), NULL) AS DEFAULT_ONSET_DAY,
       'Active' AS STATUS
FROM draws;

CREATE TABLE RAW.LOAN_DAILY AS
WITH days AS (
  SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS DAY_INDEX
  FROM TABLE(GENERATOR(ROWCOUNT => 90))
), base AS (
  SELECT b.ID AS ENTITY_ID, b.BORROWER_INDEX, b.CATEGORY, b.REGION, b.PRINCIPAL_PHP,
         b.INSTALMENT_INTERVAL_DAYS, b.BASE_MISS_RATE, b.BASE_DEPOSIT_INFLOW_PHP,
         COALESCE(d.DAY_INDEX >= b.DEFAULT_ONSET_DAY, FALSE) AS DEFAULTED,
         COALESCE(d.DAY_INDEX >= b.DEFAULT_ONSET_DAY - 10, FALSE) AS PRE_DEFAULT,
         d.DAY_INDEX,
         DATEADD('day', d.DAY_INDEX - 89, CURRENT_DATE()) AS EVENT_DATE,
         MOD(d.DAY_INDEX + b.BORROWER_INDEX * 3, b.INSTALMENT_INTERVAL_DAYS) = 0 AS IS_DUE,
         -- Cash-flow stress cycle in [0, 1]; a 15-day regional income shock in Cagayan de Oro.
         LEAST(1, 0.5 + 0.5 * SIN(2 * PI() * (d.DAY_INDEX / b.STRESS_PERIOD_DAYS + b.STRESS_PHASE))
               + IFF(b.REGION = 'Cagayan de Oro' AND d.DAY_INDEX BETWEEN 51 AND 65, 0.35, 0)) AS STRESS,
         MOD(ABS(HASH(b.ID, d.DAY_INDEX, 'phbank_pay')), 1000000) / 1e6 AS U_PAY,
         MOD(ABS(HASH(b.ID, d.DAY_INDEX, 'phbank_wallet')), 1000000) / 1e6 AS U_WALLET,
         MOD(ABS(HASH(b.ID, d.DAY_INDEX, 'phbank_sessions')), 1000000) / 1e6 AS U_SESSIONS,
         MOD(ABS(HASH(b.ID, d.DAY_INDEX, 'phbank_contact')), 1000000) / 1e6 AS U_CONTACT,
         MOD(ABS(HASH(b.ID, d.DAY_INDEX, 'phbank_ptp')), 1000000) / 1e6 AS U_PTP,
         MOD(ABS(HASH(b.ID, d.DAY_INDEX, 'phbank_channel')), 1000000) / 1e6 AS U_CHANNEL
  FROM RAW.BORROWERS b CROSS JOIN days d
), dues AS (
  SELECT *,
         IFF(IS_DUE, 1, 0) AS INSTALMENT_DUE,
         IFF(IS_DUE AND (DEFAULTED OR U_PAY < LEAST(0.9, BASE_MISS_RATE * (0.2 + 2.6 * STRESS))), 1, 0) AS INSTALMENT_MISSED
  FROM base
), streaks AS (
  -- Consecutive missed instalments form one delinquency streak; a paid instalment cures it.
  SELECT *,
         SUM(IFF(IS_DUE AND INSTALMENT_MISSED = 0, 1, 0))
           OVER (PARTITION BY ENTITY_ID ORDER BY DAY_INDEX ROWS UNBOUNDED PRECEDING) AS PAID_GROUP
  FROM dues
), streak_start AS (
  SELECT *,
         MIN(IFF(INSTALMENT_MISSED = 1, DAY_INDEX, NULL))
           OVER (PARTITION BY ENTITY_ID, PAID_GROUP) AS STREAK_START_DAY
  FROM streaks
), dpd AS (
  SELECT *,
         LAST_VALUE(IFF(IS_DUE, INSTALMENT_MISSED, NULL)) IGNORE NULLS
           OVER (PARTITION BY ENTITY_ID ORDER BY DAY_INDEX ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS LAST_DUE_MISSED,
         LAST_VALUE(IFF(IS_DUE, STREAK_START_DAY, NULL)) IGNORE NULLS
           OVER (PARTITION BY ENTITY_ID ORDER BY DAY_INDEX ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS LAST_STREAK_START
  FROM streak_start
), measured AS (
  SELECT *,
         IFF(LAST_DUE_MISSED = 1, DAY_INDEX - LAST_STREAK_START, 0) AS DAYS_PAST_DUE,
         ROUND(PRINCIPAL_PHP * INSTALMENT_INTERVAL_DAYS / 180 * 1.08, -2) AS INSTALMENT_PHP
  FROM dpd
)
SELECT ENTITY_ID || '-' || TO_CHAR(EVENT_DATE, 'YYYYMMDD') AS EVENT_ID,
       ENTITY_ID, EVENT_DATE,
       INSTALMENT_DUE, INSTALMENT_MISSED,
       INSTALMENT_DUE * INSTALMENT_PHP AS AMOUNT_DUE_PHP,
       (INSTALMENT_DUE - INSTALMENT_MISSED) * INSTALMENT_PHP AS AMOUNT_PAID_PHP,
       DAYS_PAST_DUE,
       ROUND(PRINCIPAL_PHP * GREATEST(0.15, 1 - DAY_INDEX / 200), -3) AS OUTSTANDING_PHP,
       -- Collection contact on delinquent days (1-60 DPD); promise to pay on some contacts.
       IFF(DAYS_PAST_DUE BETWEEN 1 AND 60 AND U_CONTACT < 0.35, 1, 0) AS COLLECTION_CONTACT,
       IFF(DAYS_PAST_DUE BETWEEN 1 AND 60 AND U_CONTACT < 0.35 AND U_PTP < 0.75 - 0.5 * STRESS, 1, 0) AS PROMISE_TO_PAY,
       CASE WHEN NOT (DAYS_PAST_DUE BETWEEN 1 AND 60 AND U_CONTACT < 0.35) THEN 'None'
            WHEN DAYS_PAST_DUE <= 7 THEN IFF(U_CHANNEL < 0.6, 'SMS', 'Viber')
            WHEN DAYS_PAST_DUE <= 30 THEN IFF(U_CHANNEL < 0.5, 'Viber', 'Phone call')
            ELSE IFF(U_CHANNEL < 0.7, 'Phone call', 'Field visit') END AS COLLECTION_CHANNEL,
       -- Leading indicator: deposit-account inflows fall with cash-flow stress, and sharply ~10 days before default.
       ROUND(BASE_DEPOSIT_INFLOW_PHP * IFF(PRE_DEFAULT, 0.35, 1) * (1.3 - 0.9 * STRESS) * (0.75 + 0.5 * U_WALLET), -1) AS DEPOSIT_INFLOW_PHP,
       ROUND(2 + 6 * (1 - STRESS) * U_SESSIONS + 2 * U_SESSIONS) AS APP_SESSIONS,
       CURRENT_TIMESTAMP() AS LOADED_AT
FROM measured;

-- KYC and underwriting document coverage per borrower (snapshot).
CREATE TABLE RAW.BORROWER_DOCUMENTS AS
SELECT ID AS ENTITY_ID,
       CASE CATEGORY WHEN 'Salary Loan' THEN 'Latest payslip' WHEN 'Personal Loan' THEN 'Income tax return'
                     WHEN 'MSME Credit Line' THEN 'Business permit'
                     WHEN 'Auto Loan' THEN 'Vehicle OR/CR' ELSE 'Farm or boat lease' END AS DOC_TYPE,
       1 + MOD(ABS(HASH(ID, 'phbank_req')), 3) AS REQUIRED_QTY,
       MOD(ABS(HASH(ID, 'phbank_file')), 4) AS ON_FILE_QTY,
       IFF(MOD(ABS(HASH(ID, 'phbank_file')), 4) < 1 + MOD(ABS(HASH(ID, 'phbank_req')), 3),
           MOD(ABS(HASH(ID, 'phbank_pending')), 3), 0) AS PENDING_QTY,
       CURRENT_DATE() AS SNAPSHOT_DATE
FROM RAW.BORROWERS;
