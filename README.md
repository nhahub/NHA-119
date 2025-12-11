# Supply Chain & Customer Analytics Dashboard Documentation

## Project Overview

This project leverages Power BI dashboards and data analytics to analyze business performance across critical areas: customers, operations, and financial KPIs spanning 2022–2025. By identifying key trends, pinpointing weaknesses, and highlighting growth opportunities, we empower strategic decision-making and operational excellence.

The project encompasses four core dashboards—**Executive Overview**, **Financial Overview**, **Operations Overview**, and **Customer Overview**—each designed to extract actionable insights from comprehensive business data.

---

## Team Structure

| Member | Main Responsibilities |
|--------|----------------------|
| Mohamed Abdelhamed | Defines project scope and objectives, aligns stakeholders, and reviews final deliverables |
| Ahmed Wael | Performs data exploration, cleaning, and preparation for reporting |
| Mohamed Abdelhamed | Builds the data model, creates DAX measures, and develops Power BI dashboards |
| Salma Nasser | Interprets insights, identifies business issues, and proposes data-driven actions |
| Yousef Abdelal | Prepares project documentation and validates data and dashboard consistency |

---

## Project Methodology

### 1. Data Exploration

**What We Did:**
- Performed an initial exploration of the sales, customer, product, and operations data to understand structure, volume, and key fields
- Identified the main business questions around revenue trends, customer behavior, operational performance, and product category contribution
- Examined data across all years (2022–2025) to establish baseline understanding of seasonal patterns, customer segments, and operational metrics

**Why This Step Matters:**  
Understanding the data landscape is essential for building accurate and meaningful dashboards. This phase ensures we ask the right questions and align analysis with business objectives.

### 2. Data Cleaning

**What We Did:**
- Checked for missing, inconsistent, and duplicate records across the orders and customers tables and resolved data quality issues where needed
- Standardized categorical fields such as order status, product category, and payment method to ensure consistent reporting
- Validated relationships and data integrity between fact tables (orders, shipments) and dimension tables (dates, products, customers)

**Why This Step Matters:**  
Clean, consistent data is the foundation of reliable analytics. Any inconsistencies at this stage directly impact the accuracy of KPIs and insights.

### 3. Data Transformation

**What We Did:**
- Built a star-schema data model in Power BI linking fact tables (orders, shipments) with dimension tables (dates, products, customers)
- Created core business DAX measures to support all dashboard calculations and KPI computations
- Implemented data relationships, hierarchies, and calculated columns to enable multi-dimensional analysis

#### Core DAX Measures Created:

```dax
Gross Revenue =
CALCULATE (
    SUM ( factorders[Price] ) + SUM ( factorders[ShippingCharges] ),
    factorders[OrderStatus] = "delivered"
)
```

```dax
Total Orders =
DISTINCTCOUNT ( factorders[OrderID] )
```

```dax
Total Customers =
DISTINCTCOUNT ( factorders[CustomerId] )
```

```dax
Average Order Value (AOV) =
DIVIDE ( [Gross Revenue], [Total Orders], "Invalid Input" )
```

```dax
Average Revenue Per Customer (ARPC) =
DIVIDE (
    SUM ( factorders[Price] ),
    DISTINCTCOUNT ( factorders[CustomerId] ),
    0
)
```

#### Measure Definitions:

- **Gross Revenue**: Total revenue generated from delivered orders, including product price and shipping charges. This measure ensures we only count successful transactions in financial analysis.

- **Total Orders**: Distinct count of all order IDs, providing a unique transaction count regardless of quantity or value.

- **Total Customers**: Distinct count of unique customer IDs, used as the denominator for per-customer metrics.

- **Average Order Value (AOV)**: Total revenue divided by total orders. AOV measures how much customers spend on average per transaction, a key indicator of transaction value and pricing strategy effectiveness.

- **Average Revenue Per Customer (ARPC)**: Total revenue divided by total customers. ARPC measures the average lifetime value a customer generates, independent of transaction count. This metric helps evaluate customer quality and retention impact.

**Why This Step Matters:**  
Proper data transformation and well-designed measures ensure consistency across all dashboards and enable accurate, fast reporting without calculation delays.

### 4. Analysis & Dashboard Design

**What We Did:**
- Designed four main dashboards (Executive, Financial, Operations, Customer) to visualize trends, KPIs, and performance drivers across the business
- Analyzed yearly and monthly trends, product category performance, customer segments, and operational KPIs
- Created visual hierarchies and drill-down capabilities to support detailed exploration and root-cause analysis

