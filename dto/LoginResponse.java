package com.chams.tpe_backend.dto;

public class LoginResponse {

    private String token;
    private String email;
    private String role;
    private Long stationId;
    private String stationNom;

    public LoginResponse(String token, String email, String role, Long stationId, String stationNom) {
        this.token = token;
        this.email = email;
        this.role = role;
        this.stationId = stationId;
        this.stationNom = stationNom;
    }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public Long getStationId() { return stationId; }
    public void setStationId(Long stationId) { this.stationId = stationId; }
    public String getStationNom() { return stationNom; }
    public void setStationNom(String stationNom) { this.stationNom = stationNom; }
}