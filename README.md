# 🚀 PlanetKart Analytics: dbt + Snowflake + Airbyte

Welcome to the **PlanetKart Analytics Mini-Universe** 🌌 – a complete end-to-end data engineering solution simulating a production-style environment for interplanetary e-commerce!

---

## 📘 Project Overview

**Objective**: Design and implement a production-like data pipeline and warehouse using **Airbyte**, **Snowflake**, and **dbt** to extract, transform, model, and test data while applying core Data Warehousing concepts.

**Repo**: [GitHub - planetkart_dbt_project](https://github.com/agrawalsatyam/planetkart_dbt_project)

---

## 🌍 Storyline: Become the Chief Data Engineer of PlanetKart

PlanetKart operates across **Mars**, **Venus**, and **Earth**. Your job? Build a robust and scalable data stack that empowers analytics for the leadership team — from ingestion to warehouse modeling and data testing.

---

## 🧾 Dataset

Source files (CSV):

- `customers.csv`: Customer demographics and sign-up date  
- `products.csv`: Product catalog with categories, SKUs, and cost  
- `regions.csv`: Delivery location mapping to planet/zone  
- `orders.csv`: Order transaction data  
- `order_items.csv`: Line-level order details

---

## 🏗️ Design Decisions

- **Star Schema**: Central fact table (`fact_orders`) with dimension tables for customers, products, and regions.
- **Surrogate Keys**: All dimensions and facts use surrogate keys generated via dbt-utils macros for consistency and join performance.
- **SCD Type 2**: Customer changes are tracked using dbt snapshots (Type 2 Slowly Changing Dimension) for historical accuracy.
- **Staging Layer**: All raw data is cleaned and standardized in a staging layer before transformation.
- **Testing**: Extensive use of dbt built-in and dbt-utils tests for data quality, including uniqueness, not-null, accepted values, and custom expressions.
- **Freshness & Anomaly Detection**: dbt-utils macros are used to monitor data freshness and detect anomalies.
- **Macros**: Custom and dbt-utils macros are used to DRY up logic, especially for surrogate key generation and date handling.
- **Modular Project Structure**: Clear separation of staging, marts, snapshots, macros, and tests for maintainability.

---

## 🔁 Step 1: Load Data Using Airbyte → Snowflake

- Source: CSVs ingested via **Airbyte** using Google Drive / local source connector
- Destination: **Snowflake**
- Target Schema: `PLANETKART_RAW`

✅ **Checkpoint**: Raw tables successfully loaded into Snowflake

### 📸 Screenshot: Airbyte Pipeline Setup  
![Airbyte Pipeline Setup](https://github.com/user-attachments/assets/1fa4d897-2990-4963-9341-28437fe4e97b)

### 📸 Screenshot: Snowflake Loaded Tables  
![Snowflake Schema View](screenshots/snowflake_data_loaded.png)

---

## 📊 Step 2: dbt Modeling in Snowflake

**Schemas Used**:
- `PLANETKART_STAGE`: Staging cleaned models  
- `PLANETKART_ANALYTICS`: Final models (facts, dimensions)

### 🏗️ Models Included

#### ✅ Staging Models
- `stg_customers`
- `stg_products`
- `stg_regions`
- `stg_orders`
- `stg_order_items`

#### ✅ Dimension Models
- `dim_customers`
- `dim_products`
- `dim_regions`

#### ✅ Fact Model
- `fact_orders`: Joins with all dimensions and calculates order metrics

#### ✅ Snapshots
- `snapshots/customers_snapshot.sql`: Tracks changes in customer records (SCD Type 2)

---

## 🔬 Step 3: Apply Data Warehouse Concepts & Assumptions

### ✅ Concepts Applied

| Concept                     | Applied? | Notes |
|-----------------------------|----------|-------|
| Star Schema                | ✅       | Fact table with connected dimensions |
| Surrogate Keys            | ✅       | `*_key` columns generated using dbt-utils macros |
| SCD Type 2 via Snapshot    | ✅       | `customers_snapshot.sql` tracks historical changes |
| dbt Tests                  | ✅       | Unique, not_null, accepted values, expression-based |
| Freshness / Anomaly Tests | ✅       | Implemented using dbt-utils |
| Macros                     | ✅       | Used to standardize `surrogate_key` and date logic |

### 📝 Assumptions Made

- Orders are not modified after being placed (no SCD applied to them)
- Customers may change emails, region, etc., hence SCD Type 2 is applied
- `NULL` values are considered data quality issues and handled in staging
- Freshness tests assume daily ingestion from Airbyte
- All transformations are idempotent and can be re-run safely
- Data is loaded in UTC timezone

---

## 📐 Schema Diagram

📌 Visualize the Star Schema Design  
![Schema Diagram](screenshots/schema_diagram.png)

---

## 🧪 Tests Implemented

### ❗ Core dbt Tests
- `not_null` and `unique` constraints
- `accepted_values` for `orders.status`

### 🔍 Custom Tests (dbt-utils)
- `dbt_utils.unique_combination_of_columns`
- `dbt_utils.recency`: Checks data freshness
- `dbt_utils.equal_rowcount`: Ensures row count consistency between sources and staging

### 🕒 Freshness & Anomaly Tests
- Source freshness via `dbt_source_freshness`
- Detect delayed pipeline syncs and anomalies in key metrics

---

## 📦 Macros Used

Reusable logic includes:
- `generate_surrogate_key` using `dbt_utils.surrogate_key`
- `cast_date` utility macro for standard date conversion
- Expression-based testing via `dbt_utils.expression_is_true`
- Custom macros for DRY transformations

---

## 🛠️ Complete dbt Setup & Run Guide

### Prerequisites Check
- ✅ Snowflake trial account
- ✅ Data loaded in PLANETKART_RAW schema
- ✅ Airbyte pipeline setup
- Need: dbt Core installation

### Step 1: Install dbt Core

#### Using pip (Recommended)
```bash
pip install dbt-snowflake
dbt --version
```

### Step 2: Create Your dbt Project Directory
```bash
mkdir planetkart-analytics
cd planetkart-analytics
dbt init planetkart_dw
cd planetkart_dw
```

### Step 3: Configure profiles.yml
-  `~/.dbt/profiles.yml`

```yaml
planetkart_dw:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: [YOUR_SNOWFLAKE_ACCOUNT]
      user: [YOUR_USERNAME]
      password: [YOUR_PASSWORD]
      role: ACCOUNTADMIN
      database: [YOUR_DATABASE_NAME]
      warehouse: COMPUTE_WH
      schema: PLANETKART_STAGE
      threads: 4
      keepalive: false
```

**📝 Replace the placeholders with your actual Snowflake details!**

### Step 4: Test Connection
```bash
dbt debug
```

### Step 5: Create Schema Structure in Snowflake
```sql
CREATE SCHEMA IF NOT EXISTS PLANETKART_STAGE;
CREATE SCHEMA IF NOT EXISTS PLANETKART_ANALYTICS;
```

### Step 6: Project Directory Structure
```
planetkart_dw/
├── dbt_project.yml
├── README.md
├── models/
│   ├── staging/
│   │   ├── stg_customers.sql
│   │   ├── stg_products.sql
│   │   ├── stg_regions.sql
│   │   ├── stg_orders.sql
│   │   └── stg_order_items.sql
│   ├── marts/
│   │   ├── dim_customers.sql
│   │   ├── dim_products.sql
│   │   ├── dim_regions.sql
│   │   └── fact_orders.sql
│   └── schema.yml
├── snapshots/
│   └── customers_snapshot.sql
├── tests/
└── macros/
```

### Step 7: Update dbt_project.yml
```yaml
name: 'planetkart_dw'
version: '1.0.0'
config-version: 2
profile: 'planetkart_dw'
model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]
target-path: "target"
clean-targets:
  - "target"
  - "dbt_packages"
models:
  planetkart_dw:
    staging:
      +schema: staging
      +materialized: view
    marts:
      +schema: analytics
      +materialized: table
snapshots:
  planetkart_dw:
    +target_schema: planetkart_analytics
```

### Step 8: Create Staging Models
- See the `models/staging/` directory for SQL examples (see project repo for full code)

### Step 9: Create schema.yml for Sources and Tests
- See the `models/schema.yml` file in the repo for full details

### Step 10: Create Mart Models (Dimensional Models)
- See the `models/marts/` directory for SQL examples (see project repo for full code)

### Step 11: Install dbt-utils Package
```yaml
# packages.yml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
```
```bash
dbt deps
```

### Step 12: Create Customer Snapshot
- See `snapshots/customers_snapshot.sql` for SCD2 implementation

### Step 13: Run Your dbt Project
```bash
dbt deps
dbt run --select staging
dbt snapshot
dbt run
dbt test
dbt docs generate
dbt docs serve
```

### Step 14: Verification Commands
```bash
dbt run --select stg_customers
dbt test --select stg_customers
dbt run --full-refresh
dbt show --select dim_customers
```

---

## 🖼️ Screenshots & Visuals

- ![Airbyte Pipeline Setup](screenshots/airbyte_pipeline.png) – Airbyte source-to-Snowflake sync
- ![Snowflake Data Loaded](screenshots/snowflake_data_loaded.png) – Snowflake tables from raw schema
- ![Schema Diagram](screenshots/schema_diagram.png) – Star schema architecture (draw.io/dbt DAG)
- ![dbt Run Output](screenshots/dbt_run_output.png) – Successful `dbt run`
- ![dbt Test Output](screenshots/dbt_test_output.png) – Passed and failed test cases
- ![dbt Snapshot Output](screenshots/dbt_snapshot_output.png) – Snapshot tracking changes

---

## 🤝 Credits

**Created by**: [Satyam Agrawal](https://github.com/agrawalsatyam)  
**Year**: 2025  
**License**: Educational Use Only

---

## ✅ Submission Checklist

- [x] Raw data ingested to Snowflake using Airbyte  
- [x] dbt models structured in staging + marts  
- [x] All models materialized successfully in Snowflake  
- [x] Snapshot for Type 2 SCD implemented  
- [x] Tests and macros added  
- [x] Screenshots added to project repo  
- [x] This README.md documents the entire project ✅
