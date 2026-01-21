# Azure SQL to Power BI — Setup Notes

This document outlines the planned setup for an **Azure SQL Database to Power BI** integration, demonstrating a simple cloud-based analytics workflow.

## Objective
To show how data stored in **Azure SQL Database** can be securely connected and analysed using **Power BI**, aligned with Azure data fundamentals.

## Architecture Overview
The intended architecture follows a simple flow:

1. Data stored in Azure SQL Database  
2. Secure connection from Power BI Desktop  
3. Data modelling and reporting in Power BI  

This setup reflects common entry-level analytics scenarios used in small and medium-sized organisations.

## Azure Services Involved
- **Azure SQL Database**
- **Azure Resource Group**
- **Azure SQL Server**
- **Power BI Desktop**

## Planned Steps
1. Create an Azure SQL Database and load sample data
2. Configure firewall and authentication settings
3. Connect Power BI Desktop to Azure SQL Database
4. Import and model the data in Power BI
5. Build a basic analytics report

## Notes
- Authentication will use Azure SQL authentication or Microsoft Entra ID where applicable
- No production data is used
- The focus is on understanding data flow rather than advanced security or optimisation

This project is intentionally kept **simple and transparent** to reflect a realistic junior data analyst workflow.

