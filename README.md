# 🛒 Online Retail Data Pipeline Project

## 📌 Project Summary

This project builds an end-to-end **ELT data pipeline** to process and analyze an online retail dataset. The dataset contains transactions from a UK-based online retailer between **December 2010 and December 2011**. The goal is to ingest, transform, and model the data to support business intelligence use cases like customer analysis and sales reporting.

![pipeline](https://github.com/neema233/Online-Retail-Data-Pipeline/blob/master/pipline.png)
---
### 🔗 Data Source

- [Online Retail Data](https://www.kaggle.com/datasets/tunguz/online-retail)

## Problem Description

Online retail companies collect vast amounts of transactional data, but raw data often comes in inconsistent formats, lacks structure, and is not suitable for analytics or reporting. This project solves the problem by:

- Storing raw CSV transaction data in an **S3 data lake**
- Cleaning and transforming the raw data into a structured format
- Organizing the cleaned data into dimensional models
- Storing the cleaned data in a cloud-based data warehouse (**Amazon Redshift**)
- Building a reproducible pipeline using **dbt**
- Creating a dashboard for business insights

---

## ☁️ Cloud Infrastructure

The entire project is developed using **AWS Cloud** services and **Infrastructure as Code (IaC)** tools:

- **Amazon S3**: Used as a data lake to store the raw CSV file (online_retail.csv)

- **Amazon Redshift**: Used as the data warehouse, where transformed models are stored and queried

  Data is ingested from S3 into Redshift using Redshift’s COPY command

- **Terraform**: Used to provision the **Amazon Redshift** cluster, database.

---

## 📥 Data Ingestion (Batch)

### Method: **Batch ingestion**

The data source is a **CSV file** (`online_retail.csv`) containing online retail transactions between 2010 and 2011.

**Apache Airflow** orchestrates the batch ingestion pipeline:

- A DAG is scheduled to run daily.
- The DAG performs the following steps:
  1. Reads the CSV file.
  2. Uploads the file to a designated **Amazon S3** bucket (raw data layer).
  3. Executes a **Redshift `COPY` command** to load the data from S3 into a raw table in **Amazon Redshift**.

Then **dbt Cloud** handles the transformation layer:
  - A scheduled **dbt job** runs transformations regularly.
  - The job executes models in dependency order using dbt’s `ref()` function, ensuring a clean and maintainable DAG structure.
  - The final output is a curated dataset in Redshift, ready for analysis or BI tools.


## 🏢 Data Warehouse: Amazon Redshift

- **Amazon Redshift** is used as the data warehouse.
- Data models follow a **star schema**:
  - `dim_customer`
  - `dim_product`
  - `dim_datetime`
  - `fact_invoices`
- **Surrogate keys** are created using `dbt_utils.generate_surrogate_key()` to ensure consistent, stable joins between fact and dimension tables.
- Redshift-specific data types and sorting strategies are used to optimize model performance for analytics queries.

---
### 🧩 Data Model Diagram

![Data Model Star Schema](https://github.com/neema233/Online-Retail-Data-Pipeline/blob/master/Powerbi/modeling.png)

## 🛠️ Transformations with dbt

- **dbt** is used for all SQL-based transformations:
   - **Staging Layer**: clean and normalize raw data
  -  **Marts Layer**:
    
       1- Creating dimension tables (`dim_customer`, `dim_datetime`, `dim_datetime`)

       2- Building fact tables (`fact_invoices`)
- dbt features used:
  - Use of **pre-built macros** from the `dbt_utils` package (`version: 1.1.1`) to generate_surrogate_key
  - `ref()` for dependency management and DAG execution
  - dbt Cloud **scheduling** for automated runs
  - SQL logic documented and version controlled

---
    Dbt model Structure
    ├── models/
    │   ├── staging/
    │   │   └── cleaned_data.sql         
    │   ├── marts/
    │   │   ├── dim_customer.sql         
    │   │   ├── dim_product.sql           
    │   │   ├── dim_datetime.sql          
    │   │   └── fact_invoices.sql  
    │   ├── schema.yml
    ├── dbt_project.yml
    ├── packages.yml



## 📊 Dashboard

- A dashboard is created using **Power BI**.
  - 🎁 Top 3 sold products
    1. "PAPER CRAFT, LITTLE BIRDIE"

    2. "MEDIUM CERAMIC TOP STORAGE JAR"

    3. "JUMPO BAG RED PASSPORT" 
  
  - 📈 Total Revenue by months
  
    - The month with the most revenue is November with more than 1,1M.

    - The month with the lowest revenue is February with 446K.

### 📸 Dashboard Preview

![Dashboard Screenshot](https://github.com/neema233/Online-Retail-Data-Pipeline/blob/master/Powerbi/Retail_png.png)

---

## 🔁 Reproducibility

To run this project, follow these steps:

1- Before running this project, make sure you have:

- ✅ An [**AWS account**](https://signin.aws.amazon.com/signup?request_type=register)
- ✅ A [**dbt Cloud account**](https://www.getdbt.com/product/dbt-cloud)
- ✅ [**Terraform installed**](https://developer.hashicorp.com/terraform/install)
- ✅ [**docker desktop**](https://www.docker.com/)

2- Navigate to the terraform/ folder where main.tf is located and then apply:

  ```terraform init ```
  
  ```terraform apply```

3- Go to airflow/ folder taking all files and run `docker-compose up --build airflow-init` then `docker-compose up -d`

4- Deploy in dbt cloud
  1. Initiate New project and conncet it to redshift cluster then connect your GitHub repository.
  
  2.Add `packages.yml` and `dbt_project.yml`
  
  3.Go to the `models/` directory to add your transformations:
  
  - `models/staging/` → cleaned staging models  
  
  - `models/marts/` → dimensional and fact models
  
  - **edit** `schema.yml` for your models

  4.Create a **deploy job** and configure the schedule to run **every 12 hours**.

  5.Set the job command to:

  ```bash
    dbt run
```
  6.Make dashboard on Powerbi

## 📚 Technologies Used
**Airflow** -orchestration.

**Amazon S3** – data lake.

**Amazon Redshift** – data warehouse.

**dbt (Cloud)** – data transformation and make orchestration. 

**Terraform** – infrastructure provisioning.

**Power BI** – for dashboarding.