---

## Dashboard Overview

### Executive Overview Dashboard

**Purpose**: Provides a high-level view of overall business health, highlighting key performance indicators and top-performing categories.

**Key Metrics**: Total Orders, Revenue trends, Top Categories, Year-over-Year performance

**Key Insights**: Yearly performance shows fluctuations with notable peaks in mid-2023 and early 2024. Electronics consistently remain the highest contributing category, creating both strength and dependency risk.

### Financial Overview Dashboard

**Purpose**: Details revenue contribution, Average Order Value (AOV), Average Revenue Per Customer (ARPC), and yearly revenue trends.

**Key Metrics**: 
- Gross Revenue
- AOV (≈$486)
- ARPC (≈$4.03K)
- Revenue by Category
- Monthly revenue patterns

**Key Insights**: High AOV driven by Electronics category. Strong ARPC indicates robust customer spending behavior. Significant monthly revenue drops during specific periods highlight seasonal vulnerability.

### Operations Overview Dashboard

**Purpose**: Analysis of operational efficiency, focusing on order fulfillment and delivery performance.

**Key Metrics**: 
- Total Orders (50K)
- Average Shipping Cost ($29.11)
- On-Time Delivery Rate (67.36%)
- Cancellation Rate (2.85%)

**Key Insights**: Low on-time delivery (67%) indicates a major operational weakness. Monthly orders are 10.93% below target. Very low cancellation rate suggests good order quality. Electronics dominate operational volume.

### Customer Overview Dashboard

**Purpose**: Understanding customer demographics, purchasing habits, and satisfaction levels.

**Key Metrics**: 
- Total Customers (7,677)
- AOV ($486)
- Repeat Customer Rate (16.4%)
- Electronics Customers (4.2K)
- Top Payment Method (Credit 35.9%)

**Key Insights**: Low repeat customer rate (16.4%) signals a significant retention challenge. High AOV indicates strong spending habits. Electronics attracts the most customers. Strong adoption of electronic payment methods reflects modern customer preferences.

---

## 5. Insights & Recommendations

### Critical Business Findings

#### Finding 1: Electronics Dependency

**Insight**: Electronics account for the majority of orders, revenue, and customer base, creating both competitive strength and strategic vulnerability.

**Why It Matters**: Over-reliance on a single category exposes the business to market disruption, competitive pressure, and category-specific economic downturns.

**Recommended Actions**:
- Implement targeted promotions for underperforming categories to diversify revenue streams
- Launch cross-selling and bundling initiatives featuring Electronics with other products
- Allocate marketing budget to grow high-margin non-Electronics categories

#### Finding 2: Low Customer Retention

**Insight**: Repeat customer rate stands at only 16.4%, indicating that 84% of customers do not make a second purchase.

**Why It Matters**: Customer acquisition is significantly more expensive than retention. Low repeat rates suggest either poor customer satisfaction, weak engagement, or lack of retention incentives.

**Recommended Actions**:
- Launch a loyalty program with tiered rewards and exclusive benefits
- Implement post-purchase email campaigns with personalized product recommendations
- Conduct customer satisfaction surveys to identify pain points and improve experience
- Target high-value customers (those with high AOV) with VIP programs and early access to new products

#### Finding 3: Weak Delivery Performance

**Insight**: On-time delivery rate of 67.36% is significantly below industry standard (typically 90%+), impacting customer satisfaction and repeat business.

**Why It Matters**: Delivery delays directly correlate with negative customer reviews, low repeat purchase rates, and potential churn. Each delayed order represents a lost opportunity for retention.

**Recommended Actions**:
- Conduct logistics audit to identify bottlenecks in warehouse processing and last-mile delivery
- Increase courier training and accountability programs
- Implement real-time tracking and proactive customer notifications
- Partner with additional logistics providers to reduce delivery time and increase reliability
- Establish KPI targets and monitor weekly delivery performance against benchmarks

#### Finding 4: Monthly Performance Volatility

**Insight**: Significant month-to-month fluctuations in orders, revenue, and customer acquisition, with monthly orders currently 10.93% below target.

**Why It Matters**: Revenue unpredictability makes forecasting, inventory planning, and resource allocation challenging. It suggests either weak demand management or external market factors not being addressed.

