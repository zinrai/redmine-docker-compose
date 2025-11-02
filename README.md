# redmine-docker-compose

Docker Compose setup for Redmine with PostgreSQL.

For production, consider using a reverse proxy like Nginx or Caddy.

## Architecture

```
[Client] -> [Reverse Proxy] :80/:443 (optional) -> [Docker: Redmine] :3000 -> [Docker: PostgreSQL] :5432
```

## Use Cases

For environment variables in `.env`, see:

- PostgreSQL: https://hub.docker.com/_/postgres
- Redmine: https://hub.docker.com/_/redmine

Default credentials: https://hub.docker.com/_/redmine#accessing-the-application

### New Installation

```bash
# 1. Configure environment variables
cp .env.example .env
vi .env

# 2. Create volumes
docker volume create postgres_data
docker volume create redmine_files
docker volume create redmine_plugins

# 3. Start services
docker compose up -d
```

### Migration from Existing Redmine

```bash
# 1. Configure environment variables
cp .env.example .env
vi .env

# 2. Create volumes
docker volume create postgres_data
docker volume create redmine_files
docker volume create redmine_plugins

# 3. Place your backup file (backup.sql) in project root

# 4. Generate restore commands
./scripts/generate-restore-commands.sh backup.sql
# The script outputs commands to execute. Run them one by one.

# 5. Start Redmine
docker compose up -d redmine
```

## License

This project is licensed under the [MIT License](./LICENSE).
