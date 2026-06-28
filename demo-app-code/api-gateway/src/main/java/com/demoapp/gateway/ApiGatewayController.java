package com.demoapp.gateway;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class ApiGatewayController {

    @GetMapping("/health")
    public Map<String, Object> health() {
        Map<String, Object> response = new LinkedHashMap<String, Object>();
        response.put("service", "api-gateway");
        response.put("status", "UP");
        return response;
    }

    @GetMapping("/routes")
    public List<Map<String, String>> routes() {
        return Arrays.asList(
            route("user-service", "http://localhost:9002/api/users"),
            route("product-service", "http://localhost:9003/api/products"),
            route("order-service", "http://localhost:9006/api/orders"),
            route("payment-service", "http://localhost:9007/api/payments")
        );
    }

    private Map<String, String> route(String service, String url) {
        Map<String, String> route = new LinkedHashMap<String, String>();
        route.put("service", service);
        route.put("url", url);
        return route;
    }
}