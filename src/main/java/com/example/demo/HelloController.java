package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;

@RestController
public class HelloController {

    @Value("${ENVIRONMENT:unknown}")
    private String environment;

    @Value("${VERSION:unknown}")
    private String version;

    @GetMapping("/")
    public Map<String, String> home() throws UnknownHostException {
        Map<String, String> response = new HashMap<>();
        response.put("message", "Hello from Blue-Green Deployment!");
        response.put("environment", environment);
        response.put("version", version);
        response.put("hostname", InetAddress.getLocalHost().getHostName());
        response.put("status", "running");
        return response;
    }

    @GetMapping("/health")
    public Map<String, String> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("environment", environment);
        return response;
    }
}
