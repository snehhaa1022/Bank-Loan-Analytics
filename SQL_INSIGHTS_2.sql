-- total accounts 
 select 
 count( open_acc) as total_accounts from finance_2;
 
-- 2)Total Amount Received
SELECT 
ROUND(SUM(loan_amnt), 2) AS total_amount_received
FROM Finance_1;

-- 3)total funded_amnt
SELECT 
concat('$',ROUND(SUM(funded_amnt)/10000000, 2),'M')AS total_funded_amount
FROM Finance_1;

-- 4)revol_bal 
select 
concat('$',round(sum(revol_bal)/10000000,2),'M') as total_revol_bal 
from finance_2;


-- 5)Fully Paid Percentage
SELECT 
concat(ROUND(100.0 * SUM(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE 0 END)/ COUNT(*),2),'%') AS fully_paid_percent
FROM Finance_1;

-- 6)year wise loans grow 
SELECT YEAR(issue_d) AS loan_year,
concat(round(COUNT(*)/1000,2),'%') AS total_loans
FROM Finance_1 GROUP BY YEAR(issue_d) ORDER BY loan_year;

-- 7)Year-wise Payment Trend
SELECT 
    YEAR(f2.last_pymnt_d) AS payment_year,
    COUNT(*) AS total_payments
FROM finance_1 f1
JOIN finance_2 f2 ON f1.id = f2.id
GROUP BY YEAR(f2.last_pymnt_d)
ORDER BY payment_year;

-- 8)Last Payment Date by Loan Status
SELECT loan_status,
MAX(f2.last_pymnt_d) AS latest_payment_date
FROM finance_1 f1
JOIN finance_2 f2 ON f1.id = f2.id
GROUP BY loan_status ORDER BY latest_payment_date DESC;

-- 9)Average DTI (Borrower Risk KPI)
SELECT 
CONCAT(ROUND(AVG(dti), 2),'%')AS avg_dti
FROM Finance_1;

-- 10) High Risk Exposure KPI
SELECT 
    concat(round(COUNT(*)/100,2),'%') AS high_risk_defaults
FROM Finance_1
WHERE dti > 20
AND loan_status = 'Charged Off';

-- 11)recovery rate for charged off 
SELECT 
ROUND(100.0 * SUM(f2.recoveries)/ NULLIF(SUM(f1.loan_amnt), 0),2) AS recovery_rate_percent
FROM Finance_1 f1
JOIN Finance_2 f2 ON f1.id = f2.id
WHERE f1.loan_status = 'charged off';