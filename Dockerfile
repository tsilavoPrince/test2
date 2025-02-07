# Utiliser l'image officielle PHP avec Nginx
FROM php:8.1-fpm

# Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git unzip

# Installer Composer (gestionnaire de dépendances PHP)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installer les extensions PHP nécessaires
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_mysql

# Configurer le répertoire de travail
WORKDIR /var/www

# Copier le fichier composer.json et installer les dépendances de Laravel
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

# Copier le reste des fichiers du projet
COPY . .

# Configurer Nginx (optionnel, si tu veux utiliser Nginx pour servir l'application)
COPY nginx/default.conf /etc/nginx/conf.d/

# Exposer le port 80
EXPOSE 80

# Commande pour démarrer le serveur Nginx et PHP-FPM
CMD ["sh", "-c", "php artisan serve --host=0.0.0.0 --port=3000"]
