# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables**, **fact tables**, and **reporting views** for specific business metrics.

---

### 1. **gold.dim_customers**
- **Purpose:** Stores customer details enriched with demographic and geographic data.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key     | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |
| customer_id      | INT           | Unique numerical identifier assigned to each customer.                                        |
| customer_number  | NVARCHAR(50)  | Alphanumeric identifier representing the customer, used for tracking and referencing.         |
| first_name       | NVARCHAR(50)  | The customer's first name, as recorded in the system.                                         |
| last_name        | NVARCHAR(50)  | The customer's last name or family name.                                                     |
| country          | NVARCHAR(50)  | The country of residence for the customer (e.g., 'Australia').                               |
| marital_status   | NVARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single').                              |
| gender           | NVARCHAR(50)  | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                  |
| birthdate        | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).               |
| create_date      | DATE          | The date and time when the customer record was created in the system                         |

---

### 2. **gold.dim_products**
- **Purpose:** Provides information about the products and their attributes.
- **Columns:**

| Column Name         | Data Type     | Description                                                                                   |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key         | INT           | Surrogate key uniquely identifying each product record in the product dimension table.         |
| product_id          | INT           | A unique identifier assigned to the product for internal tracking and referencing.            |
| product_number      | NVARCHAR(50)  | A structured alphanumeric code representing the product, often used for categorization or inventory. |
| product_name        | NVARCHAR(50)  | Descriptive name of the product, including key details such as type, color, and size.         |
| category_id         | NVARCHAR(50)  | A unique identifier for the product's category, linking to its high-level classification.     |
| category            | NVARCHAR(50)  | The broader classification of the product (e.g., Bikes, Components) to group related items.  |
| subcategory         | NVARCHAR(50)  | A more detailed classification of the product within the category, such as product type.      |
| maintenance_required| NVARCHAR(50)  | Indicates whether the product requires maintenance (e.g., 'Yes', 'No').                       |
| cost                | INT           | The cost or base price of the product, measured in monetary units.                            |
| product_line        | NVARCHAR(50)  | The specific product line or series to which the product belongs (e.g., Road, Mountain).      |
| start_date          | DATE          | The date when the product became available for sale or use.                                   |

---

### 3. **gold.fact_sales**
- **Purpose:** Stores transactional sales data for analytical purposes.
- **Columns:**

| Column Name     | Data Type     | Description                                                                                   |
|-----------------|---------------|-----------------------------------------------------------------------------------------------|
| order_number    | NVARCHAR(50)  | A unique alphanumeric identifier for each sales order (e.g., 'SO54496').                      |
| product_key     | INT           | Surrogate key linking the order to the product dimension table.                               |
| customer_key    | INT           | Surrogate key linking the order to the customer dimension table.                              |
| order_date      | DATE          | The date when the order was placed.                                                           |
| shipping_date   | DATE          | The date when the order was shipped to the customer.                                          |
| due_date        | DATE          | The date when the order payment was due.                                                      |
| sales_amount    | INT           | The total monetary value of the sale for the line item, in whole currency units (e.g., 25).   |
| quantity        | INT           | The number of units of the product ordered for the line item (e.g., 1).                       |
| price           | INT           | The price per unit of the product for the line item, in whole currency units (e.g., 25).      |

---

### 4. **gold.vw_customer_report**
- **Purpose:** Consolidates key customer metrics and behaviors for analytical reporting.
- **Key Features:**
  - Segments customers into categories: VIP, Regular, and New based on sales and purchase history.
  - Groups customers by age: Young (<30), Middle age (30-55), and Old (>55).
  - Aggregates customer-level metrics including total orders, sales, and products purchased.
  - Calculates valuable KPIs such as recency, average order value, and average monthly spend.
- **Columns:**

| Column Name                | Data Type     | Description                                                                                   |
|----------------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_id                | INT           | Unique identifier for the customer.                                                           |
| customer_name              | NVARCHAR(100) | Full name of the customer (first_name + last_name).                                           |
| age                        | INT           | The calculated age of the customer based on birthdate.                                        |
| birthday                   | DATE          | The date of birth of the customer.                                                            |
| age_group                  | NVARCHAR(50)  | Customer age segment: 'Young', 'Middle age', or 'Old'.                                        |
| customer_type              | NVARCHAR(50)  | Customer classification: 'VIP' (sales > 5000 and history >= 12 months), 'Regular', or 'New'. |
| customer_history_months    | INT           | The lifespan of customer relationship in months.                                              |
| recency_months             | INT           | Number of months since the customer's last order.                                             |
| total_order                | INT           | Total number of distinct orders placed by the customer.                                       |
| total_sales                | INT           | Total monetary value of all sales for the customer.                                           |
| total_quantity             | INT           | Total units purchased by the customer across all orders.                                      |
| total_product              | INT           | Total number of distinct products purchased by the customer.                                  |
| average_order_value        | INT           | Average monetary value per order.                                                             |
| average_monthly_spend      | INT           | Average monthly spending calculated over customer history period.                             |

---

### 5. **gold.vw_product_report**
- **Purpose:** Consolidates key product metrics and behaviors to identify high-performing products.
- **Key Features:**
  - Segments products by revenue performance: High-Performer (>10000), Mid-Range (5000-10000), and Low-Performer (<5000).
  - Aggregates product-level metrics including total orders, sales volume, and unique customer count.
  - Calculates valuable KPIs such as recency, average order revenue, and average monthly revenue.
  - Provides insights into product profitability and customer engagement.
- **Columns:**

| Column Name                | Data Type     | Description                                                                                   |
|----------------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_name               | NVARCHAR(50)  | Descriptive name of the product.                                                              |
| category                   | NVARCHAR(50)  | The broader classification of the product (e.g., Bikes, Components).                          |
| subcategory                | NVARCHAR(50)  | A more detailed classification within the category.                                           |
| cost                       | INT           | The cost or base price of the product.                                                        |
| total_sales                | INT           | Total monetary value of all sales for the product.                                            |
| total_order                | INT           | Total number of distinct orders containing this product.                                      |
| total_quantity             | INT           | Total units of this product sold across all orders.                                           |
| total_customer             | INT           | Total number of distinct customers who purchased this product.                                |
| month_history              | INT           | The lifespan of the product in the database, measured in months.                              |
| recency_months             | INT           | Number of months since the product was last sold.                                             |
| average_order_revenue      | INT           | Average monetary value per order for this product.                                            |
| average_monthly_revenue    | INT           | Average monthly revenue generated by this product.                                            |
| product_type               | NVARCHAR(50)  | Product performance classification: 'High-Performer', 'Mid-Range', or 'Low-Performer'.        |

