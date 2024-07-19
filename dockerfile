# Use Amazon Linux 2 as the base image
FROM amazonlinux:2

# Install dependencies and PHP extensions
RUN yum update -y && \
    yum install -y \
    httpd \
    tar \
    hostname \
    php \
    php-opcache \
    php-json \
    php-pear \
    php-intl \
    php-common \
    php-xml \
    php-mbstring \
    php-cli \
    php-mysqlnd \
    php-ldap \
    php-gd \
    php-zip \
    php-pdo \
    php-devel \
    php-soap \
    php-process \
    php-bcmath \
    php-sodium \
    php-exif \
    php-pecl-ssh2 \
    cronie \
    ghostscript \
    aspell \
    unzip \
    logrotate \
    vim \
    procps-ng \
    postfix \
    cyrus-sasl-plain \
    mailx && \
    yum clean all && \
    rm -rf /var/cache/yum

# Set the document root
WORKDIR /var/www/html

# Copy your Moodle files to the container
COPY . /var/www/html

# Set the correct permissions
RUN chown -R apache:apache /var/www/html && \
    chmod -R 755 /var/www/html

# Expose the HTTP port
EXPOSE 80

# Start Apache server
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
