package com.demoapp.user;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @GetMapping
    public List<Map<String, Object>> listUsers() {
        return Arrays.asList(
            user(1L, "Alice", "alice@demo-app.local"),
            user(2L, "Bob", "bob@demo-app.local")
        );
    }

    @GetMapping("/profile")
    public Map<String, Object> currentProfile() {
        return user(1L, "Alice", "alice@demo-app.local");
    }

    private Map<String, Object> user(Long id, String name, String email) {
        Map<String, Object> response = new LinkedHashMap<String, Object>();
        response.put("id", id);
        response.put("name", name);
        response.put("email", email);
        return response;
    }
}