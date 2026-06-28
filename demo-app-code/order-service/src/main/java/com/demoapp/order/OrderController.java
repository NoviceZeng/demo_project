package com.demoapp.order;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @GetMapping
    public List<Map<String, Object>> listOrders() {
        return Arrays.asList(
            order("ORD-10001", "PAID", new BigDecimal("99.98")),
            order("ORD-10002", "CREATED", new BigDecimal("29.99"))
        );
    }

    @GetMapping("/summary")
    public Map<String, Object> summary() {
        Map<String, Object> response = new LinkedHashMap<String, Object>();
        response.put("totalOrders", 2);
        response.put("pendingOrders", 1);
        response.put("paidOrders", 1);
        return response;
    }

    private Map<String, Object> order(String orderNo, String status, BigDecimal amount) {
        Map<String, Object> response = new LinkedHashMap<String, Object>();
        response.put("orderNo", orderNo);
        response.put("status", status);
        response.put("amount", amount);
        return response;
    }
}