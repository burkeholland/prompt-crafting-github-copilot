#!/bin/bash

# Install postgres and log it
echo "Installing PostgreSQL..."
apt-get update
apt-get install -y postgresql postgresql-contrib
echo "PostgreSQL installed."

# Update the pg_hba.conf file to trust all connections
echo "Trusting all connections (this is only OK because this is a local development environment)..."
echo "host all all" >> /etc/postgresql/15/main/pg_hba.conf
echo "local all all trust" >> /etc/postgresql/15/main/pg_hba.conf

# Start the PostgreSQL service
service postgresql start
echo "PostgreSQL service started."

DB_NAME="demos"
DB_USER="postgres"
DB_PASSWORD="postgres"

# # Check if PostgreSQL is running, if not, try to start it
# if ! pg_isready > /dev/null 2>&1; then
#     echo "PostgreSQL is not running. Attempting to start..."
#     pg_ctl start -D /var/lib/postgresql/data
#     if [ $? -ne 0 ]; then
#         echo "Failed to start PostgreSQL. Exiting..."
#         exit 1
#     fi
# fi

# Create the demos database
# Create the demos database if it doesn't exist
if ! psql -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    createdb $DB_NAME
    if [ $? -eq 0 ]; then
        echo "Successfully created database $DB_NAME."
    else
        echo "Failed to create database $DB_NAME."
        exit 1
    fi
else
    echo "Database $DB_NAME already exists. Skipping..."
fi

# Drop the table if it exists
psql -d $DB_NAME -c "DROP TABLE IF EXISTS vehicles;"
if [ $? -eq 0 ]; then
    echo "Successfully dropped table vehicles."
else
    echo "Failed to drop table vehicles."
    exit 1
fi

# Execute the createTable.sql script
psql -d $DB_NAME -f setup/createTable.sql
if [ $? -eq 0 ]; then
    echo "Successfully executed createTable.sql."
else
    echo "Failed to execute createTable.sql."
    exit 1
fi

# Import the csv file into the table
psql -d $DB_NAME -c "\COPY vehicles FROM 'setup/ElectricVehicles.csv' WITH (FORMAT csv, HEADER true);"

if [ $? -eq 0 ]; then
    echo "Successfully imported data/ElectricVehicles.csv into the vehicles table."
else
    echo "Failed to import data/ElectricVehicles.csv."
    exit 1
fi

# Connection string for the user
CONNECTION_STRING="postgresql://localhost/$DB_NAME"
echo "Connection string: $CONNECTION_STRING"

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "DATABASE_URL="$CONNECTION_STRING"" >> .env
    echo ".env file created."
else
    echo ".env file already exists. Skipping..."
fi

echo "Setup finished. You are ready to go!"

