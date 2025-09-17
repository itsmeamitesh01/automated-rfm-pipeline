# Import the official Google Cloud library
# from google.cloud import bigquery

# def test_bigquery_connection():
#     """
#     Tests the connection to Google BigQuery by running a simple query.
#     """
#     try:
        # 1. Instantiates a client. This is the magic step that automatically
        #    finds and uses the credentials from your environment variable.
#         client = bigquery.Client()

        # client = bigquery.Client.from_service_account_json("credentials.json")

        # 2. Define a simple test query.
#         test_query = "SELECT 1 AS test_value"

        # 3. Make an API request to run the query.
#         print("Sending a test query to BigQuery...")
#         query_job = client.query(test_query)

        # 4. Wait for the job to complete and get the results.
#         results = query_job.result()
        
        # 5. Print a success message.
        # print("✅ Success! Connection to BigQuery is working.")

        # Optional: Print the result of the query
#         for row in results:
#             print(f"Query Result: {row.test_value}")

#     except Exception as e:
        # If anything goes wrong, print the error.
#         print(f"❌ Failed to connect to BigQuery. Error: {e}")

# This line makes the function run when you execute the script.
# if __name__ == "__main__":
#     test_bigquery_connection()


import os
# Import the official Google Cloud library
from google.cloud import bigquery

# --- Configuration ---
# Define the path to your SQL queries folder
SQL_FOLDER_PATH = "sql_queries"
# Define your Google Cloud Project ID
PROJECT_ID = "crsm-471015"
# Define the destination for your results table
DESTINATION_TABLE = f"{PROJECT_ID}.ecommerce.rfm_results"


def load_query(file_name: str) -> str:
    """
    Loads a SQL query from a file in the specified SQL folder.
    """
    path = os.path.join(SQL_FOLDER_PATH, file_name)
    print(f"Loading query from: {path}...")
    with open(path, 'r') as f:
        return f.read()

def run_bigquery_job():
    """
    Loads a SQL query from a file and runs it as a job in BigQuery.
    """
    try:
        client = bigquery.Client(project=PROJECT_ID)
        print("BigQuery client created successfully.")

        # Load the main RFM calculation query from the file
        rfm_query = load_query("01_calculate_rfm.sql")

        # Configure the query job
        job_config = bigquery.QueryJobConfig(
            destination=DESTINATION_TABLE,
            write_disposition="WRITE_TRUNCATE", # This will overwrite the table each time
        )

        print("Submitting query job to BigQuery...")
        # Submit the query and wait for the results
        query_job = client.query(rfm_query, job_config=job_config)
        query_job.result()  # Waits for the job to complete

        print("✅ Success! Job completed.")
        print(f"Results have been saved to the table: {DESTINATION_TABLE}")

    except Exception as e:
        print(f"❌ An error occurred: {e}")


if __name__ == "__main__":
    run_bigquery_job()