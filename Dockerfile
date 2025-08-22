# ---- Stage 1: Build ----
FROM python:3.11-slim AS build

WORKDIR /app

# Upgrade pip, setuptools, and wheel
RUN pip install --upgrade pip setuptools wheel

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt -t /app/deps

# Copy app source code
COPY . .

# ---- Stage 2: Final ----
# ---- Stage 2: Final ----
FROM gcr.io/distroless/python3:nonroot

WORKDIR /app

# Copy dependencies and app code
COPY --from=build /app /app

# Set Python path so Flask is found
ENV PYTHONPATH="/app/deps"

EXPOSE 8000

# Correct way: run with python3
CMD ["python3", "app.py"]
