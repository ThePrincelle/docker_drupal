# Docker environnement for Drupal

Drupal is not installed by default but the image defined in the Dockerfile is ready to use with Drupal.

To install Drupal (9), use Composer in the container:

```bash
# Setup the environnement variables 
cp .env.example .env
# Edit as you want the variables in .env

# Start the containers (app (php), mysql, phpmyadmin, mailhog)
docker-compose up -d

# Enter the app container
./enter.sh 
# or
docker-compose exec app bash

# Install the latest Drupal 9 with Composer (in the app container)
composer create-project drupal/recommended-project:^9 drupal

# This command will create a drupal directory in the app directory (./app/drupal) on the host machine.
# In the container, this directory is /var/www/html/drupal
```

Then, go to http://localhost:8080/ to install Drupal.

## Environnement variables

| Variable | Default value | Description |
| -------- | ------------- | ----------- |
| `MYSQL_ROOT_PASSWORD` | `root` | Password for the root user of MySQL |
| `MYSQL_DATABASE` | `drupal` | Name of the database |
| `MYSQL_USER` | `drupal_database_user` | Username for the database |
| `MYSQL_PASSWORD` | `drupal_database_password` | Password for the database |

Use the last three variables in the Drupal installation.
Keep the `MYSQL_ROOT_PASSWORD` for logging in phpmyadmin with the `root` user.

## Drupal configuration

The configuration is pretty simple, the one thing to check is the database configuration.

Using the Drupal first installation page, you can use the following configuration:
- Database name: `drupal`
- Database username: `drupal_database_user`
- Database password: `drupal_database_password`
- Database host: `mysql`

The database name, username and password are defined in the `.env` file.

## Volumes and bindings

The database has a `db_data` docker volume. It means that the data will be kept even if the container is removed.

The `app` container has a binding with the `./app` directory that corresponds to the `/var/www/html` directory in the container.
This configuration should be used for development only. In production, the code should be in the final Docker image.

## Ports

The ports are defined in the `docker-compose.yml` file.

By default, the ports are: 
- `8080` for the app (php)
- `3306` for MySQL
- `8081` for phpmyadmin
- `8025` for mailhog

## How to delete everything

```bash
# Stop and remove the containers, and remove the volumes
docker-compose down -v
```