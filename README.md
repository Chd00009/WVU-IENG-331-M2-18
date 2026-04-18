# Milestone 2: Python Pipeline

**Team 18**: Christopher D'Antonio

## How to Run

Instructions to run the pipeline from a fresh clone:

```bash
git clone https://github.com/Chd00009/WVU-IENG-331-M2-18.git
cd WVU-IENG-331-M2-18
uv sync
# place olist.duckdb in the data/ directory
uv run wvu-ieng-331-m2-18
uv run wvu-ieng-331-m2-18 --start-date 2026-01-01 --seller-id <SELLER_ID>
```

## Parameters

| Parameter      | Type   | Default          | Description                                      |
| -------------- | ------ | ---------------- | ------------------------------------------------ |
| `--db-path`    | string | required         | Path to the DuckDB database file                 |
| `--start-date` | date   | None (no filter) | Filters results to include data after this date  |
| `--end-date`   | date   | None (no filter) | Filters results to include data before this date |
| `--seller-id`  | string | None (no filter) | Filters results for a specific seller            |

## Outputs

The pipeline generates three output files in the output/ directory:

summary.csv
Contains aggregated results based on the ABC classification query. This file provides a high-level summary of performance.
detail.parquet
Contains the full dataset returned by the ABC classification query. This is a detailed dataset suitable for further analysis.
chart.html
An interactive Altair visualization saved as a self-contained HTML file. This provides a quick visual overview of the results.

## Validation Checks

Before running any analysis, the pipeline performs the following validation checks:

Verifies that all required tables exist:
orders
order_items
customers
products
sellers
geolocation
order_payments
order_reviews
category_translation
Logs a warning and stops execution if any required table is missing.
Logs confirmation that the dataset schema is valid and that the pipeline is holdout-safe (no assumptions about row counts or date ranges).

If validation fails, the pipeline stops and logs an error message.

## Analysis Summary

The pipeline performs an ABC classification analysis on the dataset. This categorizes items based on their contribution to overall performance:

A-class items: Highest contribution to total value
B-class items: Moderate contribution
C-class items: Lowest contribution

This analysis helps identify which products or sellers drive the majority of value, supporting prioritization and decision-making.

## Limitations & Caveats

The pipeline assumes the database schema matches the expected Olist dataset structure.
Filtering parameters (--start-date, --end-date, --seller-id) are included but may not fully affect all queries depending on SQL implementation.
The visualization is a simple exploratory chart and not a full analytical dashboard.
No advanced error recovery is implemented; failures will stop execution.
The pipeline does not handle corrupted or invalid database files beyond basic validation.
