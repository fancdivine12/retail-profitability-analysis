
# Retail Profitability Analysis
# Tool: R
# Purpose:
# Validate Excel and SQL findings, summarize profitability,
# export summary tables, and create visuals for portfolio use.

# =========================================================
# 1. Install and load packages
# =========================================================

packages <- c("tidyverse", "janitor", "scales", "lubridate")

installed_packages <- rownames(installed.packages())

for (pkg in packages) {
  if (!(pkg %in% installed_packages)) {
    install.packages(pkg)
  }
}

library(tidyverse)
library(janitor)
library(scales)
library(lubridate)

# =========================================================
# 2. Create output folders
# =========================================================

dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/r", showWarnings = FALSE)
dir.create("visuals", showWarnings = FALSE)
dir.create("visuals/r", showWarnings = FALSE)

# =========================================================
# 3. Load Orders CSV
# =========================================================
# This file must be in your main Posit project folder.

orders <- read_csv("retail_analysis(Orders).csv") %>%
  clean_names()

# Preview dataset structure
glimpse(orders)

# =========================================================
# 4. Data quality checks
# =========================================================

total_rows <- nrow(orders)
duplicate_rows <- sum(duplicated(orders))
missing_values <- colSums(is.na(orders))

print("Total rows:")
print(total_rows)

print("Duplicate rows:")
print(duplicate_rows)

print("Missing values by column:")
print(missing_values)

data_quality_summary <- tibble(
  total_rows = total_rows,
  duplicate_rows = duplicate_rows,
  missing_region = sum(is.na(orders$region)),
  missing_category = sum(is.na(orders$category)),
  missing_sub_category = sum(is.na(orders$sub_category)),
  missing_segment = sum(is.na(orders$segment)),
  missing_sales = sum(is.na(orders$sales)),
  missing_profit = sum(is.na(orders$profit))
)

write_csv(data_quality_summary, "outputs/r/r_data_quality_summary.csv")

# =========================================================
# 5. Clean analysis dataset
# =========================================================

orders_clean <- orders %>%
  drop_na(region, category, sub_category, segment, sales, profit) %>%
  mutate(
    order_date = as.Date(parse_date_time(as.character(order_date), orders = c("mdy", "ymd", "dmy"))),
    ship_date = as.Date(parse_date_time(as.character(ship_date), orders = c("mdy", "ymd", "dmy"))),
    profit_margin = if_else(sales == 0, NA_real_, profit / sales)
  )

# =========================================================
# 6. Overall business performance
# =========================================================

overall_performance <- orders_clean %>%
  summarise(
    total_sales = round(sum(sales, na.rm = TRUE), 2),
    total_profit = round(sum(profit, na.rm = TRUE), 2),
    overall_profit_margin_pct = round((total_profit / total_sales) * 100, 2)
  )

print(overall_performance)

write_csv(overall_performance, "outputs/r/r_overall_business_performance.csv")

# =========================================================
# 7. Profitability by category
# =========================================================

category_profitability <- orders_clean %>%
  group_by(category) %>%
  summarise(
    total_sales = round(sum(sales, na.rm = TRUE), 2),
    total_profit = round(sum(profit, na.rm = TRUE), 2),
    profit_margin_pct = round((total_profit / total_sales) * 100, 2),
    .groups = "drop"
  ) %>%
  arrange(desc(total_profit))

print(category_profitability)

write_csv(category_profitability, "outputs/r/r_profit_by_category.csv")

# =========================================================
# 8. Profitability by sub-category
# =========================================================

subcategory_profitability <- orders_clean %>%
  group_by(sub_category) %>%
  summarise(
    total_sales = round(sum(sales, na.rm = TRUE), 2),
    total_profit = round(sum(profit, na.rm = TRUE), 2),
    profit_margin_pct = round((total_profit / total_sales) * 100, 2),
    .groups = "drop"
  ) %>%
  arrange(total_profit)

print(subcategory_profitability)

write_csv(subcategory_profitability, "outputs/r/r_profit_by_subcategory.csv")

# =========================================================
# 9. Loss-driving sub-categories
# =========================================================

loss_drivers <- subcategory_profitability %>%
  filter(total_profit < 0) %>%
  arrange(total_profit)

print(loss_drivers)

write_csv(loss_drivers, "outputs/r/r_loss_driving_subcategories.csv")

# =========================================================
# 10. Profitability by region
# =========================================================

region_profitability <- orders_clean %>%
  group_by(region) %>%
  summarise(
    total_sales = round(sum(sales, na.rm = TRUE), 2),
    total_profit = round(sum(profit, na.rm = TRUE), 2),
    profit_margin_pct = round((total_profit / total_sales) * 100, 2),
    .groups = "drop"
  ) %>%
  arrange(desc(total_profit))

