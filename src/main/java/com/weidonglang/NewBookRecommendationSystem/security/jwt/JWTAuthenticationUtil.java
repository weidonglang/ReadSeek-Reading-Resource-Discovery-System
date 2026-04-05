package com.weidonglang.NewBookRecommendationSystem.security.jwt;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTCreationException;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Calendar;
import java.util.Date;
@Component
public class JWTAuthenticationUtil {
    private static final String JWT_SUBJECT = "Library Authentication";
    private static final String CURRENT_ISSUER = "NewBookRecommendationSystem";
    private static final String LEGACY_ISSUER = "Henry";

    @Value("${library.security.jwtSecret}")
    private String JWT_AUTHENTICATION_SECRET;

    @Value("${library.security.jwt.accessToken.expirationMs}")
    private String JWT_ACCESS_TOKEN_EXPIRATION_MS;

    public String generateAccessToken(String email) throws JWTCreationException {
        return JWT.create().withSubject(JWT_SUBJECT).withIssuer(CURRENT_ISSUER).withIssuedAt(new Date())
                .withExpiresAt(getAccessTokenExpireDate())
                .withClaim("email", email).sign(Algorithm.HMAC256(JWT_AUTHENTICATION_SECRET));
    }

    public String getAccessTokenUserEmail(String accessToken) {
        try {
            return verifyTokenWithIssuer(accessToken, CURRENT_ISSUER).getClaim("email").asString();
        } catch (JWTVerificationException ignored) {
            return verifyTokenWithIssuer(accessToken, LEGACY_ISSUER).getClaim("email").asString();
        }
    }

    public void verifyAccessTokenExpiration(String accessToken) {
        DecodedJWT jwtToken = JWT.decode(accessToken);
        if (jwtToken.getExpiresAt().before(new Date()))
            throw new JWTVerificationException("Expired Access Token");
    }

    private Date getAccessTokenExpireDate() {
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.MILLISECOND, Integer.parseInt(JWT_ACCESS_TOKEN_EXPIRATION_MS));
        return cal.getTime();
    }

    private DecodedJWT verifyTokenWithIssuer(String accessToken, String issuer) {
        return JWT.require(Algorithm.HMAC256(JWT_AUTHENTICATION_SECRET))
                .withSubject(JWT_SUBJECT)
                .withIssuer(issuer)
                .build()
                .verify(accessToken);
    }
}
