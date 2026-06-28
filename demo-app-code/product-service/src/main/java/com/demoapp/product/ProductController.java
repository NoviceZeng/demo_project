package com.demoapp.product;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    @GetMapping
    public List<Map<String, Object>> listProducts() {
        return Arrays.asList(
            product(1001L, "Wireless Mouse", new BigDecimal("19.99"), true),
            product(1002L, "Mechanical Keyboard", new BigDecimal("79.99"), true),
            product(1003L, "Laptop Stand", new BigDecimal("29.99"), false)
        );
    }

    @GetMapping("/featured")
    public Map<String, Object> featuredProduct() {
        return product(1002L, "Mechanical Keyboard", new BigDecimal("79.99"), true);
    }

    private Map<String, Object> product(Long id, String name, BigDecimal price, boolean inStock) {
        Map<String, Object> response = new LinkedHashMap<String, Object>();
        response.put("id", id);
        response.put("name", name);
        response.put("price", price);
        response.put("inStock", inStock);
        return response;
    }
}