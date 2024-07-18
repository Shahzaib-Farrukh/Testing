# Use the Amazon Linux 2 image as a base
FROM amazonlinux:2

# Enable PHP 8.2 and install the necessary packages
RUN amazon-linux-extras enable php8.2 \
    && yum -y --setopt=tsflags=nodocs update \
    && yum -y install \
    libnghttp2 \
    httpd \
    mod_ssl \
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
    procps \
    postfix \
    cyrus-sasl-plain \
    mailx \
    && yum clean all

# Enable Apache mod_rewrite
RUN echo "LoadModule rewrite_module modules/mod_rewrite.so" >> /etc/httpd/conf/httpd.conf

# Set the document root directory
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Set the correct permissions
RUN chown -R apache:apache /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
