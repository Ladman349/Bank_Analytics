#1. Average Delinquency Rate:
SELECT AVG(delinq_2yrs) AS avg_delinquency_rate
FROM loan_data;

#2. Average Revolving Utilization:
SELECT AVG(revol_util) AS avg_revolving_utilization
FROM loan_data;



#3. Total Recovered Amount:
SELECT SUM(recoveries) AS total_recovered_amount
FROM loan_data;

#4. Average Loan Amount:
SELECT AVG(loan_amnt) AS avg_loan_amount
FROM bank_project;

#5. Number of Loans by Grade:
SELECT grade, COUNT(*) AS num_loans
FROM bank_project
GROUP BY grade;

#6. Average Debt-to-Income Ratio (DTI):
SELECT AVG(dti) AS avg_dti
FROM bank_project;

#7 Average Annual Income for Loans with Delinquency
SELECT AVG(f1.annual_inc) AS avg_annual_income_delinquent
FROM finance2 f2
JOIN finance1 f1 ON f2.id = f1.id
WHERE f2.delinq_2yrs > 0;

#8 Average Loan Amount for Fully Paid Loans
SELECT AVG(f1.loan_amnt) AS avg_loan_amount_fully_paid
FROM finance2 f2
JOIN finance1 f1 ON f2.id = f1.id
WHERE f1.loan_status = 'Fully Paid';

#9 Total Recovered Amount for Loans with Delinquency
SELECT SUM(f2.recoveries) AS total_recovered_amount_delinquent
FROM finance2 f2
JOIN finance1 f1 ON f2.id = f1.id
WHERE f2.delinq_2yrs > 0;

#10 Average Interest Rate by Grade
SELECT f1.grade,
AVG(CAST(REPLACE(f1.int_rate, '%', '') AS DECIMAL(5,2))) AS avg_interest_rate
FROM finance2 f2
JOIN finance1 f1 ON f2.id = f1.id
GROUP BY f1.grade;

#11 Avg Amount By Grade Procedure
DELIMITER //

CREATE PROCEDURE GetAvgLoanAmountByGrade(IN p_grade VARCHAR(255), OUT p_avg_loan_amount DECIMAL(10, 2))
BEGIN
    -- Average Loan Amount for the specified grade
    SELECT AVG(loan_amnt) INTO p_avg_loan_amount
    FROM finance1
    WHERE grade = p_grade;
END //

DELIMITER ;


CALL GetAvgLoanAmountByGrade('B', @avg_loan_amount);
SELECT @avg_loan_amount AS avg_loan_amount_for_grade_B;

#12. Average Monthly Installment by Purpose:

select	f1.purpose,
round((Avg(f1.installment)),2) AS avg_monthly_installment
FROM finance2 f2
JOIN finance1 f1 ON f2.id = f1.id
GROUP BY f1.purpose;

#12 Average Debt-to-Income Ratio (DTI) by Loan Status:
SELECT
    f1.loan_status,
    AVG(f1.dti) AS avg_dti
FROM finance2 f2
JOIN finance1 f1 ON f2.id = f1.id
GROUP BY f1.loan_status;

#13 Total Payments Received by Grade:
SELECT
    f1.grade,
    CONCAT(ROUND(SUM(f2.total_pymnt) / 1000000, 2), 'M') AS total_payments_received_in_millions
FROM finance2 f2
JOIN finance1 f1 ON f2.id = f1.id
GROUP BY f1.grade;