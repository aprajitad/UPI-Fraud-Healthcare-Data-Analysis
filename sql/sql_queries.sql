--1. Overall fraud rate
SELECT 
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN fraud_flag = 'Yes' THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(100.0 * SUM(CASE WHEN fraud_flag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS fraud_rate_pct
FROM transactions;

--2. Fraud by hospital, ranked
SELECT hospital_name, COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'Yes'
GROUP BY hospital_name
ORDER BY fraud_count DESC;

--3. Fraud by city
SELECT city, COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'Yes'
GROUP BY city
ORDER BY fraud_count DESC;

--4. Fraud by UPI app
SELECT upi_app, COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'Yes'
GROUP BY upi_app
ORDER BY fraud_count DESC;

--5. Monthly fraud trend
SELECT strftime('%Y-%m', transaction_date) AS month,
       COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'Yes'
GROUP BY month
ORDER BY month;

--6. Fraud vs non-fraud average transaction value
SELECT fraud_flag, 
       ROUND(AVG(amount), 2) AS avg_amount,
       COUNT(*) AS n
FROM transactions
GROUP BY fraud_flag;

--7. High-value failed transactions
SELECT transaction_id, hospital_name, upi_app, amount, transaction_status
FROM transactions
WHERE transaction_status = 'Failed' AND amount > 7000
ORDER BY amount DESC;

--8. Failure reason breakdown
SELECT failure_reason, COUNT(*) AS count
FROM transactions
WHERE transaction_status = 'Failed'
GROUP BY failure_reason
ORDER BY count DESC;

--9. Fraud rate by status
SELECT transaction_status,
       COUNT(*) AS total,
       SUM(CASE WHEN fraud_flag='Yes' THEN 1 ELSE 0 END) AS fraud_count,
       ROUND(100.0*SUM(CASE WHEN fraud_flag='Yes' THEN 1 ELSE 0 END)/COUNT(*),1) AS fraud_rate_pct
FROM transactions
GROUP BY transaction_status;

--10. Rank hospitals by fraud rate
SELECT 
    hospital_name,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN fraud_flag='Yes' THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(100.0 * SUM(CASE WHEN fraud_flag='Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS fraud_rate_pct,
    RANK() OVER (ORDER BY 100.0 * SUM(CASE WHEN fraud_flag='Yes' THEN 1 ELSE 0 END) / COUNT(*) DESC) AS fraud_rate_rank
FROM transactions
GROUP BY hospital_name
ORDER BY fraud_rate_rank;