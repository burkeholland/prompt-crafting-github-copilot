#!/bin/bash

# Extract database information from DATABASE_URL
DATABASE_URL="postgres://localhost/demos?user=postgres&password=postgres"
# Correctly extract DB_NAME
DB_NAME=$(echo $DATABASE_URL | grep -oP '(?<=/)\w+(?=\?)')
DB_USER=$(echo $DATABASE_URL | grep -oP '(?<=user=)\w+')
DB_PASSWORD=$(echo $DATABASE_URL | grep -oP '(?<=password=)\w+')

# Check if PostgreSQL is running, if not, try to start it
if ! pg_isready > /dev/null 2>&1; then
    echo "PostgreSQL is not running. Attempting to start..."
    pg_ctl start -D /var/lib/postgresql/data
    if [ $? -ne 0 ]; then
        echo "Failed to start PostgreSQL. Exiting..."
        exit 1
    fi
fi

# Check if the database already exists
if psql -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    echo "Database $DB_NAME already exists."
else
    # Create the database
    PGPASSWORD=$DB_PASSWORD psql -U $DB_USER -d postgres -c "CREATE DATABASE $DB_NAME;"
    if [ $? -eq 0 ]; then
        echo "Successfully created database $DB_NAME."
    else
        echo "Failed to create database $DB_NAME."
        exit 1
    fi

    # Grant privileges
    PGPASSWORD=$DB_PASSWORD psql -U $DB_USER -d $DB_NAME -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"
    if [ $? -eq 0 ]; then
        echo "Successfully granted privileges to $DB_USER on $DB_NAME."
    else
        echo "Failed to grant privileges."
        exit 1
    fi
fi

# Drop the table if it exists
PGPASSWORD=$DB_PASSWORD psql -U $DB_USER -d $DB_NAME -c "DROP TABLE IF EXISTS vehicles;"
if [ $? -eq 0 ]; then
    echo "Successfully dropped table vehicles."
else
    echo "Failed to drop table vehicles."
    exit 1
fi

# Execute the createTable.sql script
PGPASSWORD=$DB_PASSWORD psql -U $DB_USER -d $DB_NAME -f setup/createTable.sql
if [ $? -eq 0 ]; then
    echo "Successfully executed createTable.sql."
else
    echo "Failed to execute createTable.sql."
    exit 1
fi

# Corrected psql command for importing data
PGPASSWORD=$DB_PASSWORD psql -U $DB_USER -d $DB_NAME -c "\COPY vehicles FROM 'setup/ElectricVehicles.csv' WITH (FORMAT csv, HEADER true);"

if [ $? -eq 0 ]; then
    echo "Successfully imported data/ElectricVehicles.csv into the vehicles table."
else
    echo "Failed to import data/ElectricVehicles.csv."
    exit 1
fi

# Connection string for the user
CONNECTION_STRING="postgresql://$DB_USER:$DB_PASSWORD@localhost/$DB_NAME"
echo "Connection string: $CONNECTION_STRING"

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "DATABASE_URL=\"postgres://localhost/$DB_NAME?user=$DB_USER&password=$DB_PASSWORD\"" >> .env
    echo ".env file created."
else
    echo ".env file already exists. Skipping..."
fi

echo "Setup finished. You are ready to go!"

