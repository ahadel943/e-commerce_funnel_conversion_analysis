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
![erd](./schema/erd.png)

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
- The **users** table contains **50,000** users, the **products** table contains **500** products, the **sessions** table contains **500,000** sessions and the **events** table contains **1,300,369** events.

### **Geographic Distribution of Users**
![users_count_by_country](./charts/1.users_count_by_country.png)
#### **Key Findings**
- The platform has a user base of **50,000** users distributed across **six** primary markets in the Middle East.
- **Egypt** represents the largest user segment, accounting for **39.3%** of all registered users (**19,668 users**), making it the platform's dominant market.
- **UAE** (**14.9%**) and **Saudi Arabia** (**14.7%**) contribute similar user volumes, forming the second-largest user groups after Egypt.
- **Qatar** (**9.8%**), **Kuwait** (**9.7%**), and **Jordan** (**9.6%**) show a relatively balanced distribution, indicating consistent market penetration across these countries.
- **2%** of users have an **unknown** country due to missing values in the source data.
#### **Business Interpretation**
- User acquisition is highly concentrated in **Egypt**, suggesting that the platform's strongest market presence and brand awareness currently exist there.
- While **Egypt** remains the primary growth driver, the relatively similar user shares across the **UAE**, **Saudi Arabia**, **Qatar**, **Kuwait**, and **Jordan** indicate an opportunity to expand regional penetration through targeted acquisition and retention initiatives.
- Further analysis should determine whether user activity and conversion performance follow the same geographic pattern or if some markets generate disproportionately higher engagement and revenue despite having smaller user bases.
### **Users Distribution by Acquisition Source**
![users_count_by_acquisition_source](./charts/2.users_count_by_acquisition_source.png)
#### **Key Findings**
- **Google** is the largest acquisition channel, contributing **30%** of all users (**14,996** users).
- **Facebook** is the second-largest acquisition source, accounting for **25%** of users (**12,457** users).
- Together, **Google** and **Facebook** contribute **55%** of the total user base, making them the primary acquisition drivers.
- **Organic** traffic represents **20%** of users, indicating a meaningful level of non-paid user acquisition.
- **Direct** traffic contributes **15%** of users.
- **Email** is the smallest acquisition source, accounting for **10%** of users.
#### **Business Interpretation**
- User acquisition appears to be heavily driven by marketing channels, particularly **Google** and **Facebook**, which together account for more than half of all registered users.
- The platform maintains a healthy mix of acquisition channels, with **Organic** and **Direct** traffic contributing **35%** of users, reducing complete dependence on paid acquisition.
- While **Email** contributes the smallest share of users, its effectiveness cannot be evaluated based on acquisition volume alone, Further analysis is required to determine whether email-acquired users demonstrate stronger engagement, retention, or conversion behavior than users acquired through other channels.
### **Users Signup Trend**
![users_trend_trend](./charts//3.users_trend_trend.png)
#### **Key Findings**
- User registrations remained relatively stable throughout the analysis period (**January 2024** – **December 2025**).
- Monthly registrations ranged between **1,876** users (**February 2025**) and **2,193** users (**August 2025**).
- No significant spikes or sudden drops were observed, indicating a consistent user acquisition pattern over time.
- Registration volumes in most months remained close to the overall monthly average, suggesting stable acquisition performance across the two-year period.
- Comparing the same months across years reveals slight **year-over-year** fluctuations, with some months in **2025** experiencing **lower** registrations than their **2024** counterparts.
#### **Business Interpretation**
- The platform appears to maintain a steady user acquisition engine without excessive dependence on seasonal campaigns or one-time growth events.
- The absence of extreme peaks or troughs suggests relatively predictable acquisition performance, which can simplify forecasting and capacity planning.
- While some months in **2025** show **lower** registrations than the same months in **2024**, the differences are relatively small and do not indicate a clear **downward** trend.
- Additional analysis of acquisition channels and conversion performance would be required to determine whether these month-to-month variations reflect changes in marketing effectiveness or normal fluctuations in user demand.
### **User Engagement and Session Distribution**
![user_engagement_and_session_distribution](./charts/4.user_engagement_and_session_distribution.png)
#### **Key Findings**
- Users generated between **1** and **19** sessions during the analysis period.
- The **average** number of sessions per user was **6.01** sessions.
- The **median** number of sessions per user was **6** sessions.
- The close alignment between the **mean** and **median** suggests that session activity is relatively balanced and not heavily influenced by a small group of extremely active users.
#### **Business Interpretation**
- The typical user interacts with the platform approximately **six times** during the two-year period.
- User engagement appears to be broadly distributed across the user base rather than concentrated among a small number of highly active users.
- The similarity between the **average** and **median** session counts indicates that the platform does not rely heavily on a few power users to drive overall activity.
- This pattern suggests a relatively healthy engagement distribution, where user activity is spread across a large portion of the customer base.
### **User Engagement and Session Distribution by Device Type**
![user_engagement_and_ession_distribution_by_device_type](./charts/5.user_engagement_and_ession_distribution_by_device_type.png)
#### **Key Findings**
- **Mobile** devices account for **65%** of all sessions (**194,961** sessions), making them the **dominant** platform used by customers.
- **Desktop** devices account for **35%** of sessions (**105,039** sessions).
- **Mobile** users generate an average of **3.98** sessions per user with a median of **4** sessions.
- **Desktop** users generate an average of **2.40** sessions per user with a median of **2** sessions.
- The highest observed engagement was also higher on **Mobile** (**15** sessions) compared to **Desktop** (**10** sessions).
#### **Business Interpretation**
- User activity is heavily concentrated on **Mobile** devices, both in terms of traffic volume and engagement frequency.
- Mobile users not only represent the majority of sessions but also return more frequently than Desktop users.
- The typical **Mobile** user generates approximately **4** sessions, compared to only **2** sessions for the typical **Desktop** user.
- These findings suggest that the mobile experience plays a critical role in overall platform engagement and should be a primary focus area when evaluating funnel performance and conversion optimization.
### **Sessions Volume by Traffic Source**
![sessions_volume_by_traffic_source](./charts/6.sessions_volume_by_traffic_source.png)
#### **Key Findings**
- **Google** is the largest traffic source, generating **29%** of all sessions (**87,182** sessions).
- **Facebook** is the second-largest traffic source, contributing **24%** of total sessions (**72,479** sessions).
- Together, **Google** and **Facebook** account for **53%** of all platform sessions, making them the primary traffic drivers.
- **Organic** traffic contributes **19%** of sessions, representing a substantial share of user activity generated through **non-paid** channels.
- **Direct** traffic accounts for **15%** of sessions, indicating a meaningful level of direct user engagement with the platform.
- **Email** generates **10%** of sessions, making it the smallest identified traffic source.
- **3%** of sessions have an **unknown** traffic source due to missing values in the original dataset.
#### **Business Interpretation**
- The platform relies heavily on **Google** and **Facebook** as its primary traffic acquisition channels, with more than half of all user sessions originating from these sources.
- Despite the dominance of **paid** and **campaign-driven** channels, **Organic** and **Direct** traffic collectively generate 34% of sessions, suggesting that the platform benefits from existing brand awareness and non-paid user acquisition.
- The relatively strong contribution from **Organic** traffic may indicate effective discoverability and ongoing user interest beyond paid marketing efforts.
- Further analysis is required to determine whether the channels generating the most traffic also produce the highest levels of engagement and conversion throughout the funnel.
### **Events Volume Sanity Check**
![events_volume_sanity_check](./charts/7.events_volume_sanity_check.png)
#### **Key Findings**
- The dataset contains **896,610 product view events**, representing the largest volume of activity in the customer journey.
- **265,702 add-to-cart** events were recorded, indicating that only a subset of product views progressed to purchase intent.
- **92,314 begin checkout events** were generated, showing a substantial reduction in user activity between cart creation and checkout initiation.
- The funnel ends with **45,743 purchase events**, representing the smallest event volume in the customer journey.
- Event counts decrease consistently across all funnel stages (**Product View** → **Add to Cart** → **Begin Checkout** → **Purchase**), following the expected customer purchase flow.
#### **Business Interpretation**
- User activity declines at every stage of the purchasing journey, indicating the presence of natural conversion **drop-offs** throughout the funnel.
- **Product views** generate the **highest** level of engagement, but a **significant** portion of users do not progress to adding products to their carts.
- Additional user loss occurs between the **cart** and **checkout** stages, suggesting potential friction points before purchase completion.
- The consistent decrease in event volumes across stages indicates that the event data follows a logical purchase journey and is suitable for funnel conversion analysis.
- These results provide an initial view of customer behavior, however, event counts alone do not measure conversion performance. Session-level funnel analysis is required to quantify conversion rates and identify the stages with the largest drop-offs.
### **Sessions Distribution by Funnel Stage**
![sessions_distribution_by_funnel_stage](./charts/8.sessions_distribution_by_funnel_stage.png)
#### **Key Findings**
- **299,795** sessions reached the **Product View** stage, making it the most common stage in the customer journey.
- **180,298** sessions progressed to **Add to Cart**, indicating a substantial reduction from the initial product-view stage.
- **77,186** sessions reached **Begin Checkout**, showing a significant drop between cart creation and checkout initiation.
- **41,563** sessions completed a **Purchase**, representing the smallest share of sessions in the funnel.
- The number of sessions decreases consistently across all stages (**Product View** → **Add to Cart** → **Begin Checkout** → **Purchase**), following the expected progression of an e-commerce purchasing journey.
#### **Business Interpretation**
- The majority of shopping sessions begin with product browsing, but only a portion of those sessions progress to later stages of the funnel.
- A noticeable decline occurs between **Product View** and **Add to Cart**, suggesting that many users browse products without expressing purchase intent.
- Additional **drop-offs** occur between **Add to Cart** and **Begin Checkout**, indicating potential friction before users commit to the checkout process.
- The continued decline toward **Purchase** highlights that only a subset of shopping sessions ultimately convert into completed transactions.
- The consistent stage-to-stage reduction confirms that the dataset follows a logical funnel structure and is suitable for **session-based conversion analysis**.
### **Unique Users Distribution by Funnel Stage**
![unique_users_distribution_by_funnel_stage](./charts/9.unique_users_distribution_by_funnel_stage.png)
#### **Key Findings**
- Nearly all users (**49,882** out of **50,000**) reached the **Product View** stage at least once during the analysis period.
- **48,656 users** progressed to **Add to Cart**, indicating that most users who viewed products eventually expressed purchase intent.
- **39,224** users reached **Begin Checkout**, while **28,206 users** completed at least one purchase.
- Event participation decreases consistently across funnel stages, following the expected customer journey.
- Approximately **56% of users completed at least one purchase** during the two-year observation period.
#### **Business Interpretation**
- Product discovery and initial purchase intent appear strong, as the majority of users progressed from product viewing to adding items to their carts.
- User drop-off becomes more pronounced during the checkout process, suggesting that purchase completion represents the primary conversion challenge.
- More than half of the user base completed at least one purchase, indicating a relatively healthy long-term customer conversion rate.
- Because users can generate multiple sessions over time, user-level participation should not be interpreted as funnel conversion. A session-based funnel analysis is required to accurately measure stage-to-stage conversion rates and identify where shopping sessions are being lost.

## **Analysis Unit**
**The funnel analysis was conducted at the session level, using session_id as the primary unit of analysis.**

**This approach was chosen because the dataset captures user interactions as event sequences occurring within individual sessions. The funnel stages (product_view → add_to_cart → begin_checkout → purchase) represent actions that can occur during a single visit to the platform, making the session the most appropriate level for measuring progression through the funnel.**

**While user-level analysis is also possible, a single user may generate multiple sessions with different outcomes. Measuring conversion at the user level could therefore combine multiple journeys into one observation and obscure where drop-offs occur. Using sessions allows each shopping journey to be evaluated independently, providing a more accurate view of funnel performance and stage-to-stage conversion behavior.**

## **Key Business Questions**
- **1. What is the overall funnel conversion rate?**
- **2. How does conversion perform at each stage of the funnel?**
- **3. Where is the largest drop-off occurring in the funnel?**
- **4. How many users and sessions reach each funnel stage?**
- **5. How does funnel conversion differ by device type?**
- **6. How does funnel conversion differ by traffic source?**
- **7. How does funnel conversion vary across countries?**
- **8. Which product categories generate the highest purchase conversion rates?**
- **9. How does product price influence conversion behavior?**

## **Analysis**
### **1. What is the overall funnel conversion rate?**
![sessions_conversion_funnel](./charts/10.sessions_conversion_funnel.png)
#### **Key Insights**
- **299,795** sessions entered the funnel through the **Product View** stage, representing the starting point of the customer journey.
- **180,298** sessions progressed to **Add to Cart**, resulting in a **60.14%** Survival Rate from the initial stage.
- **77,186** sessions reached the **Begin Checkout** stage, corresponding to a **25.75%** Survival Rate from Product View.
- **41,563** sessions completed a **purchase**, producing an Overall Funnel Conversion Rate of **13.86%**.
- The cumulative decline in session counts across the funnel indicates progressive user **drop-off** as customers move toward completing a purchase.
#### **Business Interpretation**
- Approximately **4 out of every 10 sessions** exited the funnel before adding a product to the cart, While this represents the first major reduction in funnel volume, additional analysis is required to determine whether the drop-off is driven by product attractiveness, pricing, user experience, or expected customer behavior.
- Only about **one quarter** of sessions that viewed a product progressed to the checkout stage, indicating substantial cumulative abandonment before users initiated the payment process.
- The platform achieved an **Overall Conversion Rate of 13.86%**, meaning that roughly **14 out of every 100** product-view sessions resulted in a completed purchase, This provides an initial indication of funnel performance but does not identify where the most significant conversion losses occur.
- Since survival rates measure cumulative progression from the first funnel stage, they do not reveal the efficiency of transitions between consecutive stages, Therefore, the next step is to analyze Stage-to-Stage Conversion Rates to accurately identify the funnel stage with the highest user drop-off.
---
### **2. How does conversion perform at each stage of the funnel?**
![stage_to_stage_conversion_rate](./charts/11.stage_to_stage_conversion_rate.png)
#### **Key Insights**
- **60.14%** of sessions progressed from **Product View** to **Add to Cart**.
- The conversion rate decreased to **42.81%** between **Add to Cart** and **Begin Checkout**, representing the lowest conversion rate across all funnel transitions.
- **53.85%** of sessions that reached **Begin Checkout** completed a purchase.
- The transition from **Add to Cart** to **Begin Checkout** experienced the highest stage-specific drop-off, with **57.19%** of sessions failing to continue.
#### **Business Interpretation**
- A majority of product-view sessions progressed to the **Add to Cart** stage, indicating that many visitors showed initial purchase intent after viewing a product.
- The most significant conversion **loss** occurred between **Add to Cart** and **Begin Checkout**, where fewer than half of cart sessions advanced to the checkout process, This stage represents the primary opportunity for further investigation and optimization.
- Once users entered the checkout process, more than half successfully completed a purchase, suggesting that the checkout experience retains a relatively large proportion of engaged customers.
- Since the largest drop-off occurs before checkout begins, future analysis should focus on understanding why users abandon their carts before initiating the payment process. Potential areas for investigation include pricing, shipping costs, account requirements, or other sources of friction prior to checkout.