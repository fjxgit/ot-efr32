FROM ubuntu:20.04

ENV TZ="America/New_York"
ENV repo_dir="/ot-efr32"

# Install packages
RUN apt-get update && \
      apt-get -y install sudo


# Copy scripts
RUN mkdir ${repo_dir}
COPY ./script /ot-efr32/script
COPY ./openthread/script /ot-efr32/openthread/script

# bootstrap
RUN ./ot-efr32/script/bootstrap
