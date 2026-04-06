#!/bin/bash
set -e

echo "Starting Todo App infrastructure..."

# Load environment variables if .env exists
if [ -f .env ]; then
  export $(cat .env | grep -v '#' | xargs)
fi

# Start infrastructure first (kafka, databases)
docker-compose up -d kafka auth-db auth-redis todo-db todo-redis notification-db

echo "Waiting for Kafka to be ready..."
sleep 15

# Start kafka-connect
docker-compose up -d kafka-connect

echo "Waiting for Kafka Connect to be ready..."
sleep 10

# Register Debezium connectors
./debezium/register-connectors.sh

# Start all services
docker-compose up -d auth-service todo-service notification-service api-gateway

echo "All services started. API Gateway available at http://localhost:8080"
