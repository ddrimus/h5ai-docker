# Use Nginx with Alpine Linux as base image
FROM nginx:1.27-alpine3.19

# Runtime configuration variables  
ENV TZ='Europe/Rome' \
    PUID=1000 \
    PGID=1000

# Install core packages and backup default nginx config
RUN apk update && apk add --no-cache \
    bash bash-completion supervisor tzdata shadow curl \
    php82 php82-fpm php82-session php82-json php82-xml php82-mbstring php82-exif \
    php82-intl php82-gd php82-pecl-imagick php82-zip php82-opcache \
    ffmpeg imagemagick zip && \
    rm -rf /var/cache/apk/* && \
    mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak

# Deploy configuration files to system locations
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/php_set_timezone.ini /etc/php82/conf.d/00_timezone.ini
COPY config/php_set_jit.ini /etc/php82/conf.d/00_jit.ini
COPY config/php_set_memory_limit.ini /etc/php82/conf.d/00_memlimit.ini
COPY config/php_h5ai_optimizations.ini /etc/php82/conf.d/01_h5ai_optimizations.ini
COPY config/h5ai.conf /etc/nginx/conf.d/h5ai.conf

# Deploy h5ai application files
COPY config/_h5ai /usr/share/h5ai/_h5ai

# Deploy initialization script with execute permissions
COPY --chmod=755 config/init.sh /init.sh

# Create directories and set ownership for nginx user  
RUN mkdir -p /config /h5ai && \
    chown -R nginx:nginx /config /h5ai

# Expose HTTP port for web access
EXPOSE 80

# Persistent storage for configuration and data
VOLUME ["/config", "/h5ai"]

# Container health monitoring
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Set the initialization script as container entry point
ENTRYPOINT ["/init.sh"]