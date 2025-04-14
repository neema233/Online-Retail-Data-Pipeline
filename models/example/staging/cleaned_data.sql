WITH cleaned_data AS (
    SELECT
        invoice_no, 
        stock_code, 
        description, 
        quantity, 
        invoice_date, 
        CASE
            WHEN unit_price<=0 THEN NULL
            ELSE unit_price
        END AS unit_price, 
        customer_id, 
        country
    FROM {{ source('retail','online_retail') }}
    WHERE quantity >= 0      
)

SELECT DISTINCT * 
FROM cleaned_data
WHERE customer_id != ''