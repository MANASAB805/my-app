# ---- Stage 1: Build ----
FROM python:3.11-slim AS build

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt -t .

# Copy the application code
COPY . .

# ---- Stage 2: Final ----
FROM gcr.io/distroless/python3

# Set working directory
WORKDIR /app

# Copy installed dependencies and app from build stage
COPY --from=build /app /app

# Expose the port the app runs on
EXPOSE 5000

# Command to run the Flask app
CMD ["app.py"]
