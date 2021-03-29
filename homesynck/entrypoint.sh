#!/bin/sh

# Note: !/bin/sh must be at the top of the line,
# Alpine doesn't have bash so we need to use sh.

# Docker entrypoint script.
# Don't forget to give this file execution rights via `chmod +x entrypoint.sh`
# which I've added to the Dockerfile but you could do this manually instead.
# Wait until Postgres is ready before running the next step.
while ! pg_isready -q -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER
do
  echo "$(date) - waiting for database to start."
  sleep 2
done

print_db_name()
{
  `PGPASSWORD=$DATABASE_PASS psql -h $DATABASE_HOST
  -U $DATABASE_USER -Atqc "\\list $DATABASE_NAME"`
}

# Create the database if it doesn't exist.
# -z flag returns true if string is null.
mix ecto.create
echo "Database $DATABASE_NAME created."

# Runs migrations, will skip if migrations are up to date.
echo "Database $DATABASE_NAME exists, running migrations..."
mix ecto.migrate
echo "Migrations finished."

echo "HOMESYNCK CONFIG: "
echo "- enable_admin_account: $ENABLE_ADMIN_ACCOUNT"
echo "- admin_username: $ADMIN_USERNAME"
echo "- admin_password: $ADMIN_PASSWORD"
echo "- enable_register: $ENABLE_REGISTER"
echo "- enable_phone_validation: $ENABLE_PHONE_VALIDATION"
echo "- phone_validation_api_endpoint: $PHONE_VALIDATION_API_ENDPOINT"
echo "- phone_validation_api_key: $PHONE_VALIDATION_API_KEY"

# Start the server.
elixir --sname homesynck --cookie cookie -S mix phx.server