FROM gitpod/workspace-full
USER gitpod

# Install Ruby version 2.7.2 and set it as default
RUN echo "rvm_gems_path=/home/gitpod/.rvm" > ~/.rvmrc
RUN bash -lc "rvm install ruby-2.7.2 && rvm use ruby-ruby-2.7.2 --default"
RUN echo "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc

# Install Cypress-base dependencies
RUN sudo apt-get install -y \
    libgtk2.0-0 \
    libgtk-3-0
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    libgbm-dev \
    libnotify-dev
RUN sudo apt-get install -y \
    libgconf-2-4 \
    libnss3 \
    libxss1
RUN sudo apt-get install -y \
    libasound2 \
    libxtst6 \
    xauth \
    xvfb

RUN sudo rm -rf /var/lib/apt/lists/*

ENV CYPRESS_CACHE_FOLDER=/workspace/.cypress-cache