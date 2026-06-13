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

## **Data Preparation**
### **Data Quality Assessment**
A comprehensive data quality assessment was performed before moving data from the **raw** layer to the **analytics** layerو The assessment focused on validating data completeness, uniqueness, referential integrity, and event consistency to ensure the dataset was reliable for funnel analysis.

The following checks were performed:
- Checked for exact duplicate records across all tables.
- Validated primary key uniqueness.
- Assessed missing values and data completeness.
- Validated referential integrity between related tables.
- Identified orphan records.
- Validated timestamp consistency.
- Verified event sequence consistency within user sessions.
- Evaluated event-level integrity before creating the analytical layer.

### **Issues Found**
**Missing Values**
- **1,000** missing values were found in the country column of the users table (**2%** of users).
- **9,000** missing values were found in the **traffic_source** column of the sessions table (**3%** of sessions).

**Duplicate Records**
- The events table contained **25,678** duplicated records, resulting in **12,839** redundant rows that needed to be removed.
- Duplicate event records also introduced **primary key uniqueness violations** in the **event_id** field.

**Primary Key Integrity Violations**
- Additional investigation revealed that some duplicated **event_id** values were not simple duplicate rows.
- Multiple records shared the same **event_id** while containing conflicting event definitions, violating the assumption that each **event_id** should uniquely identify a single event.

**Referential Integrity Issues**
- **6,567** orphan event records were identified where the referenced **session_id** did not exist in the sessions dataset.
- No orphan records were found for **user_id** or **product_id** relationships.

### **Data Cleaning Process**
The following cleaning and validation steps were applied before loading the data into the **analytics** schema:

**Handling Missing Values**
- Missing values in the **country** column were replaced with '**Unknown**' to preserve user records while maintaining dataset completeness.
- Missing values in the **traffic_source** column were replaced with '**Unknown**' rather than imputing a dominant source value, preventing the introduction of artificial acquisition patterns and preserving analytical neutrality.

**Removing Duplicate Records**
- Exact duplicate event records were identified using a window-function-based deduplication approach.
- Only the first occurrence of each duplicated event record was retained, while redundant copies were excluded from the analytics layer.

**Resolving Primary Key Violations**
- After removing exact duplicates, additional **event_id** uniqueness violations remained.
- Since **event_id** is expected to uniquely identify an event, only one record was retained per conflicting **event_id**, and duplicate event definitions were excluded from the analytical dataset.

**Resolving Referential Integrity Issues**
- Orphan event records referencing **non-existent** sessions were excluded during the loading process.
- Referential integrity was enforced by loading only events associated with valid sessions in the analytics layer.

### **Final Validation**
**After cleaning**:
- All primary keys were unique.
- No orphan records remained.
- Foreign key relationships were successfully enforced.
- The dataset was successfully loaded into the **analytics** schema and validated for funnel analysis.

### Performance Optimization
Indexes were created on frequently joined and filtered columns to improve analytical query performance, particularly for funnel stage calculations, session-level analysis, and event aggregation.

## **Exploratory Data Analysis (EDA)**