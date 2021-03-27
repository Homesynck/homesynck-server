# Self-hosting
## How does it work?
A Homesynck server instance is made of 2 parts (and 1 optional part):

- [A Phoenix web server](./homesynck/README.md)
- A PostgreSQL database for data persistance
- *Optional*: a reverse proxy (here we use Nginx)

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

### Basic instructions
By following those instructions you'll get an up and running Homesynck server instance on your machine.

We won't customize database settings and we won't setup HTTPS during this. But you can do it later by following our [database management guide] and our [https enabling guide]. For production you should 100% follow them.

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

## Database management
### Change database password
1. Open `docker-compose.yml`
2. Replace all `postgres_password` with your new password
3. Restart the server with `docker-compose up --build -d`

## Setup HTTPS
HTTPS is mandatory since the server does not encrypt messages by default, making your synchronised data vulnerable to nowadays beginner-friendly man-in-the-middle attacks.

1. make sure you have a domain name (costs a little money) and that it points to your machine's IP address.
2. Open `docker-compose.yml`
3. Replace all `yourdomain.com` with your domain name
4. Replace all `your@email.com` with your email (doesn't have to be a working one, but it's better)
5. Restart the server with `docker-compose up --build -d`
6. Make sure it worked `https://yourdomain.com`