WITH datetime_cte AS (  
  SELECT DISTINCT
    CAST(invoice_date AS timestamp) AS datetime_id,
    CAST(invoice_date AS timestamp) AS date_part
  FROM {{ ref('cleaned_data') }}
  WHERE invoice_date IS NOT NULL
)

SELECT
  datetime_id,
  date_part AS datetime,
  EXTRACT(YEAR FROM date_part) AS year,
  EXTRACT(MONTH FROM date_part) AS month,
  EXTRACT(DAY FROM date_part) AS day,
  EXTRACT(HOUR FROM date_part) AS hour,
  EXTRACT(MINUTE FROM date_part) AS minute,
  EXTRACT(DOW FROM date_part) AS weekday
FROM datetime_cte
