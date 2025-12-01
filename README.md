# dokku compose

A dokku plugin for configuring deployment settings from a Docker Compose file.

## Installation

```bash
sudo dokku plugin:install https://github.com/enginuitygroup/dokku-compose.git
```

## Commands
```
compose:set-compose-path (<app>|--global) PATH # Sets the path to the Compose file
compose:report <app> # Shows configuration details for an app
```

## Usage

dokku-compose automatically generates `app.json` and `Procfile` files based on a Docker Compose configuration. It also sets process resource limits, if specified.

### Healthchecks

Specify health checks in your Compose file using the standard keys. For example:

```yaml
services:
  web:
    healthcheck:
      test: curl http://localhost:3000/health
      retries: 3
      interval: 30
      timeout: 10
```

This will generate the following app.json file:

```json
{
  "healthchecks": {
    "web": {
      "command": "curl http://localhost:3000/health",
      "attempts": 3,
      "initialDelay": 30,
      "timeout": 10,
      "wait": 30
    }
  }
}
```

Additional configuration options which are supported by Dokku but not Docker can be specified under the `x-dokku` key:

```yaml
services:
  web:
    healthcheck:
      x-dokku:
        type: "startup"
        path: "/health"
        port: 3000
        scheme: http
      retries: 3
      interval: 30
      timeout: 10
```

This will generate the following `app.json`:


```json
{
  "healthchecks": {
    "web": {
      "type": "startup",
      "path": "/health",
      "port": 3000,
      "scheme": "http",
      "attempts": 3,
      "initialDelay": 30,
      "wait": 30,
      "timeout": 10
    }
  }
}
```

### Procfile

The `Procfile` is automatically generated from the `command` key from each service in the Compose file. If the `command` key is not specified, no entry for that service will be added to the `Procfile`.

Given the following Compose file:

```yaml
services:
  web:
    command: bundle exec puma -C config/puma.rb

  worker:
    command: bundle exec sidekiq
```

dokku-compose will generate the following Procfile:

```
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq
```

Additional processes - like the special `release` process - can be specified using the top-level `x-dokku.procfile` key:

```yaml
x-dokku:
  procfile:
    release: bundle exec rails db:migrate

services:
  web:
    command: bundle exec puma -C config/puma.rb
```

### Process Scaling

dokku-compose uses the Compose file's service deploy settings for process scaling. For example:

```yaml
services:
  web:
    deploy:
      replicas: 2
      update_config:
        parallelism: 1
```

Given this Compose file, dokku-compose will generate the following `app.json`:

```json
{
  "formation": {
    "web": {
      "quantity": 2,
      "max_parallel": 1
    }
  }
}
```

### Resource Limits

> [!WARNING]
> If your compose file specifies resource limits, dokku-compose will **overwrite** any existing resource limits.

> [!NOTE]
> If you remove resource limits from a Compose file, dokku-compose will clear any existing resource limits **only** if they were originally set by the Compose file.

dokku-compose also pulls resource limits from the Compose file's deploy settings. Given the following Compose file:

```yaml
services:
  web:
    deploy:
      resources:
        limits:
          cpus: 1
          memory: 2G
```

On the next deploy, dokku-compose will set these resource limits using the builtin resource plugin.

### Scripts and Custom Settings

dokku-compose supports two top-level keys in the Compose file for advanced use cases: `x-dokku.procfile` and `x-dokku.app-json`.

These can be used for adding scripts or any other custom configuration not directly supported by dokku-compose.

`x-dokku.procfile` is a simple key/value hash that will be written directly to the Procfile. For example:

```yaml
x-dokku:
  procfile:
    web: bundle exec puma
    worker: bundle exec sidekiq
```

will create the following Procfile:

```
web: bundle exec puma
worker: bundle exec sidekiq
```

`x-dokku.app-json` is also a key/value hash that will be written as-is to the `app.json` file.

> [!NOTE]
> dokku-compose uses `x-dokku.app-json` as the base configuration. Service-specific configuration options are merged into this hash. As such, service-specific configuration options will take precedence.

Given the following Compose file:

```yaml
x-dokku:
  app-json:
    scripts:
      dokku:
        postdeploy: "notify-slack \"deploy complete!\""
```

dokku-compose will create the following `app.json`:

```json
{
  "scripts": {
    "dokku": {
      "postdeploy": "notify-slack \"deploy complete!\""
    }
  }
}
```