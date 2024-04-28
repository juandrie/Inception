FROM debian:bullseye

# Install the necessary dependencies, PHP-FPM and PHP extensions required by WordPress
RUN apt-get update && \
    apt-get install -y php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-mbstring php7.4-xml php7.4-xmlrpc curl && \
    apt-get install -y default-mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create the /run/php directory
RUN mkdir -p /run/php

# Configure PHP-FPM to listen on the network
RUN sed -i 's/^listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

# Download the latest version of WordPress and extract it
RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://wordpress.org/wordpress-5.7.8.zip && \ 
    unzip wordpress-5.7.8.zip -d /var/www/ && \
    mv /var/www/wordpress /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    rm wordpress-5.7.8.zip && \
    apt-get remove --purge -y wget unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy wp-config.php from the host to the container
COPY conf/wp-config.php /var/www/html/wp-config.php

# Setting the volume for WordPress content
VOLUME /var/www/html

# Copy the auto configuration script into the image
COPY conf/auto_config.sh /usr/local/bin/auto_config.sh
RUN chmod +x /usr/local/bin/auto_config.sh

# Expose the port on which PHP-FPM is listening
EXPOSE 9000

# Set the auto configuration script as the entrypoint
ENTRYPOINT ["auto_config.sh"]

# Start PHP-FPM
CMD ["php-fpm7.4", "-F"]
