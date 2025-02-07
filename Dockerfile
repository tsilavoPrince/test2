# Dockerfile

# Utilisation de l'image PHP officielle avec extensions nécessaires
FROM php:8.1-fpm

# Installe les dépendances système et PHP
RUN apt-get update && apt-get install -y \
    curl zip unzip git libpq-dev libzip-dev libpng-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Installe Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copie les fichiers de l’application
COPY . .

# Installe les dépendances PHP avec Composer
RUN composer install --optimize-autoloader --no-dev

# Donne les bonnes permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose le port 8000
EXPOSE 8000

# Commande pour démarrer l’application et exécuter les migrations
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000
