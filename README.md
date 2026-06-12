# E-commerce Funnel Conversion Analysis

## **Project Overview**
This project analyzes customer behavior across an e-commerce conversion funnel, tracking the journey from product views to completed purchases.

Using **event-level** data, the analysis examines how users progress through key funnel stages, identifies where **drop-offs** occur, and evaluates conversion performance across **customer segments**, **devices**, **traffic sources**, and **product categories**.

The project also includes a complete data quality assessment and cleaning process, addressing **missing values**, **duplicate records**, **orphan records**, and **event-sequence anomalies** before conducting business analysis.

The ultimate goal is to uncover factors limiting conversion performance and provide actionable recommendations to improve customer acquisition efficiency and overall sales conversion.

## **Business Problem**
The company is experiencing high website traffic and strong product engagement, yet overall purchase conversion remains below expectations.

Management wants to understand where potential customers are dropping out of the purchasing journey and whether specific customer segments, traffic channels, devices, or product categories are contributing to conversion losses.

To address this challenge, the analysis focuses on:
- Measuring conversion rates across each stage of the funnel.
- Identifying the largest drop-off points in the customer journey.
- Comparing conversion performance across devices, traffic sources, and product categories.
- Evaluating differences between new and returning customers.
- Detecting operational or behavioral factors that negatively impact purchase completion.

The findings will help the business prioritize improvements that increase conversion rates and maximize revenue from existing website traffic.

## **Executive Summary**
**NO Summary Yet**

## **Dataset Description**
| Table       | Description                             |
| ----------- | --------------------------------------- |
| users       | Customer-level information including signup date, country, and acquisition  source.                                                 |
| sessions    | Session-level records capturing user visits, traffic channels, and device information.                                            |
| events      | Event-level behavioral data tracking customer actions across the conversion funnel.                                                 |
| products    | Product catalog containing category and pricing information for product performance analysis.                                               |

## **Schema Design**
**NO Schema Yet**

## **Data Preparation and EDA**
### **Data Quality Assessment**
- Checked for duplicate records.
- Checked for primary key uniqueness.
- Checked for missing values.
- Validated referential integrity.
- Validated event sequence consistency.

#### **Issues Found**
**Missing Values**
- **1,000** null values were found in the '**country**' filed in the '**users**' table
- **9,000** null values were found in the '**traffic_source**' field in the '**sessions**' table.
- Exact duplicate rows were identified in the **events** table, resulting in **12,839** extra rows to be removed, duplicates also caused primary key uniqueness violations in the event_id field.
- - **6,567** orphan event records referencing non-existent sessions.

### **Data Cleaning Process**
- The missing values in the **country** field were replaced with '**Unknown**' to preserve user records while maintaining data completeness.
- The missing **traffic source** values (**3% of sessions**) were replaced with '**Unknown**' to preserve session records and avoid **introducing bias** through imputation.

### **Exploratory Data Analysis (EDA)**
