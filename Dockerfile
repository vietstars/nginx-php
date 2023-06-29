FROM nginx

LABEL Maintainer="Ben Thai <vietstar.nt@gmail.com>"

COPY ./config/certs /etc/nginx/certs

RUN apt-get update
RUN apt-get install -y nginx gnupg gosu curl ca-certificates zip unzip git supervisor sqlite3
RUN apt-get install -y supervisor tzdata htop php8.2 php8.2-cli php8.2-fpm
RUN apt-get install -y php8.2-curl php8.2-bz2 php8.2-mbstring php8.2-intl php8.2-ctype
RUN apt-get install -y php8.2-dom php8.2-exif php8.2-fileinfo php8.2-fpm
RUN apt-get install -y php8.2-gd php8.2-iconv php8.2-mysqli php8.2-opcache php8.2-simplexml
RUN apt-get install -y php8.2-soap php8.2-xml php8.2-xmlreader php8.2-zip
RUN apt-get install -y php8.2-pdo php8.2-xmlwriter php8.2-tokenizer
RUN apt-get install -y nodejs npm

# Configure nginx
COPY config/web/nginx/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/web/nginx/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY config/web/php/php.ini /etc/php8/conf.d/custom.ini

# Configure supervisord
COPY config/web/nginx/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY ./src/ /usr/share/nginx/html/

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# service --status-all
RUN service php8.2-fpm start
RUN service nginx restart

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
