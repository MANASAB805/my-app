# ---- Stage 1: Build ----
FROM python:3.11-slim AS build

WORKDIR /app

# Upgrade pip, setuptools, and wheel to latest secure versions
RUN pip install --upgrade pip setuptools wheel

# Copy requirements and install dependencies to /app/deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt -t /app/deps

# Copy app source code
COPY . .

# ---- Stage 2: Final ----
# Use Distroless Python with non-root user for security
FROM gcr.io/distroless/python3:nonroot

WORKDIR /app

# Copy dependencies from build stage
COPY --from=build /app/deps /app/

# Copy app code
COPY --from=build /app /app

# Expose port
EXPOSE 8000

# Run the app
CMD ["app.py"]
