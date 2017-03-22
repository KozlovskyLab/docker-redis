=================
Dockerizing Redis
=================

.. image:: https://git.kozlovskilab.com/kozlovskilab/redis/badges/master/build.svg
   :target: https://git.kozlovskilab.com/kozlovskilab/redis/commits/master
   :alt: build status
|
:Author: Vladimir Kozlovski
:Contact: vladimir@kozlovskilab.com
:Issues: https://github.com/kozlovskilab/docker-redis/issues
:Docker image: https://hub.docker.com/r/kozlovskilab/redis/
:Description: Dockerfile to build a Redis container image which can be 
              linked to other containers.

:Release notes: https://raw.githubusercontent.com/antirez/redis/3.2/00-RELEASENOTES
:Official image: https://hub.docker.com/_/redis/


.. meta::
   :keywords: Redis, Docker, Dockerizing
   :description lang=en: Dockerfile to build a Redis container image which 
                         can be linked to other containers.

.. contents:: Table of Contents


Introduction
============

Dockerfile to build a Redis container image which can be linked to other 
containers.


Installation
============

Pull the latest version of the image from the docker index. This is the 
recommended method of installation as it is easier to update image in the 
future.
::
    docker pull kozlovskilab/redis:latest

Alternately you can build the image yourself.
::
    git clone https://github.com/kozlovskilab/docker-redis.git
    cd docker-redis
    docker build -t="$USER/redis" .


Quick Start
===========
Run the Redis image
::
    docker run -p 127.0.0.1:6379:6379 --name redis -d kozlovskilab/redis:latest

to support persistent storage of data:
::
    -v <data-dir>:/var/lib/redis

for time synchronization with local:
::
    -v /etc/localtime:/etc/localtime:ro

Run the Redis image with all features:
::
    docker run -p 127.0.0.1:6379:6379 -v <data-dir>:/var/lib/redis -v /etc/localtime:/etc/localtime:ro --name redis -d kozlovskilab/redis:latest


Upgrading
=========
To upgrade to newer releases, simply follow this 3 step upgrade procedure.

* **Step 1:** Stop the currently running image::

    docker stop redis


* **Step 2:** Update the docker image::

    docker pull kozlovskilab/redis:latest


* **Step 3:** Start the image::

    docker run -p 127.0.0.1:6379:6379 --name redis -d kozlovskilab/redis:latest
