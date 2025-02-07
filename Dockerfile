# Utiliser une image PHP de base
FROM php:8.1-fpm

# Installer les extensions PHP nécessaires pour Laravel
RUN docker-php-ext-install pdo pdo_mysql

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copier les fichiers de l'application dans le conteneur
COPY . /var/www

# Définir le répertoire de travail
WORKDIR /var/www

# Installer les dépendances de Composer
RUN composer install --no-dev --optimize-autoloader --prefer-dist

# Exposer le port
EXPOSE 9000

# Commande pour démarrer PHP-FPM
CMD ["php-fpm"]
