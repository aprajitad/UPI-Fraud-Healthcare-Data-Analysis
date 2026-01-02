UPI Fraud + Healthcare SQL Analysis


-- 1. Total number of transactions

SELECT COUNT(*) AS total_transactions
FROM transactions;


-- 2. Total fraudulent transactions

SELECT COUNT(*) AS fraud_transactions
FROM transactions
WHERE fraud_flag = 'Yes';


-- 3. Fraud cases by hospital

SELECT hospital_name,
       COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'Yes'
GROUP BY hospital_name
ORDER BY fraud_count DESC;



-- 4. Fraud cases by UPI app

SELECT upi_app,
       COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'Yes'
GROUP BY upi_app;


-- 5. Monthly fraud trend

SELECT strftime('%Y-%m', transaction_date) AS month,
       COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'Yes'
GROUP BY month;


-- 6. High-value failed transactions

SELECT transaction_id,
       hospital_name,
       upi_app,
       amount,
       transaction_status
FROM transactions
WHERE transaction_status = 'Failed'
  AND amount > 7000;


-- 7. Fraud by transaction status

SELECT transaction_status, COUNT(*) AS fraud_count
FROM transactions
WHERE fraud_flag = 'Yes'
GROUP BY transaction_status;


-- 8. Average amount in fraud transactions

SELECT AVG(amount) AS avg_fraud_amount
FROM transactions
WHERE fraud_flag = 'Yes';
