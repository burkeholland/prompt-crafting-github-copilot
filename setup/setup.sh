#!/bin/bash

DB_NAME="demos"
DB_USER="postgres"

# Install postgres and log it
echo "Installing PostgreSQL..."
apt-get update > /dev/null 2>&1
apt-get install -y postgresql postgresql-contrib > /dev/null 2>&1

# Start the PostgreSQL service
echo "Starting the PostgreSQL service..."
service postgresql start

# Set password for the default postgres user
echo "Setting password for the postgres user..."
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"

# Create the "demos" database accessible by the "postgres" user if it doesn't exist
if ! psql -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    echo "Creating the 'demos' database..."
    sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"
else
    echo "Database $DB_NAME already exists. Skipping..."
fi

# Drop the "vehicles" table if it exists
echo "Creating the 'vehicles' table..."
sudo -u postgres psql -d demos -c "DROP TABLE vehicles;"

# Execute the createTable.sql script to create the "vehicles" table
sudo -u postgres psql -d demos -f setup/createTable.sql

# Import setup/ElectricVehicles.csv into the "vehicles" table
echo "Importing data/ElectricVehicles.csv into the 'vehicles' table..."
sudo -u postgres psql -d demos -c "\COPY vehicles FROM 'setup/ElectricVehicles.csv' WITH (FORMAT csv, HEADER true);"

# Create a .env file with the DATABASE_URL
echo "Creating .env file with DATABASE_URL..."
echo "DATABASE_URL=postgres://postgres:postgres@localhost/demos" > .env

echo "Setup complete!"