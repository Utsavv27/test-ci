FROM php:7.1

RUN apt-get update -y
RUN apt-get install -y unzip
RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get update; \
     apt-get install -y libmagickwand-dev; \
     pecl install imagick; \
     docker-php-ext-enable imagick;

COPY . ./app/

COPY .env.example .env

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
      gd xdebug

WORKDIR /app

RUN composer install

#RUN docker-php-ext-install exif

RUN php artisan key:generate

RUN php artisan config:clear

RUN php artisan cache:clear

RUN composer dump-autoload

RUN php artisan clear-compiled  

RUN php artisan session:table

# CMD ["sh",  "-c", " php artisan migrate && php artisan serve  "]









