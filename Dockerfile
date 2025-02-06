# Utilise l’image officielle PHP avec les extensions nécessaires
FROM php:8.1-fpm

# Installer les extensions PHP nécessaires pour Laravel
RUN apt-get update && apt-get install -y \
    libpq-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_mysql bcmath

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers de l’application
COPY . .

# Installer les dépendances avec Composer
RUN composer install --no-dev --optimize-autoloader

# Donner les permissions nécessaires
RUN chmod -R 775 storage bootstrap/cache

# Lancer PHP-FPM
CMD ["php-fpm"]
