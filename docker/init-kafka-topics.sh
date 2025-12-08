#!/bin/bash

# Wait for Kafka to be ready
echo "Waiting for Kafka to be ready..."
cub kafka-ready -b kafka-fcg:29092 1 30

# Create topics
echo "Creating Kafka topics..."

kafka-topics --create --if-not-exists \
  --bootstrap-server kafka-fcg:29092 \
  --topic user-created \
  --partitions 3 \
  --replication-factor 1

kafka-topics --create --if-not-exists \
  --bootstrap-server kafka-fcg:29092 \
  --topic order-placed \
  --partitions 3 \
  --replication-factor 1

kafka-topics --create --if-not-exists \
  --bootstrap-server kafka-fcg:29092 \
  --topic payment-processed \
  --partitions 3 \
  --replication-factor 1

echo "Kafka topics created successfully:"
kafka-topics --list --bootstrap-server kafka-fcg:29092
