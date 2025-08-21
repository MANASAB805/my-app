# ---- Stage 1: Build ----
FROM python:3.11-slim AS build

WORKDIR /app

# Upgrade pip, setuptools, and wheel
RUN pip install --upgrade pip setuptools wheel

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt -t .

# Copy app code
COPY . .

# ---- Stage 2: Final ----
FROM python:3.11-slim

WORKDIR /app
COPY --from=build /app /app

EXPOSE 5000
CMD ["python", "app.py"]
