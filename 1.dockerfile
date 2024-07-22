# Use Amazon Linux 2 as the base image
FROM amazonlinux:2

# Install dependencies and PHP extensions
RUN amazon-linux-extras enable php8.2 && \
    yum update -y && \
    yum install -y \
    httpd tar hostname php \
    php-opcache php-json php-pear php-intl php-common php-xml \
    php-mbstring php-cli php-mysqlnd php-ldap php-gd \
    php-zip php-pdo php-devel php-soap php-process \
    php-bcmath php-sodium php-exif php-pecl-ssh2 \
    cronie ghostscript aspell unzip \
    logrotate vim procps-ng postfix cyrus-sasl-plain \
    mailx mysql && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    rm -f /etc/httpd/conf.d/welcome.conf

# Set PHP max_input_vars and session settings
RUN echo "max_input_vars = 5000" >> /etc/php.d/moodle.ini && \
    echo "session.save_path = '/var/lib/php/session'" >> /etc/php.d/moodle.ini && \
    echo "session.gc_probability = 1" >> /etc/php.d/moodle.ini && \
    mkdir -p /var/lib/php/session && \
    chown -R apache:apache /var/lib/php/session && \
    chmod -R 700 /var/lib/php/session

# Set the document root
WORKDIR /var/www/html

# Copy your Moodle files to the container and set ownership
COPY --chown=apache:apache ./moodle /var/www/html

# Set the correct permissions
RUN chmod -R 755 /var/www/html

RUN mkdir -p /var/www/moodledata && \
    chown -R apache:apache /var/www/moodledata && \
    chmod -R 755 /var/www/moodledata

# Expose the HTTP port
EXPOSE 80

# Start Apache server
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
