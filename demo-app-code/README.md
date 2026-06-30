# demo-app-code

Simple e-commerce microservices demo built with Spring Boot and JDK 8.

## Services

- `api-gateway` on port `8080`
- `user-service` on port `9002`
- `product-service` on port `9003`
- `order-service` on port `9006`
- `payment-service` on port `9007`

Each service is intentionally small and exposes a few demo REST endpoints.

## Requirements

- JDK 8
- Maven 3.8+

## Build all services

```bash
cd demo_project/demo-app-code
mvn clean package
```

## Build Docker images

Build one service image with the shared helper script:

```bash
cd demo_project/demo-app-code
bash build-image.sh user-service harbor.test.com latest
```

Build without pushing:

```bash
cd demo_project/demo-app-code
bash build-image.sh user-service harbor.test.com latest skip-push
```

If the module was already packaged, skip the Maven build step:

```bash
cd demo_project/demo-app-code
bash build-image.sh user-service harbor.test.com latest skip-package
```

## Manual image build guide

This project provides two ways to build images manually.

### Option 1: Use the shared helper script

This is the recommended approach for developers because it follows the same flow used by the pipeline.

Command format:

```bash
bash build-image.sh <service> <harbor> <tag> [skip-package] [skip-push]
```

Examples:

```bash
cd demo_project/demo-app-code

# Package the module, build the image, and push it
bash build-image.sh user-service harbor.test.com dev-001

# Package the module and build locally without pushing
bash build-image.sh product-service harbor.test.com local-test skip-push

# Reuse an existing target jar and build only
bash build-image.sh order-service harbor.test.com local-test skip-package skip-push
```

What the script does:

1. Validates that the service module directory exists.
2. Runs Maven package unless `skip-package` is provided.
3. Enters the selected module directory.
4. Builds the Docker image using the module Dockerfile.
5. Pushes the image unless `skip-push` is provided.

Generated image name format:

```text
<harbor>/demo-app/demo-app-<service>:<tag>
```

Example:

```text
harbor.test.com/demo-app/demo-app-user-service:dev-001
```

### Option 2: Build with Maven and docker manually

If you want full manual control, you can package the module yourself and then run `docker build` directly.

Example:

```bash
cd demo_project/demo-app-code

# Build the jar
mvn -pl user-service -am clean package

# Build the image from the module directory
cd user-service
docker build -t harbor.test.com/demo-app/demo-app-user-service:local-test .
```

Push manually if needed:

```bash
docker push harbor.test.com/demo-app/demo-app-user-service:local-test
```

### Prerequisites for manual image builds

- Docker daemon must be running.
- You must be logged in to the target Harbor registry before pushing.
- Maven must be available if you do not use `skip-package`.

## Run a single service

Example: start `user-service`

```bash
cd demo_project/demo-app-code
mvn -pl user-service spring-boot:run
```

Example: start `api-gateway`

```bash
cd demo_project/demo-app-code
mvn -pl api-gateway spring-boot:run
```

## Sample endpoints

- `GET http://localhost:8080/api/routes`
- `GET http://localhost:9002/api/users`
- `GET http://localhost:9003/api/products`
- `GET http://localhost:9006/api/orders`
- `POST http://localhost:9007/api/payments/pay`

## Project layout

This is a Maven multi-module project. Each microservice contains:

- one Spring Boot application class
- one simple REST controller
- one `application.yml` with its server port
