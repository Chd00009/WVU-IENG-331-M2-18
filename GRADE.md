# Milestone 2 Grade (Regrade)

**Team 18**

*This grade reflects the resubmitted work. Original score was 17/24.*

| Criterion | Score | Max |
|-----------|------:|----:|
| Pipeline Functionality | 5 | 6 |
| Parameterization | 5 | 6 |
| Code Quality | 5 | 6 |
| Project Structure | 2 | 3 |
| Design | 3 | 3 |
| **Total** | **20** | **24** |

---

## Pipeline Functionality (5/6)

**Fixed:** `--db-path` now has `default="data/olist.duckdb"` — the pipeline runs with no arguments and finds the database automatically. The ABC classification SQL (`abc_classification.sql`) now correctly computes tiering: it builds `cumulative_pct` as a running share of total revenue and applies a CASE statement assigning A (≤80%), B (≤95%), C (otherwise). Output columns are `product_id`, `total_revenue`, `cumulative_pct`, `abc_class`. Verified: on the standard dataset, 8 126 A-items, 10 932 B-items, 13 893 C-items. All three required output files (summary.csv, detail.parquet, chart.html) are produced. Holdout dataset (olist_extended.duckdb) passes cleanly.

**Remaining issue:** `--start-date` and `--end-date` are still not wired through in `pipeline.py`. The fix was applied at the query layer — `get_abc_classification()` in queries.py accepts `start_date` and `end_date`, and the SQL uses `$1`/`$2` — but `pipeline.py` line 50 calls `get_abc_classification(args.db_path)` without those arguments. Running the pipeline with `--start-date 2025-01-01 --end-date 2025-06-30` produces the same 32 951 rows as an unfiltered run. One point deducted.

---

## Parameterization (5/6)

**Fixed:** `--db-path` default is now set (no longer required). `--start-date` and `--end-date` are now handled in the query layer: the SQL uses positional parameters `$1` and `$2` with `NULL`-safe guards (`$1 IS NULL OR ...`), and `get_abc_classification()` accepts and binds them correctly. `--seller-id` continues to work correctly, filtering seller scorecard output.

**Remaining issue:** The connection between the CLI argument parsing and the query call is incomplete. `args.start_date` and `args.end_date` exist after parsing but are never forwarded to `get_abc_classification()` in `pipeline.py`. The date filter infrastructure is fully in place — one line change (`get_abc_classification(args.db_path, args.start_date, args.end_date)`) would complete it. One point deducted for the broken end-to-end wiring.

---

## Code Quality (5/6)

**Fixed:** `broad except Exception` in validation.py replaced with specific `(FileNotFoundError, OSError, duckdb.Error)` for connection and `duckdb.Error` for query execution. The `__init__.py` print stub removed (replaced with a plain comment). Type hints added on most public functions: `_load_sql(str) -> str`, `get_seller_scorecard(str, str) -> pl.DataFrame`, `validate_database(str) -> bool`, and `get_abc_classification` has all three parameter annotations.

**Remaining issues:** `import altair as alt` is still inside the function body at pipeline.py line 76 rather than at module top. `_run_query()` is missing its `params` type annotation and return type (`-> pl.DataFrame`). `get_abc_classification()` is missing its return type annotation (`-> pl.DataFrame`). These are minor but collectively represent incomplete type annotation coverage. One point deducted.

---

## Project Structure (2/3)

`src/` layout, `pyproject.toml` with `[project.scripts]`, external SQL files in `sql/`, README.md, DESIGN.md, `.gitignore`, `.python-version` all present. However, `pyproject.toml` is missing a `[build-system]` section entirely. `uv sync` warns: *"Skipping installation of entry points for package wvu-ieng-331-m2-18 because this project is not packaged; to install entry points, set `tool.uv.package = true` or define a `build-system`."* The entry point `wvu-ieng-331-m2-18` is not installed by `uv sync` alone, requiring a separate `uv pip install -e .` to make the CLI available. Also, README.md still documents `--db-path` as "required" in its parameters table despite the code now defaulting it. One point deducted.

---

## Design (3/3)

DESIGN.md was updated to accurately reflect the resubmission. The Parameter Flow section now correctly describes how `--start-date` and `--end-date` flow through the ABC classification SQL using `$1`/`$2` positional parameters. The Error Handling section accurately identifies the specific exception types used in validation.py. SQL Parameterization, Validation Logic, and Scaling sections all contain accurate descriptions with real code references. The document no longer misrepresents what the ABC SQL does. Full marks.

---

## Late Penalty Adjustment

This resubmission was received on or before 11:59 PM Wed Apr 22, 2026, in the **20% off improvement** tier per the resubmission policy. The penalty applies only to points earned beyond the original grade.

| | Points |
|---|---:|
| Original score | 17 / 24 |
| Regraded score | 20 / 24 |
| Improvement | +3 |
| Late penalty (20% × improvement) | -0.6 |
| **Final score** | **19.4 / 24** |
