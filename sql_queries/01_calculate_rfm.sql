-- Step 1: Clean the raw transaction data (This is our base)
WITH cleaned_transactions AS (
    SELECT
        CustomerID,
        InvoiceNo,
        CAST(InvoiceDate AS DATE) AS InvoiceDate,
        Quantity * UnitPrice AS Line_Revenue
    FROM
        `crsm-471015.ecommerce.raw_trans`
    WHERE
        CustomerID IS NOT NULL
        AND Quantity > 0
        AND UnitPrice > 0
),

-- Step 2: Calculate Raw RFM Values (Your Query 1 Logic)
rfm_values AS (
    SELECT
        CustomerID,
        DATE_DIFF(
            (SELECT MAX(InvoiceDate) FROM cleaned_transactions), 
            MAX(InvoiceDate), 
            DAY
        ) AS Recency,
        COUNT(DISTINCT InvoiceNo) AS Frequency,
        SUM(Line_Revenue) AS Monetary
    FROM
        cleaned_transactions
    GROUP BY
        CustomerID
),

-- Step 3: Calculate RFM Scores using NTILE (Your Query 2 Logic)
rfm_scores AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY Recency DESC) AS r_score,
        NTILE(4) OVER (ORDER BY Frequency ASC) AS f_score,
        NTILE(4) OVER (ORDER BY Monetary ASC) AS m_score
    FROM
        rfm_values
)

-- Step 4: Assign Segment Names using CASE (Your Query 3 Logic)
-- This is the final output of the entire query.
SELECT
    *,
    CASE
        WHEN r_score = 4 AND f_score = 4 AND m_score = 4 THEN 'Champions'
        WHEN r_score = 4 AND f_score = 4 THEN 'Loyal Customers'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Potential Loyalists'
        WHEN r_score = 4 AND f_score <= 2 THEN 'New Customers'
        WHEN r_score = 3 AND f_score <= 2 THEN 'Promising'
        WHEN r_score = 2 AND f_score >= 3 THEN 'Needs Attention'
        WHEN r_score = 2 AND f_score <= 2 THEN 'About to Sleep'
        WHEN r_score = 1 AND f_score >= 3 THEN 'At-Risk'
        WHEN r_score = 1 AND f_score = 2 THEN 'Hibernating'
        WHEN r_score = 1 AND f_score = 1 THEN 'Lost'
        ELSE 'Other'
    END AS segment
FROM
    rfm_scores
WHERE
    Monetary > 0; -- Final check to remove customers with no spending