# synapse-analytics-with-Serverless-SQl-Pool

This project implements an end-to-end data engineering pipeline using **Azure Synapse Analytics** to ingest, transform, and prepare data for analysis. The pipeline is designed to automate the movement and processing of CSV data stored in **Azure Data Lake Storage (ADLS)**, culminating in structured data layers (Bronze, Silver, and Gold) for reporting and analytics in Power BI.

Data: https://drive.google.com/drive/folders/1FoeXckBXl_Q7MBq1VqzVX3loBukse5cL
---

## **Table of Contents**

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Pipeline Design](#pipeline-design)
- [Data Layers](#data-layers)
- [Technologies Used](#technologies-used)
---

## **Project Overview**

The primary goal of this project is to build a robust data engineering pipeline to:
- Ingest raw CSV data from ADLS (Bronze Layer).
- Clean, transform, and enrich the data (Silver Layer).
- Create summarized and analytical views (Gold Layer).
- Expose the Gold Layer to **Power BI** for visualization and reporting.

---

## **Architecture**

The pipeline follows the **Bronze-Silver-Gold** architecture pattern:

1. **Bronze Layer**:
   - Raw data ingestion.
   - External tables pointing to unprocessed CSV files in ADLS.

2. **Silver Layer**:
   - Data cleaning and transformation.
   - Parquet files stored in ADLS.

3. **Gold Layer**:
   - Aggregated and analytical views for reporting.
   - Exposed via Synapse Serverless SQL Pool.

### **Pipeline Flow**
```plaintext
Raw Data (ADLS) → Bronze External Tables → Transformations → Silver Layer → Gold Views → Power BI
```

---

## **Pipeline Design**

The pipeline is divided into three primary stages:

### **1. Bronze Layer Ingestion**
- **Activity**: Copy Data.
- **Objective**: Move raw CSV files from ADLS to external tables in Synapse.
- **Output**: External tables pointing to raw CSV files.

### **2. Silver Layer Transformation**
- **Activity**: Notebooks or Mapping Dataflows.
- **Objective**: Clean, join, and transform data.
- **Output**: Parquet files stored in `silver` folder in ADLS.

### **3. Gold Layer Views**
- **Activity**: SQL Scripts.
- **Objective**: Create analytical views for reporting.
- **Output**: Serverless SQL views accessible via Synapse.

---

## **Data Layers**

### **Bronze Layer**
- Raw data as-is from the source.
- Files: `categories.csv`, `customers.csv`, `products.csv`, `sales.csv`. `employees.csv`, `countries.csv`, `cities.csv`

### **Silver Layer**
- Cleaned and transformed data.
- Example: `products_cleaned`, `customers_cleaned`, `sales_cleaned`, `countries_cleaned`

### **Gold Layer**
- Summarized and aggregated data views.
- Example: `sales_summary_by_customer`, `revenue_by_country` etc.

---

## **Technologies Used**

- **Azure Synapse Analytics**
- **Azure Data Lake Storage (ADLS)**
- **SQL** for transformations
- **SQL Serverless Pool** for analytical views
- **Power BI** for reporting and visualization