**Recommended Actions**:
- Implement consistent monthly marketing campaigns to smooth demand
- Launch seasonal discount campaigns during historically low-performance months
- Develop predictive forecasting models to anticipate demand patterns
- Coordinate with operations and inventory teams to align supply with projected demand

#### Finding 5: Strong Electronic Payment Adoption

**Insight**: Electronic payment methods (Credit Cards + E-Wallet) dominate, representing over 70% of transactions. Credit cards alone account for 35.9%.

**Why It Matters**: This reflects customer preference for digital, contactless payments, enabling faster checkout and reduced fraud risk.

**Recommended Actions**:
- Optimize digital payment experience and reduce friction in checkout flow
- Expand e-wallet and Buy Now, Pay Later (BNPL) options to further increase conversion
- Leverage payment data for customer segmentation and targeted marketing

---

## Key Performance Indicators (KPIs) Summary

| KPI | Value | Interpretation | Target | Action |
|-----|-------|----------------|--------|--------|
| Total Orders | 50,000 | Baseline transaction volume across all periods | — | Increase order volume through marketing |
| Total Customers | 7,677 | Unique customer base size | — | Expand customer acquisition, improve retention |
| Average Order Value (AOV) | $486 | Average revenue per transaction | — | Maintain through upselling and premium offerings |
| Average Revenue Per Customer (ARPC) | $4,030 | Average lifetime revenue per customer | — | Increase through repeat purchases and loyalty |
| On-Time Delivery Rate | 67.36% | Percentage of orders delivered on schedule | 90%+ | Improve through logistics optimization |
| Cancellation Rate | 2.85% | Percentage of cancelled orders | — | Maintain low; investigate spike causes |
| Repeat Customer Rate | 16.4% | Percentage of customers making repeat purchases | 40%+ | Increase through retention programs |
| Top Category | Electronics | Highest revenue-contributing product category | — | Diversify to reduce category risk |

---

## Strategic Solutions for Sustainable Growth

Addressing the identified insights and challenges requires a multi-faceted approach:

### 1. Improve Logistics & Delivery Performance
- Enhance warehouse processing efficiency and courier training
- Implement real-time tracking and automated customer notifications
- Set on-time delivery KPI target at 90% and monitor weekly

### 2. Strengthen Customer Retention
- Launch loyalty program with tiered benefits and rewards
- Implement personalized post-purchase engagement campaigns
- Create VIP customer segments for high-value clients

### 3. Intensify Marketing & Revenue Stabilization
- Implement consistent monthly campaigns to smooth seasonal fluctuations
- Launch targeted promotions during low-volume periods
- Develop demand forecasting models for better planning

### 4. Diversify Product Portfolio
- Promote underperforming categories through targeted campaigns
- Create product bundles featuring Electronics with other categories
- Allocate marketing budget proportionally to drive category growth

### 5. Optimize Pricing & Order Value
- Implement dynamic pricing based on demand and inventory levels
- Develop upselling and cross-selling strategies at checkout
- Bundle products strategically to increase Average Order Value

---

## Conclusion

This Supply Chain & Customer Analytics project has successfully identified critical business opportunities and challenges across financial, operational, and customer dimensions. Key findings reveal both strengths (strong AOV, robust customer spending, low cancellation rate) and areas for immediate improvement (delivery performance, customer retention, revenue stability, category diversification).

By implementing the recommended strategies—particularly focusing on logistics optimization, retention programs, and revenue diversification—the business can achieve sustainable growth, improve customer satisfaction, and reduce operational risk associated with over-dependence on a single product category.

Continuous monitoring of the four dashboards and regular review of KPI trends will enable agile decision-making and rapid response to emerging business challenges.

---

## References

1. [Average Order Value (AOV) Calculation in E-commerce Analytics](https://www.peelinsights.com/post/what-is-average-order-value-aov-how-to-calculate)
2. [How to Calculate Average Order Value in Power BI](https://www.thebricks.com/resources/guide-how-to-calculate-average-order-value-in-power-bi)
3. [Power BI Data Transformation and DAX Best Practices](https://learn.microsoft.com/en-us/training/modules/clean-data-power-bi/)
4. [Average Order Value (AOV) | Formula + Calculator](https://www.wallstreetprep.com/knowledge/average-order-value-aov/)

---

**Document Version**: 1.0  
**Last Updated**: December 11, 2025  
**Status**: Final
