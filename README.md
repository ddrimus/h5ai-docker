# h5ai-docker

A lightweight, high-performance Docker container for h5ai - a modern file indexer for HTTP web servers with optimized configurations and multi-architecture support.

h5ai replaces default directory listings with enhanced features including search capabilities, file previews, thumbnail generation, and customizable interfaces. This Docker implementation provides deployment with performance optimizations and security hardening.

## Features

**🏗️ Core Stack**: Alpine Linux 3.21, Nginx 1.27, PHP 8.2.29 with JIT compilation and OPcache, h5ai 0.30.0.

**⚡ Performance**: High-performance Nginx configuration, PHP JIT compilation, efficient caching and compression, optimized for large file serving up to 10GB with resume capability.

**🔧 Management**: Automatic configuration backup/migration, built-in health checks, comprehensive logging, environment-based configuration with Supervisor process management.

**🌐 Compatibility**: Multi-architecture support (AMD64, ARM64, ARMv7, ARMv6), security-hardened base, proper permissions, and rate limiting.

## Quick Start

### Option 1: Docker Run

Run h5ai instantly with Docker:

```bash
docker run -d \
  --name h5ai \
  --restart unless-stopped \
  -p 80:80 \
  -v "$(PWD)/config:/config" \
  -v "$(PWD)/data:/h5ai" \
  -e TZ=Europe/Rome \
  -e PUID=1000 \
  -e PGID=1000 \
  ghcr.io/ddrimus/h5ai-docker:latest
```

### Option 2: Docker Compose (Recommended)

For a cleaner and more manageable setup, use Docker Compose:

```yaml
services:
  h5ai:
    image: ghcr.io/ddrimus/h5ai-docker:latest
    container_name: h5ai
    restart: unless-stopped
    environment:
      TZ: "Europe/Rome"
      PUID: "1000"
      PGID: "1000"
    volumes:
      - "$PWD/config:/config"
      - "$PWD/data:/h5ai"
    ports:
      - "80:80"
```

Start the container with:

```bash
docker-compose up -d
```

### First Run

This will create two folders in your current directory:
* `data` - where your shared files will be stored and indexed by h5ai.
* `config` - containing all configuration files for h5ai and related services.

After running the container, open http://YOUR_SERVER_IP:80 in your browser to access the file indexer.

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TZ` | `Europe/Rome` | Timezone for the container |
| `PUID` | `1000` | User ID for file permissions |
| `PGID` | `1000` | Group ID for file permissions |

### Volume Mounts

| Path | Description |
|------|-------------|
| `/h5ai` | Your files and directories to be indexed |
| `/config` | Persistent configuration and cache data |

### Advanced Configuration

The container automatically manages h5ai configuration. For advanced customization:
* h5ai configuration files are located in `/config/_h5ai/`.
* Nginx configuration file is `/config/nginx.conf`.
* PHP configuration files are in `/config/`.

## Performance Tuning

### For Large File Collections
- Increase PHP memory limit in `config/php_set_memory_limit.ini`.
- Adjust Nginx worker processes in `config/nginx.conf`.
- Configure appropriate disk space for cache.

### For High Traffic
- Enable rate limiting in Nginx configuration.
- Adjust connection limits based on requirements.
- Monitor container resources and scale as needed.

## Security Considerations
- Run with non-root user (PUID/PGID).
- Use proper file permissions.
- Consider placing behind reverse proxy with SSL.
- Regularly update the container image.
- Monitor access logs for suspicious activity.

## Contributing

If you have any improvements, additional information, or notice any issues with the Docker containerization or optimizations, we'd love to hear from you! Feel free to open a pull request with your suggestions or details.

If you encounter any problems with the Docker integration or believe something isn't working as expected, please provide all relevant information in an issue.

For h5ai core functionality issues, please visit the original repository.

## Disclaimer

This Docker integration is not affiliated with the original h5ai project ([https://github.com/lrsjng/h5ai/](https://github.com/lrsjng/h5ai/)). h5ai is an independent open-source project created by Lars Jung. This repository provides only a Docker containerization of h5ai with performance optimizations and deployment enhancements. 

All credit for the core h5ai functionality goes to the original h5ai developers. This Docker implementation focuses solely on providing an optimized containerized deployment solution with security hardening, performance tuning, and ease of deployment features.