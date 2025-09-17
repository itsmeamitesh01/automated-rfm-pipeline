# Automated RFM Customer Segmentation Pipeline

## Overview

This project implements a fully automated, containerized, and scheduled data engineering pipeline to perform RFM (Recency, Frequency, Monetary) analysis on e-commerce transaction data. The system automatically ingests raw data from Google BigQuery, processes it through a complex SQL transformation, and saves the final customer segments back to a BigQuery table on a daily schedule.

This project demonstrates the transformation of a manual data analysis task into a robust, production-ready, and hands-off engineering solution.

## Project Evolution

This project is the automated, production-ready version of an initial exploratory analysis. The original work, which involved manual, standalone SQL queries to derive business insights, can be found in the [RFM Customer Segmentation & Retention Analysis](https://github.com/itsmeamitesh01/RFM-Customer-Segmentation-Analysis).

This pipeline takes the core logic from that analysis and re-engineers it into a robust, scheduled, and containerized system suitable for a production environment.

## Technologies Used

- **Cloud:** Google Cloud Platform (GCP)
- **Data Warehouse:** Google BigQuery
- **Orchestration:** Python
- **Containerization:** Docker
- **Scheduling:** Windows Task Scheduler / cron
- **Language:** SQL

## Architecture

The pipeline follows a simple, automated workflow:

1.  **Scheduled Trigger:** A system scheduler (like cron or Windows Task Scheduler) kicks off the process daily.
2.  **Docker Execution:** The scheduler runs a `docker run` command to start the containerized application.
3.  **Python Orchestration:** The `pipeline.py` script takes over, managing the connection to BigQuery and the execution of the SQL logic.
4.  **SQL Transformation:** A single, efficient SQL query with CTEs performs all the data cleaning, RFM calculation, scoring, and segmentation in one pass.
5.  **Load to BigQuery:** The final results are saved to a destination table in BigQuery, ready for use by business intelligence tools or marketing teams.

## How to Run

### Prerequisites

- Docker Desktop installed and running.
- A Google Cloud Platform account with a project set up.
- A `credentials.json` file from a GCP Service Account with BigQuery permissions.

### Setup

1.  Clone this repository.
2.  Place your `credentials.json` file in the root of the project directory. (Note: This file is included in `.gitignore` and will not be committed).
3.  Update the `PROJECT_ID` and `DESTINATION_TABLE` variables in `pipeline.py` with your GCP project details.

### Execution

1.  **Build the Docker Image:**
    ```bash
    docker build -t rfm-pipeline .
    ```

2.  **Run the Container:**
    ```bash
    docker run --rm rfm-pipeline
    ```
    The pipeline will execute and the final results will be available in your specified BigQuery destination table.