print(region_profitability)

write_csv(region_profitability, "outputs/r/r_profit_by_region.csv")

# =========================================================
# 11. Profitability by customer segment
# =========================================================

segment_profitability <- orders_clean %>%
  group_by(segment) %>%
  summarise(
    total_sales = round(sum(sales, na.rm = TRUE), 2),
    total_profit = round(sum(profit, na.rm = TRUE), 2),
    profit_margin_pct = round((total_profit / total_sales) * 100, 2),
    .groups = "drop"
  ) %>%
  arrange(desc(total_profit))

print(segment_profitability)

write_csv(segment_profitability, "outputs/r/r_profit_by_segment.csv")

# =========================================================
# 12. Discount impact by sub-category
# =========================================================

discount_impact <- orders_clean %>%
  group_by(sub_category) %>%
  summarise(
    avg_discount_pct = round(mean(discount, na.rm = TRUE) * 100, 2),
    total_sales = round(sum(sales, na.rm = TRUE), 2),
    total_profit = round(sum(profit, na.rm = TRUE), 2),
    profit_margin_pct = round((total_profit / total_sales) * 100, 2),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_discount_pct))

print(discount_impact)

write_csv(discount_impact, "outputs/r/r_discount_impact_by_subcategory.csv")

# =========================================================
# 13. High sales but weak profit
# =========================================================

avg_subcategory_sales <- mean(subcategory_profitability$total_sales, na.rm = TRUE)

high_sales_weak_profit <- subcategory_profitability %>%
  filter(total_sales > avg_subcategory_sales) %>%
  arrange(profit_margin_pct)

print(high_sales_weak_profit)

write_csv(high_sales_weak_profit, "outputs/r/r_high_sales_weak_profit.csv")

# =========================================================
# 14. Visual 1: Profit by sub-category
# =========================================================

profit_by_subcategory_plot <- ggplot(
  subcategory_profitability,
  aes(x = reorder(sub_category, total_profit), y = total_profit)
) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Profit by Sub-Category",
    subtitle = "Tables, Bookcases, and Supplies showed negative profitability",
    x = "Sub-Category",
    y = "Total Profit"
  ) +
  scale_y_continuous(labels = label_dollar())

ggsave(
  "visuals/r/r_profit_by_subcategory.png",
  profit_by_subcategory_plot,
  width = 10,
  height = 6
)

# =========================================================
# 15. Visual 2: Sales vs Profit by sub-category
# =========================================================

sales_vs_profit_plot <- ggplot(
  subcategory_profitability,
  aes(x = total_sales, y = total_profit, label = sub_category)
) +
  geom_point() +
  geom_text(check_overlap = TRUE, vjust = -0.5) +
  labs(
    title = "Sales vs Profit by Sub-Category",
    subtitle = "High sales did not always result in strong profit",
    x = "Total Sales",
    y = "Total Profit"
  ) +
  scale_x_continuous(labels = label_dollar()) +
  scale_y_continuous(labels = label_dollar())

ggsave(
  "visuals/r/r_sales_vs_profit_by_subcategory.png",
  sales_vs_profit_plot,
  width = 10,
  height = 6
)

# =========================================================
# 16. Visual 3: Profit by region
# =========================================================

profit_by_region_plot <- ggplot(
  region_profitability,
  aes(x = reorder(region, total_profit), y = total_profit)
) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Profit by Region",
    subtitle = "Profitability varied across regions",
    x = "Region",
    y = "Total Profit"
  ) +
  scale_y_continuous(labels = label_dollar())

ggsave(
  "visuals/r/r_profit_by_region.png",
  profit_by_region_plot,
  width = 8,
  height = 5
)

# =========================================================
# 17. Visual 4: Average discount vs profit margin
# =========================================================

discount_impact_plot <- ggplot(
  discount_impact,
  aes(x = avg_discount_pct, y = profit_margin_pct, label = sub_category)
) +
  geom_point() +
  geom_text(check_overlap = TRUE, vjust = -0.5) +
  labs(
    title = "Average Discount vs Profit Margin",
    subtitle = "Higher discounts may be related to weaker profitability",
    x = "Average Discount (%)",
    y = "Profit Margin (%)"
  )

ggsave(
  "visuals/r/r_discount_vs_profit_margin.png",
  discount_impact_plot,
  width = 10,
  height = 6
)

# =========================================================
# 18. Final message
# =========================================================

print("R analysis complete. Summary tables saved in outputs/r and visuals saved in visuals/r.")
