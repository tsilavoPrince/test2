# Utilisation de l'image PHP officielle avec les extensions nécessaires
FROM php:8.1-fpm

# Installation des dépendances système et PHP
RUN apt-get update && apt-get install -y \
    curl zip unzip git libpq-dev libzip-dev libpng-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Installation de Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers de l’application
COPY . .

# Définir les bonnes permissions pour les répertoires nécessaires
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache && \
    chown -R www-data:www-data /var/www/html

# Installation des dépendances Laravel
RUN composer install --optimize-autoloader --no-dev

# Expose le port 8000
EXPOSE 8000

# Commande pour exécuter les migrations et démarrer l’application
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000
