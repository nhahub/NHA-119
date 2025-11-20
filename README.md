# 🛒 E-Commerce Sales & Operations Analytics Project

## 📌 Project Overview
This project is an end-to-end data analysis solution designed to provide actionable insights into an E-commerce platform's performance. The goal was to analyze sales trends, delivery performance, financial health, and customer behavior to assist stakeholders in making data-driven decisions.

The solution involves a full data pipeline: from data extraction and storage in **MySQL**, through data modeling and ETL, to advanced visualization and reporting in **Power BI**.

---

## 🛠️ Tech Stack
* **Database:** MySQL (Data Warehousing & Storage)
* **ETL & Modeling:** Power Query, SQL
* **Visualization:** Power BI
* **Language:** DAX (Data Analysis Expressions), SQL

---

## 🔄 Methodology: End-to-End Workflow
The project followed a structured data engineering and analytics pipeline:

### 1. Data Collection & Warehousing (MySQL)
* Raw data (CSV/Excel sources) was ingested into a **MySQL database**.
* This served as the centralized **Data Warehouse**, ensuring a single source of truth.
* SQL queries were used to perform initial data validation and exploration.

### 2. Data Cleaning & ETL (Extract, Transform, Load)
* Connected Power BI to the MySQL database.
* **Data Transformation (Power Query):**
    * Handled missing values and removed duplicates.
    * Standardized date formats and text columns (e.g., Category names).
    * Created conditional columns for delivery status (On-time vs. Late).

### 3. Data Modeling (Schema Design)
* Designed a **Star Schema** data model to optimize performance.
* **Fact Table:** Orders.
* **Dimension Tables:** Customers, Products, Sellers, Calendar Table.
* Established relationships (One-to-Many) between Fact and Dimension tables to enable dynamic filtering.

### 4. DAX & Measures
Created complex measures using DAX to calculate key metrics, including:
* **Customer Lifetime Value (CLV)**
* **Average Order Value (AOV)**
* **Year-over-Year (YoY) Growth**
* **Delivery Performance %**
* **Cancellation Rates**

### 5. Visualization (Power BI)
Developed an interactive dashboard with four distinct views to cater to different business stakeholders.

---

## 📊 Dashboard Overview & Insights

### 1. Executive Overview
**Purpose:** High-level view of the business health.
* **Key Metrics:** Total Revenue **($33.79M)**, Total Orders **(89K)**, and AOV **($378)**.
* **Top Performing Category:** "Toys" is the leading category, driving significant revenue.
* **Logistics:** Achieved a **93.59% On-Time Delivery** rate, indicating strong operational efficiency.
* **Trend:** Revenue peaked significantly between late 2017 and early 2018.

### 2. Financial Overview
**Purpose:** Deep dive into monetary metrics and payment behaviors.
* **Growth:** Observed massive growth in 2017 sales **(13.12M)** compared to the previous year.
* **Payment Methods:** **Credit Cards** are the dominant payment method (71.88%), followed by Debit Cards (20.74%).
* **Seller Performance:** Average revenue per seller stands at **$11.54K**.

### 3. Operation Overview
**Purpose:** Monitoring supply chain and logistics.
* **Cycle Time:** Average shipping/cycle time is **13 days**.
* **Shipping Costs:** Average shipping cost per order is **$44.25**.
* **Risk Management:** Cancellation rate is kept very low at **0.46%**.

### 4. Customer Overview
**Purpose:** Understanding customer demographics and retention.
* **Customer Base:** Analysis of **89K** total customers.
* **CLV:** Calculated Customer Lifetime Value is **$335.05**.
* **Acquisition:** Significant spike in new customers observed in late 2017, correlating with the revenue trends.

---

## 💡 Key Business Recommendations
Based on the analysis, the following recommendations were derived:
1.  **Category Expansion:** The "Toys" category is a massive outlier. Marketing efforts should focus on cross-selling related categories (e.g., "Baby" or "Games") to leverage this traffic.
2.  **Payment Optimization:** With 71% of users on Credit Cards, ensure payment gateways are optimized for these transactions to maintain the 97.89% payment success rate.
3.  **Logistics Strategy:** While 93% on-time delivery is good, the 6.41% late delivery rate should be investigated to improve customer satisfaction, perhaps by auditing specific carriers used in "Late" regions.
4.  **Seasonality:** Prepare inventory and logistics for the Q4/Q1 peak season (Nov-Jan) where historical data shows the highest demand.
