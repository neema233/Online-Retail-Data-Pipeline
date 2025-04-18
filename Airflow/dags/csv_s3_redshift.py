from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.amazon.aws.transfers.local_to_s3 import LocalFilesystemToS3Operator
from airflow.providers.amazon.aws.transfers.s3_to_redshift import S3ToRedshiftOperator
import os

with DAG (
    dag_id='upload_csv_to_s3_and_load_to_redshift',
    schedule_interval='@daily',
    start_date=days_ago(1),
    catchup=False
) as dag:
    
    upload_csv_to_s3 = LocalFilesystemToS3Operator(
        task_id='upload_csv_to_s3',
        filename="c:user/downloads/Online_Retail.csv",  
        dest_key='Online_Retail.csv',              
        dest_bucket='retaildwhbucket',                       
        aws_conn_id='aws_default',                    
        replace=True
    )


    copy_from_s3_to_redshift = S3ToRedshiftOperator(
        task_id='copy_from_s3_to_redshift',
        schema='schema_db',        
        table='online_retail',        
        s3_bucket='retaildwhbucket',  
        s3_key='Online_Retail.csv',   
        copy_options=["csv"],  
        aws_conn_id='aws_default',  
        redshift_conn_id='redshift_default',  
        autocommit=True,  
        dag=dag,
    )
upload_csv_to_s3 >> copy_from_s3_to_redshift 
