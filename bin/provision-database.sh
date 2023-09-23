#!/bin/sh

echo "Db/server name: [${NGINX_SERVER_NAME}]"

if [ "${NGINX_SERVER_NAME}" = "" ]
then
  echo "Skipping db creation as NGINX_SERVER_NAME is not set."
else
  psql "${NGINX_SERVER_NAME}" -c ";" 2>/dev/null && echo "Database ${NGINX_SERVER_NAME} already exists" || createdb "${NGINX_SERVER_NAME}"
fi

./manage.py migrate --no-input
