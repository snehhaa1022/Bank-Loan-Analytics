select * from finance_1;
select * from finance_2;
select * from finance_1 as f1 inner join finance_2 as f2 on f1.id=f2.id;

-- 1)loan_amount vs purpose
SELECT purpose,
CONCAT(ROUND(COUNT(*) / 1000.0, 2),' K') AS total_loans_k,
CONCAT(ROUND(SUM(loan_amnt) / 10000000.0, 2),' K') AS total_loan_amnt_k
from finance_1 GROUP BY purpose ORDER BY total_loans_k;

-- 2)loan_status for home_ownership
select home_ownership,loan_status ,
count(loan_status)as total_loan_status
from finance_1 group by home_ownership,loan_status;

-- 3)loan_status in percentage
select  loan_status,
concat(round(count(*)/1000,2),'k') as total_loan_status,
concat(round(100*(count(*)/sum(count(*))over()),2),'%') as loan_status_per
from finance_1 group by loan_status order by total_loan_status;

-- 4)home_ownership in percentage
select  home_ownership,
concat(round(count(*)/1000,2),'k') as total_owerships,
concat(round(100*(count(*)/sum(count(*))over()),2),'%') as ownership_per
from finance_1 group by home_ownership order by ownership_per;

-- 5)verification status 
select verification_status, 
count(*) as total_accounts,
concat(round(100*(count(*)/sum(count(*))over()),2),'%') as verified_per
from finance_1 group by verification_status order by total_accounts;

-- 6)grade wise total loans and percentage
SELECT grade,
CONCAT(ROUND(COUNT(*)/1000,2),'K') AS total_loans,
CONCAT(ROUND(SUM(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE 0 END)/1000,2),'K') AS fully_paid_count,
CONCAT(ROUND(100 * SUM(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE 0 END) / COUNT(*),2),'%') AS fully_paid_percentage
FROM finance_1 GROUP BY grade ORDER BY grade;

-- 7)grade and subgrade wise revol balance
SELECT f1.grade,f1.sub_grade,
CONCAT(ROUND(SUM(f2.revol_bal) / 10000000.0, 2),'M') AS total_revol_balance
FROM finance_1 f1
JOIN finance_2 f2 ON f1.id = f2.id
GROUP BY f1.grade ,f1.sub_grade order by total_revol_balance;

-- 8) grade wise interest rate for loan_amnt
SELECT grade,
concat(ROUND(100*AVG(int_rate), 2),'%') AS avg_interest_rate,
concat(ROUND(AVG(loan_amnt)/10000, 2),'k') AS avg_loan_amount
FROM Finance_1 GROUP BY grade ORDER BY grade;

-- 9) grade wise verification status and their total count
SELECT grade,
SUM(CASE WHEN verification_status = 'Verified' THEN 1 ELSE 0 END) AS verified_count,
SUM(CASE WHEN verification_status = 'Not Verified' THEN 1 ELSE 0 END) AS not_verified_count,
SUM(CASE WHEN verification_status = 'source Verified' THEN 1 ELSE 0 END) AS source_verified_count,
COUNT(*) AS total_count
FROM finance_1 GROUP BY grade ORDER BY grade;


-- 10) total_emp_length and their percentage in loananalysis
select emp_length,
count(*)as no_of_empl,
concat(round(100*(count(*)/sum(count(*))over()),2),'%') as  emp_length_per
from finance_1 group by emp_length order by no_of_empl;

-- 11) default risk per grade,loan_status
SELECT grade,
concat(round(COUNT(*)/100,2),'k') AS total_loans,
concat(round(SUM(CASE WHEN loan_status = 'charged off' THEN 1 ELSE 0 END)/100,2),'k')AS total_defaults,
concat(ROUND(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / COUNT(*),2),'%') AS risk_per
FROM Finance_1 GROUP BY grade ORDER BY risk_per DESC;








