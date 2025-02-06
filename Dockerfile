# Utiliser l'image PHP avec Apache
FROM php:8.1-apache

# Installer les dépendances nécessaires pour Laravel
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier tous les fichiers du projet dans le conteneur Docker
COPY . .

# Créer les répertoires nécessaires si ils n'existent pas
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache

# Donner les bonnes permissions à Apache (www-data)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exposer le port 80
EXPOSE 80

# Lancer Apache en arrière-plan
CMD ["apache2-foreground"]
