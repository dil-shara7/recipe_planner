package com.mealmate.recipe_backend;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestClient;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final UserRepository users;
    private final JwtService jwt;
    private final String googleClientId;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public AuthController(UserRepository users, JwtService jwt,
                          @Value("${app.google.client-id}") String googleClientId) {
        this.users = users;
        this.jwt = jwt;
        this.googleClientId = googleClientId;
    }

    private static boolean strong(String p) {
        return p != null && p.length() >= 5 && p.matches(".*[a-z].*") && p.matches(".*[0-9].*");
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Map<String, String> body) {
        String name = body.getOrDefault("name", "").trim();
        String email = body.getOrDefault("email", "").trim().toLowerCase();
        String password = body.get("password");

        if (name.isEmpty() || !email.contains("@")) {
            return ResponseEntity.badRequest().body(Map.of("error", "Enter a name and a valid email"));
        }
        if (!strong(password)) {
            return ResponseEntity.badRequest().body(Map.of("error",
                    "Password needs at least 5 characters, a lowercase letter and a number"));
        }
        if (users.findByEmail(email).isPresent()) {
            return ResponseEntity.status(409).body(Map.of("error", "This email is already registered"));
        }

        AppUser u = new AppUser();
        u.name = name;
        u.email = email;
        u.passwordHash = encoder.encode(password);
        users.save(u);
        return ResponseEntity.ok(Map.of("token", jwt.create(u), "name", u.name, "email", u.email));
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> body) {
        String email = body.getOrDefault("email", "").trim().toLowerCase();
        String password = body.getOrDefault("password", "");

        return users.findByEmail(email)
                .filter(u -> encoder.matches(password, u.passwordHash))
                .<ResponseEntity<?>>map(u -> ResponseEntity.ok(
                        Map.of("token", jwt.create(u), "name", u.name, "email", u.email)))
                .orElse(ResponseEntity.status(401).body(Map.of("error", "Wrong email or password")));
    }

    @PostMapping("/google")
    @SuppressWarnings("unchecked")
    public ResponseEntity<?> google(@RequestBody Map<String, String> body) {
        try {
            Map<String, Object> info = RestClient.create().get()
                    .uri("https://oauth2.googleapis.com/tokeninfo?id_token=" + body.get("idToken"))
                    .retrieve().body(Map.class);

            if (info == null || !googleClientId.equals(info.get("aud"))) {
                return ResponseEntity.status(401).body(Map.of("error", "Invalid Google token"));
            }
            String email = String.valueOf(info.get("email")).toLowerCase();
            String name = String.valueOf(info.getOrDefault("name", email));

            AppUser u = users.findByEmail(email).orElseGet(() -> {
                AppUser n = new AppUser();
                n.name = name;
                n.email = email;
                n.passwordHash = encoder.encode(UUID.randomUUID().toString());
                return users.save(n);
            });
            return ResponseEntity.ok(Map.of("token", jwt.create(u), "name", u.name, "email", u.email));
        } catch (Exception e) {
            return ResponseEntity.status(401).body(Map.of("error", "Google sign-in failed"));
        }
    }

    @GetMapping("/me")
    public ResponseEntity<?> me(@RequestHeader(value = "Authorization", required = false) String header) {
        try {
            String token = header.substring(7);
            String email = jwt.emailFrom(token);
            return users.findByEmail(email)
                    .<ResponseEntity<?>>map(u -> ResponseEntity.ok(Map.of("name", u.name, "email", u.email)))
                    .orElse(ResponseEntity.status(401).body(Map.of("error", "Unknown user")));
        } catch (Exception e) {
            return ResponseEntity.status(401).body(Map.of("error", "Invalid or missing token"));
        }
    }
}