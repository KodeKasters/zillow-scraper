# Use the official Node.js version 20.11.0 image as base
FROM node:lts-slim

# # Install necessary dependencies for Puppeteer and other tools
# RUN apt-get update \
#     && apt-get install -y \
#     gconf-service \
#     libasound2 \
#     libatk1.0-0 \
#     libcups2 \
#     libdbus-1-3 \
#     libgtk-3-0 \
#     libnspr4 \
#     libnss3 \
#     libx11-xcb1 \
#     libxcomposite1 \
#     libxcursor1 \
#     libxdamage1 \
#     libxrandr2 \
#     libxss1 \
#     libxtst6 \
#     fonts-ipafont-gothic \
#     fonts-wqy-zenhei \
#     fonts-thai-tlwg \
#     fonts-kacst \
#     fonts-freefont-ttf \
#     ca-certificates \
#     fonts-liberation \
#     libappindicator1 \
#     libnss3-dev \
#     lsb-release \
#     xdg-utils \
#     wget \
#     unzip \
#     google-chrome-stable \
#     && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg \
    && sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] https://dl-ssl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-khmeros fonts-kacst fonts-freefont-ttf libxss1 dbus dbus-x11 \
    --no-install-recommends \
    && service dbus start \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r pptruser && useradd -rm -g pptruser -G audio,video pptruser

# Set Puppeteer specific environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable 
#PUPPETEER_EXECUTABLE_ARGS=--no-sandbox,--disable-setuid-sandbox,--headless,--disable-gpu

# # Install Chromium browser separately since it's not bundled with Node.js 20.11.0
# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
#     && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
#     && apt-get update \
#     && apt-get install -y google-chrome-stable \
#     && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Command to run your Puppeteer application
CMD ["node", "index"]