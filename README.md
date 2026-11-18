# Dataco Supply Chain Analysis
> 🚧 **PROJECT IN PROGRESS**  
> Findings and reccomendations are not final and may change due to further analysis.

## Business Question
>### Where in the fulfillment network are late deliveries hurting profit, and which markets, shipping modes, and product categories should the company fix first?

## SQL Analysis
>### 1. Which shipping modes underperform within each market?
- The shipping mode, First Class, overwhelmingly underperformed for all 5 markets (Pacific Asia, Europe, USCA, LATAM, Africa), with a late rate of 100%. The shipping modes following First Class are Second Class (79.43% - 80.44%), Same Day (45.64% - 50.80%) and Standard Class (39.34% - 40.35%) in that order.
- Further analysis confirms the 100% late rate is real. Every First Class order is scheduled for 1 day but takes 2, so the service is late by design. The data points to a wrong delivery promise, not random failures. Canceled and fraud orders make up only 4.7% of First Class orders, so excluding them wouldn’t change the result.

>### 2. Do late orders earn less profit, and in which categories is the gap biggest?
- Late orders earned 28.42% more total profit because they outnumber non-late orders by 34%. The profit gap comes from volume, not from late orders being more profitable. If lateness costs the business anything, it isn't showing up in margin.
- Late deliveries barely affect profit margin in this dataset. Late orders have a 10.65% margin vs. 11.57% for non-late orders, a gap of 0.92 percentage points.
- The top 3 categories by profit gap are Fishing ($87,698), Cleats ($64,891), and Water Sports ($49,984). Fishing and Cleats rank near the top for both late and non-late profit, so their gaps mostly reflect category size, and their non-late margins are slightly higher (0.61 and 0.17 percentage points). Water Sports is the exception: it ranks 9th for late profit vs. 16th for non-late, and its late margin is 0.35 percentage points higher.

>### 3. What are the top 3 products in each region, and how much of the region's profit do they carry? 
- The same few products lead profit in nearly all regions. Only 6 products appear in the top 3 across all 23 regions and the Field & Stream Gun Fire Safe is #1 in 22 of them.
- The top 3 products carry 31% to 55% of regional profit so profit is heavily concentrated in those products. Field Safe alone accounts for 11% to 27% of regional profits.
- The few regions with different leading products (Central Africa, Central Asia, East Africa) are small, so those ranking reflect small profit totals.

>### 4. How is the late rate trending, and when did it spike?
- The late rate is flat. After the first two months, the 3-month rolling average stays between 56.51% (06-2017) and 58.19% (06-2016), a spread of under 2 points. The first two values average fewer than 3 months, so I excluded them.
- There were no real spikes. Monthly late rates stay between 55.04% and 59.86%. The biggest jump was +2.68 percentage points (05-2017). The biggest drop was -4.38 points (07-2016), a fall back from 06-2016’s high.
- Monthly sales show no relationship with the late rate (correlation: X). Separately, sales dropped sharply in the last three months of data while order volume held steady. This is unexplained and noted for follow-up.
- A late rate that holds near 57% for three years points to a structural cause.

>### 5. Do customers with a late first order come back less?
- Customers with a late first order returned at 57.33% (6,653 of 11,605), vs. 57.66% (4,991 of 8,656) for on-time first orders, a 0.33 point gap
- Late delivery doesn’t appear to affect repeat purchases in this dataset, consistent with Q2, where lateness barely changed margin.
- **Limitations:** Some customers placed their first order shortly before the data ended, leaving less time for us to determine if they placed a second order or more.