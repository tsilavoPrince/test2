# Étape 1: Utilisation d'une image PHP avec Apache
FROM php:8.1-apache

# Étape 2: Installation des dépendances système nécessaires pour Laravel
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql

# Étape 3: Installation de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Étape 4: Définir le répertoire de travail dans le conteneur
WORKDIR /var/www/html

# Étape 5: Copier le code source Laravel dans le conteneur
COPY . .

# Étape 6: Définir les bonnes permissions sur les dossiers de stockage et de cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Étape 7: Exposer le port 80 pour accéder à l'application
EXPOSE 80

# Étape 8: Lancer Apache en mode "foreground" pour que le conteneur reste actif
CMD ["apache2-foreground"]
