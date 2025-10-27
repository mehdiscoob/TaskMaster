# ---------- Base Image ----------
FROM php:8.3-fpm

# ---------- Build Arguments ----------
ARG APP_ENV=production
ENV APP_ENV=${APP_ENV}

# ---------- Workdir ----------
WORKDIR /var/www/html

# ---------- System Dependencies ----------
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ---------- Composer ----------
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# ---------- Copy Composer Files ----------
COPY composer.json composer.lock ./

# ---------- Install PHP Dependencies ----------
RUN composer install --no-scripts --no-interaction --no-progress || true

# ---------- Copy Application Source ----------
COPY . /var/www/html

# ---------- Permissions ----------
RUN mkdir -p /var/www/html/storage/framework/views \
    /var/www/html/storage/framework/cache \
    /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# ---------- Run Artisan & Optimization ----------
RUN if [ "$APP_ENV" = "production" ]; then \
        composer install --no-dev --optimize-autoloader --no-interaction && \
        php artisan config:clear && \
        php artisan cache:clear && \
        php artisan route:cache && \
        php artisan view:cache; \
    else \
        composer install --no-interaction; \
    fi

# ---------- Expose Port ----------
EXPOSE 9000

# ---------- Entrypoint ----------
CMD ["php-fpm"]
