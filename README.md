# 🔍📦 SQL Insights: Customer & Sales Analytics

├── 📂 <a href="https://github.com/NhutVuong/SQL-Insights-Customer-Sales/tree/main/SQL_Query">SQL_Query</a>     
├── 📂 <a href="https://github.com/NhutVuong/SQL-Insights-Customer-Sales/tree/main/dataset">Dataset</a>         
├── 📂 <a href="https://github.com/NhutVuong/SQL-Insights-Customer-Sales/blob/main/database.sql">Database</a>           

---

## 🔍 Key Features & Analyses

### 1. **Customer Report**
- Segments customers by **age group** and **spending behavior** (VIP, Regular, New)
- Calculates **total orders, sales, quantity, product diversity**
- Derives KPIs like:
  - **Recency** (months since last order)
  - **Average Order Value (AOV)**
  - **Monthly Spend**
  - **Customer Lifespan**

### 2. **Sales Performance Analysis**
- Monthly and yearly **sales trends**
- **Running total** of revenue
- **Moving average** of prices over time
- Year-over-Year (YoY) product performance comparison:
  - vs. historical average
  - vs. previous year

### 3. **Product & Category Segmentation**
- Product segmentation by **cost ranges** (`Below 100`, `100-500`, etc.)
- Category-wise **contribution to total sales**
- Percentage share per category

---

## ⚙️ Tools & Technologies

- **SQL Server (T-SQL)**
- Star Schema Tables:
  - `fact_sales`
  - `dim_customers`
  - `dim_products`

---

## 🎯 Purpose

This project demonstrates hands-on SQL skills in:
- Data modeling (fact/dimension)
- KPI calculation
- Segmentation
- Time-based trend analysis
- Window functions (e.g., `OVER`, `LAG`, `AVG`, `SUM`)

Suitable for:
- Data Analyst / BI Analyst portfolio
- Academic or training purposes
- Business stakeholders looking for analytical patterns

---

## 📌 Author

**Your Name**  
[LinkedIn](https://linkedin.com/in/yourprofile) | [Email](mailto:your@email.com)

---

## ✅ How to Use

1. Clone this repo:
   ```bash
   git clone https://github.com/yourusername/datawarehouse-analytics-report.git
