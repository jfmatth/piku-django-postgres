# Piku Django4 Postgres

Provides an example Django 4.x app using Postgres locally on the PIKU server.

## Requirements
1. Piku
2. Postgres installed on PIKU vm
    ``` ./piku-bootstrap install postgres.yml```

## Installation
Clone this repo and push it to your Piku server
```
git clone ...
git remote add piku ..<your server here>    
git push piku
```
Set the hostname for NGINX
```
piku config:set NGINX_SERVER_NAME=<your fqdn>
```
Provision the Postgres Database - The Database is given the same name as your NGINX_SERVER_NAME via createdb and runs Django's migrate command
```
piku run -- ./bin/provision-database.sh
```

Create your superuser
```
piku shell
./manage.py createsuperuser
```


## PIKU features utilized
This app utilizes several of Piku's ```Procfile``` features
```
wsgi: pikupostgres.wsgi:application
release: ./bin/stage_release.sh
cron: 0 0 * * * ./bin/uwsgi_cron_midnight.sh
```

### release
Each time you push your code, Piku will run a 'release' cycle and run this code.  ```./bin/stage_release.sh``` only runs Django's collectstatic function, but you can add more

### cron
Piku uses UWSGI to schedule Cron jobs.  ```./bin/uwsgi_cron_midnight.sh``` runs a Django clearsessions command every day at 0:00 (midnight)

### UWSGI Static file mapping
The ```ENV``` file defines a feature that has NGINX serve this application static files directly from the folder
```
NGINX_STATIC_PATHS=/static:static
```
## Django changes
There are a few minor changes to Django to utilize Piku.  These are added to the end of ```settings.py```
1. ```DEBUG``` - Debug is set to False unless the environment variable ```DEBUG``` is defined (```piku config:set DEBUG=true```)
2. ```ALLOWED_HOSTS```  uses the NGINX_SERVER_NAME or DEBUG for security purposes
3. ```DATABASES``` is updated if NGINX_SERVER_NAME is defined
4. ```STATIC_ROOT``` is defined to reference the /static folder (tied to the above UWSGI setting)
