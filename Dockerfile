# Step 1: Start with an official, lightweight Python base image.
FROM python:3.9-slim

# Step 2: Set the working directory inside the container to /app.
# This is where our code will live and run.
WORKDIR /app

# Step 3: Copy the requirements file first and install dependencies.
# This is a best practice that takes advantage of Docker's caching.
COPY requirements.txt .
RUN pip install -r requirements.txt

# Step 4: Copy the rest of our application files into the container.
# This includes pipeline.py, the sql_queries folder, and credentials.json.
COPY . .

# Step 5: Set the environment variable for authentication INSIDE the container.
# The path /app/credentials.json is the location of the key file inside the container.
ENV GOOGLE_APPLICATION_CREDENTIALS /app/credentials.json

# Step 6: Specify the default command to run when the container starts.
CMD ["python", "pipeline.py"]