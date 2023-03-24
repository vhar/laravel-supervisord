This is the Dockefile for the Docker image laravel-supervisord hosted on https://hub.docker.com/r/vhar/laravel-supervisord  
It has been structured in such way as to be used with `docker-compose`.  
The `supervisord.conf` configuration file uses the following container environment variables to start and manage Laravel queue workers:

`APP_ROOT:`this is the root directory of your Laravel application inside the container (mount your local Laravel app directory to the container). Specifically, artisan must be located in this directory.  
`QUEUE_DRIVER:` this is the driver of your Laravel queues.  
`OPTIONS:` these are arguments sent to php artisan queue:worker QUEUE_DRIVER, e.g. php artisan queue:worker database --sleep=3 --tries=3.  
`NUM_PROCS:` this is the number of workers that supervisord must create to handle jobs.  

Set them like this:
```
# .env
APP_ROOT=app_root_directory_inside_container
QUEUE_CONNECTION=database   # this is set to `sync` in the .env file Laravel provides
QUEUE_OPTIONS="--queue=some_queue --sleep=3 --tries=3"
NUM_PROCS=4
```
```
# docker-compose.yml
version: '3.2'
services:
    supervisor:
      container_name: supervisor
      image: redditsaved/laravel-supervisord:latest
      restart: unless-stopped
      environment:
        - APP_ROOT=${APP_ROOT}
        - QUEUE_DRIVER=${QUEUE_CONNECTION}
        - OPTIONS=${QUEUE_OPTIONS}
        - NUM_PROCS=${NUM_PROCS}
      volumes:
        - laravel_directory:${APP_ROOT}
      network_mode: host
```

