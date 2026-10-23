package com.mealmate.recipe_backend;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Service
public class JwtService {

    private final SecretKey key;

    public JwtService(@Value("${app.jwt.secret}") String secret) {
        this.key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }

    public String create(AppUser user) {
        Date now = new Date();
        return Jwts.builder()
                .subject(user.email)
                .claim("name", user.name)
                .issuedAt(now)
                .expiration(new Date(now.getTime() + 7L * 24 * 60 * 60 * 1000))
                .signWith(key)
                .compact();
    }

    public String emailFrom(String token) {
        return Jwts.parser().verifyWith(key).build()
                .parseSignedClaims(token).getPayload().getSubject();
    }
}