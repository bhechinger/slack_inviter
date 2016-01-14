############################################################
# Dockerfile to build Python WSGI Application Containers
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
#FROM ubuntu

# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
#FROM phusion/passenger-full:0.9.18
FROM phusion/passenger-python

# Set correct environment variables.
ENV HOME /home/app/webapp

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# File Author / Maintainer
MAINTAINER Brian Hechinger

# Update the OS
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

#Enable nginx/passenger
RUN rm -f /etc/service/nginx/down

#Setup nginx/passenger
RUN rm /etc/nginx/sites-enabled/default
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf

# Install basic applications
#RUN apt-get install -y tar git curl nano wget dialog net-tools build-essential

# Install Python and Basic Python Tools
#RUN apt-get install -y python python-dev python-distribute python-pip python3 python3-dev python3-pip
RUN apt-get install -y python-pip

# Copy the application folder inside the container
ADD /app /home/app/webapp

# Get pip to download and install requirements:
RUN pip install -r /home/app/webapp/requirements.txt

# Expose ports
EXPOSE 80

# Set the default directory where CMD will execute
WORKDIR /home/app/webapp

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
