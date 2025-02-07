# Utilisation de l'image PHP officielle avec les extensions nécessaires
FROM php:8.1-fpm

# Installation des dépendances système et des extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    unzip \
    git \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql zip gd mbstring bcmath

# Installation de Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers de l’application dans le conteneur
COPY . .

# Définir les bonnes permissions pour les répertoires nécessaires
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache && \
    chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Installation des dépendances Laravel
RUN composer install --optimize-autoloader --no-dev

# Expose le port 8000 (Railway utilisera la variable d'environnement PORT)
EXPOSE 8000

# Créer un script de démarrage (start.sh)
COPY start.sh /var/www/html/start.sh
RUN chmod +x /var/www/html/start.sh

# Exécuter le script de démarrage
CMD ["/var/www/html/start.sh"]
