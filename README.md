
# 📊 Retail Sales & Profit Analysis using Advanced SQL

## 📌 Project Overview

This project analyzes a retail dataset using **advanced SQL techniques** to evaluate sales performance, profitability, discount impact, customer behavior, and employee effectiveness.

The goal is to simulate real-world business analysis tasks and build reusable SQL solutions such as **functions, stored procedures, and dynamic reports**.

---

## 🗂️ Dataset Description

The dataset follows a **relational structure** with 4 main tables:

### 🔹 1. `ORDERS`

Transactional table containing order-level details:

* `ORDER_ID`, `ORDER_DATE`, `SHIP_DATE`, `SHIP_MODE`
* `CUSTOMER_ID`, `PRODUCT_ID`, `ID_EMPLOYEE`
* `SALES`, `QUANTITY`, `DISCOUNT`, `PROFIT`

👉 This is the **fact table** used for all analysis.

---

### 🔹 2. `CUSTOMER`

Customer information and segmentation:

* `ID`, `NAME`
* `SEGMENT` (Consumer, Corporate, Home Office)
* `CITY`, `STATE`, `REGION`, `COUNTRY`, `POSTAL_CODE`

---

### 🔹 3. `PRODUCT`

Product hierarchy:

* `ID`, `NAME`
* `CATEGORY` (Furniture, Office Supplies, Technology)
* `SUBCATEGORY`

---

### 🔹 4. `EMPLOYEES`

Sales representatives:

* `ID_EMPLOYEE`, `NAME`
* `CITY`, `REGION`

---

### 🔗 Relationships

* `ORDERS.CUSTOMER_ID → CUSTOMER.ID`
* `ORDERS.PRODUCT_ID → PRODUCT.ID`
* `ORDERS.ID_EMPLOYEE → EMPLOYEES.ID_EMPLOYEE`

---

## ⚙️ SQL Techniques Used

### 🔹 Aggregation

* `SUM()`, `COUNT()`, `ROUND()`
* Used for sales, profit, and order volume analysis

### 🔹 Date Analysis

* `DATEPART(YEAR, ...)`, `DATEPART(QUARTER, ...)`
* Used to analyze **quarterly trends**

### 🔹 Conditional Logic

* `CASE WHEN` to classify discount tiers:

  * No Discount
  * Low (0–20%)
  * Medium (20–50%)
  * High (>50%)

### 🔹 Window Functions

* `RANK()` to identify top categories per segment

### 🔹 CTE (Common Table Expressions)

* Used for multi-step logic (employee profit contribution)

### 🔹 User-Defined Function (UDF)

* Calculates **profitability ratio = Profit / Sales**

### 🔹 Stored Procedure

* Parameterized report for employee performance by date range

### 🔹 Dynamic SQL + Pivot

* Automatically generate columns for **latest 6 quarters**
* Uses:

  * `STRING_AGG()`
  * `QUOTENAME()`
  * Dynamic `PIVOT`

---

## ❓ Problem Statements

This project answers key business questions:

1. How do **Furniture sales perform over time (by quarter)?**
2. How do different **discount levels affect profit and order volume?**
3. What are the **top 2 most profitable categories per customer segment?**
4. How does each employee contribute to profit across product categories?
5. What is the **profitability ratio** for each employee-category combination?
6. How to build a reusable procedure to analyze employee performance by date?
7. How to dynamically analyze **profit trends across states for recent quarters?**

---

## 📈 Business Insights

### 🔹 1. Sales Trends

* Sales increase significantly in certain quarters (especially Q4)
* Indicates **seasonality in demand**

---

### 🔹 2. Discount Impact

* High discounts (>50%) often lead to **negative profit**
* Medium discounts can still be profitable depending on category
* Some categories are highly sensitive to discounting

---

### 🔹 3. Customer Segments

* Each segment has different top-performing categories:

  * Consumer → Technology-heavy
  * Corporate → Accessories / Office Supplies
* Shows opportunity for **targeted marketing**

---

### 🔹 4. Employee Performance

* Profit contribution varies widely by category
* Employees specialize in certain product categories

---

### 🔹 5. Profitability Efficiency

* Some categories generate high revenue but low margins
* Others have lower sales but higher profitability ratios

---

### 🔹 6. Regional Insights

* Profit varies significantly across states
* Some regions show **consistent losses in certain quarters**

---

## 💡 Recommendations

### 🔸 Discount Strategy

* Limit high discounts on low-margin categories
* Apply **category-based discount optimization**

---

### 🔸 Product Strategy

* Focus on high-margin categories instead of only high sales
* Promote top-performing categories per segment

---

### 🔸 Sales Team Optimization

* Assign employees based on category strengths
* Use profit contribution as a KPI

---

### 🔸 Customer Strategy

* Personalize campaigns by segment behavior
* Improve cross-selling strategies

---

### 🔸 Regional Strategy

* Investigate underperforming states
* Adjust logistics, pricing, or marketing accordingly

---

