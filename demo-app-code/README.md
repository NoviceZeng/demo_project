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
cd /Users/novice/Desktop/test/demo/demo_project/demo-app-code
mvn clean package
```

## Build Docker images

Build one service image with the shared helper script:

```bash
cd /Users/novice/Desktop/test/demo/demo_project/demo-app-code
bash build-image.sh user-service harbor.test.com latest
```

Build without pushing:

```bash
cd /Users/novice/Desktop/test/demo/demo_project/demo-app-code
bash build-image.sh user-service harbor.test.com latest skip-push
```

If the module was already packaged, skip the Maven build step:

```bash
cd /Users/novice/Desktop/test/demo/demo_project/demo-app-code
bash build-image.sh user-service harbor.test.com latest skip-package
```

The project also includes a reusable template file:

```bash
Dockerfile.template
```

It is adapted from the Jenkins pipeline template and updated for Spring Boot Maven output using `target/*.jar`.

## Run a single service

Example: start `user-service`

```bash
cd /Users/novice/Desktop/test/demo/demo_project/demo-app-code
mvn -pl user-service spring-boot:run
```

Example: start `api-gateway`

```bash
cd /Users/novice/Desktop/test/demo/demo_project/demo-app-code
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
