package com.demoapp.payment;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/payments")
public class PaymentController {

    @GetMapping("/methods")
    public Map<String, Object> methods() {
        Map<String, Object> response = new LinkedHashMap<String, Object>();
        response.put("defaultMethod", "CREDIT_CARD");
        response.put("supportedMethods", new String[] {"CREDIT_CARD", "PAYPAL", "APPLE_PAY"});
        return response;
    }

    @PostMapping("/pay")
    public Map<String, Object> pay(@RequestBody(required = false) Map<String, Object> request) {
        Map<String, Object> response = new LinkedHashMap<String, Object>();
        response.put("status", "SUCCESS");
        response.put("paymentId", "PAY-10001");
        response.put("amount", request != null && request.get("amount") != null ? request.get("amount") : new BigDecimal("99.99"));
        return response;
    }
}