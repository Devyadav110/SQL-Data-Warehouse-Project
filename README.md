# SQL Data Warehouse Project

A practice project designed to solidify understanding of SQL and data warehouse concepts through hands-on implementation.

## 📋 Project Overview

This project implements a SQL-based data warehouse using the **Medallion Architecture** (Bronze, Silver, Gold layers), a best-practice approach for organizing and processing data at different stages of quality and refinement.

### Architecture Layers

- **Bronze Layer**: Raw data ingestion from source systems (CRM and ERP)
- **Silver Layer**: Cleaned, validated, and deduplicated data
- **Gold Layer**: Business-ready, aggregated data for analytics and reporting

## 📁 Project Structure

```
SQL-Data-Warehouse-Project/
├── README.md                      # This file
├── script/                         # SQL scripts for warehouse setup and transformations
│   ├── init_database.sql          # Database and schema initialization
│   ├── bronze/                    # Bronze layer transformation scripts
│   ├── silver/                    # Silver layer transformation scripts
│   └── gold/                      # Gold layer transformation scripts
└── datasets/                       # Source data storage
    ├── source_crm/               # CRM system data files
    └── source_erp/               # ERP system data files
```

## 🚀 Getting Started

### Prerequisites

- SQL Server (2016 or later recommended)
- SQL Server Management Studio (SSMS) or similar SQL client
- Basic understanding of SQL and database concepts

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/Devyadav110/SQL-Data-Warehouse-Project.git
   cd SQL-Data-Warehouse-Project
   ```

2. **Initialize the database**
   ```sql
   -- Run the initialization script in SQL Server Management Studio
   -- This creates the DataWarehouse database with Bronze, Silver, and Gold schemas
   ```
   Execute `script/init_database.sql`

   **⚠️ WARNING**: This script will drop the existing `DataWarehouse` database if it exists. Ensure you have proper backups before running.

3. **Load source data**
   - Place CRM data files in `datasets/source_crm/`
   - Place ERP data files in `datasets/source_erp/`

4. **Execute transformation scripts**
   - Run bronze layer scripts to load raw data
   - Run silver layer scripts to clean and validate data
   - Run gold layer scripts to create analytics-ready tables

## 📚 Learning Objectives

This project covers:

- **Database Design**: Schema design and organization
- **Data Integration**: Loading data from multiple sources
- **Data Transformation**: ETL/ELT processes
- **Data Quality**: Validation and error handling
- **SQL Skills**: Complex queries, stored procedures, and best practices
- **Data Warehouse Architecture**: Medallion architecture pattern

## 🔧 Scripts Overview

### `script/init_database.sql`
- Creates the `DataWarehouse` database
- Establishes three schemas: `bronze`, `silver`, and `gold`
- Sets up the foundational structure for the warehouse

### Bronze Layer Scripts
Handles raw data ingestion from source systems with minimal transformation.

### Silver Layer Scripts
Applies data cleaning, validation, deduplication, and enrichment.

### Gold Layer Scripts
Creates final tables optimized for reporting and analytics.

## 📊 Data Sources

- **CRM System**: Customer Relationship Management data (customers, interactions, sales)
- **ERP System**: Enterprise Resource Planning data (inventory, financials, operations)

## 🤝 Contributing

This is a practice project. Feel free to fork and modify it for your own learning purposes.

## 📝 Notes

- All SQL scripts are written in T-SQL (SQL Server syntax)
- The project uses a dev-friendly approach with clear schema separation
- Each layer can be tested and validated independently

## 📚 References & Resources

- [SQL Server Documentation](https://learn.microsoft.com/en-us/sql/)
- [Data Warehouse Design Best Practices](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/design-elt-data-loading)
- [Medallion Architecture Pattern](https://docs.databricks.com/en/lakehouse/medallion.html)

## 📄 License

This project is created for educational purposes.

---

**Last Updated**: May 2026

**Status**: 🚧 In Development - Practice Project

