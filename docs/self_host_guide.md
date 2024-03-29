# Self-hosting

**Table of contents**
- [How does it work?](#how-does-it-work)
- [Setup on Unix based OS](#setup-on-unix-based-os)
  - [Prerequisites](#prerequisites)
  - [Basic installation](#basic-installation)
- [Configure features](#configure-features)
  - [Phone validation](#phone-validation)
    - [Disabling Phone validation](#disabling-phone-validation)
    - [Enabling and configuring Phone validation](#enabling-and-configuring-phone-validation)
  - [Admin account & no register mode](#admin-account--no-register-mode)
    - [Disabling Admin account](#disabling-admin-account)
    - [Enabling and configuring Admin account](#enabling-and-configuring-admin-account)
    - [Enabling no register mode](#enabling-no-register-mode)
- [Database management](#database-management)
  - [Change database password](#change-database-password)
- [Setup HTTPS](#setup-https)

## How does it work?
A Homesynck server instance is made of 2 parts (and 1 optional part):

- A [Phoenix web server](../homesynck/README.md)
- A [PostgreSQL](https://www.postgresql.org/) database for data persistance
- *Optional*: a reverse proxy (here we use [Nginx](https://nginx.org/en/), but any should work)

Those 3 parts can be downloaded and run all in harmony using Docker containers and docker-compose.

## Setup on Unix based OS
### Prerequisites
- a terminal with git command
  - Make sure git is working by doing `git --version`
- docker and docker-compose installed
  - Make sure Docker is working by doing `docker ps`
    - if you get error: `Got permission denied while trying to connect to the Docker daemon` you'll need to prepend any `docker` and `docker-compose` command we do here with `sudo `, assuming you have such permissions on your machine
  - Make sure docker-compose is working by doing `docker-compose -v`
    - my docker-compose version as of writing this is `1.25.0`
- sudo permissions on your machine
- for HTTPS to work: a domain name (e.g. `john@doe.com`) pointing to the IP of your machine

### Basic installation
By following those instructions you'll get an up and running Homesynck server instance on your machine.

We won't customize database settings and we won't setup HTTPS during this. But you will need to do it before deploying to production by following our [database management guide](#database-management) and our [https enabling guide](#setup-https).

Let's get going:

1. Open a terminal
2. Clone this repo: `git clone https://github.com/Homesynck/Homesynck-server.git`
3. Open it `cd homesynck-server`
4. Generate a 64 bytes long encryption key (or longer)
   - by going to [this website](https://www.allkeysgenerator.com/Random/Security-Encryption-Key-Generator.aspx), 1024 bits should be fine
   - or by using command `mix phx.gen.secret 64` if you got an existing Phoenix project
5. Execute `echo "SECRET_KEY_BASE=your generated key" >> docker.env`
6. Make sure `cat docker.env` does print `SECRET_KEY_BASE=your generated key`
7. Pull, build and run all the containers in the background by doing `docker-compose up --build -d`
8. Make sure you have the 3 containers running by doing `docker ps`
9. Make sure the Phoenix web server did start by doing `docker logs homesynck-server_phoenix-server_1`
10. Open a browser and go to `http://localhost:4001`

## Configure features
### Phone validation
Phone validation is a spam prevention feature that can be useful for big audience apps.

If activated, a register token will be sent to a phone number validation API. This API is then meant to send the token to the phone owner through automated SMS. Then, the user would use this token to register one account. Phone numbers used to generate a register token will be on a cooldown and won't be authorized to generate another register token for 30 days, thus preventing account creation spam.

#### Disabling Phone validation
1. Open `docker-compose.yml`
2. Under `phoenix-server -> environment` change `ENABLE_PHONE_VALIDATION` to `"false"`
   - Double quotes are mandatory
3. Restart the server with `docker-compose up --build -d`

#### Enabling and configuring Phone validation
Phone validation requires hosting your own automated SMS API.

Compliant phone validation APIs must:
 - Accept POST with Json body:
```json
  {
    "number": "user phone number in international format",
    "message": "generated register token to send through SMS",
    "secret": "API key if required"
  }
```
 - Respond with code 200 if success.

Check out our [example APIs](./phone_api.md)

In order to configure the server to use your API, do the following:

1. Open `docker-compose.yml`
2. Under `phoenix-server -> environment` change `ENABLE_PHONE_VALIDATION` to `"true"`
   - Double quotes are mandatory
3. Open or create your secret `docker.env` file:
   - after `PHONE_VALIDATION_API_ENDPOINT=` put your API url
   - after `PHONE_VALIDATION_API_KEY=` put your API key as in the `"secret"` field of the request's body
4. Restart the server with `docker-compose up --build -d`

### Admin account & no register mode
#### Disabling Admin account
1. Open `docker-compose.yml`
2. Under `phoenix-server -> environment` change `ENABLE_ADMIN_ACCOUNT` to `"false"`
   - Double quotes are mandatory
3. Restart the server with `docker-compose up --build -d`

#### Enabling and configuring Admin account
This feature creates an account for you on firststart using credentials in the server's configuration.

Enabling it and also enabling "no register mode" can be useful to only let you use your own server, thus making it suitable for private use.

This "admin account" can also be used for tests and maintenance.

In order to enable and configure it do the following:

1. Open `docker-compose.yml`
2. Under `phoenix-server -> environment` change `ENABLE_ADMIN_ACCOUNT` to `"true"`
   - Double quotes are mandatory
3. Open or create your secret `docker.env` file:
   - after `ADMIN_USERNAME=` put your admin account username
   - after `ADMIN_PASSWORD=` put your admin account password
4. Restart the server with `docker-compose up --build -d`

If you change the `ADMIN_USERNAME` or `ADMIN_PASSWORD` later, it will take effect on server restart.

#### Enabling no register mode
"No register mode" prevents anyone from creating an account using public WebSocket endpoints.

You can enable the "admin account" feature along with this one in order to create a unique admin account for private use.

In order to enable and configure "no register mode" do the following:

1. Open `docker-compose.yml`
2. Under `phoenix-server -> environment` change `ENABLE_REGISTER` to `"false"`
   - Double quotes are mandatory
3. Restart the server with `docker-compose up --build -d`

## Database management
### Change database password
1. Open `docker-compose.yml`
2. Replace all `postgres_password` with your new password
3. Restart the server with `docker-compose up --build -d`

## Setup HTTPS
HTTPS is mandatory since the server does not encrypt messages by default, making your synchronized data vulnerable to nowadays beginner-friendly man-in-the-middle attacks.

1. make sure you have a domain name (costs a little money) and that it points to your machine's IP address.
2. Open `docker-compose.yml`
3. Replace all `yourdomain.com` with your domain name
4. Replace all `your@email.com` with your email (doesn't have to be a working one, but it's better)
5. Restart the server with `docker-compose up --build -d`
6. Make sure it worked `https://yourdomain.com`