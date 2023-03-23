FROM ubuntu:22.04


ENV TZ="America/New_York"
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install tzdata

ENV repo_dir="/ot-efr32"

# Install packages
RUN apt-get update && \
      apt-get -y install sudo tzdata git && \
      rm -rf /var/lib/apt/lists/*

# Copy scripts from host working directory
COPY ./script /tmp/ot-efr32/script
COPY ./openthread/script /tmp/ot-efr32/openthread/script

# Bootstrap
# RUN /tmp/ot-efr32/openthread/script/bootstrap
ENV SLC_INSTALL_DIR="/opt"
RUN /tmp/ot-efr32/script/bootstrap --fast

# Link slc-cli to /usr/bin as both 'slc' and 'slc-cli'
RUN ln -s ${SLC_INSTALL_DIR}/slc_cli/bin/slc-cli/slc-cli /usr/bin
RUN ln -s ${SLC_INSTALL_DIR}/slc_cli/bin/slc-cli/slc-cli /usr/bin/slc

# Clone repo for convenience
RUN git clone https://github.com/openthread/ot-efr32.git ${repo_dir}
