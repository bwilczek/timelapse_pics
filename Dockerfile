FROM ruby:3.4.4

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        curl \
        gnupg2 \
        ca-certificates \
        unzip \
        libxi6 \
        libgconf-2-4 \
        libnss3 \
        libgtk-3-0 \
        libxss1 \
        libasound2 \
        libdbus-glib-1-2 \
        firefox-esr && \
    rm -rf /var/lib/apt/lists/*

# Install geckodriver (needed for Firefox control)
RUN GECKODRIVER_VERSION=$(curl -s https://api.github.com/repos/mozilla/geckodriver/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    wget -q "https://github.com/mozilla/geckodriver/releases/download/v${GECKODRIVER_VERSION}/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz" && \
    tar -xzf "geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz" -C /usr/local/bin && \
    rm "geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz"

WORKDIR /app
COPY . .
RUN bundle install

ENTRYPOINT bundle exec ruby run.rb 
