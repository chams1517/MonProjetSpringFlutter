package com.chams.tpe_backend.controller;

import com.chams.tpe_backend.config.JwtUtil;
import com.chams.tpe_backend.dto.LoginRequest;
import com.chams.tpe_backend.dto.LoginResponse;
import com.chams.tpe_backend.model.Role;
import com.chams.tpe_backend.model.Utilisateur;
import com.chams.tpe_backend.service.UtilisateurService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UtilisateurService utilisateurService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public LoginResponse login(@RequestBody LoginRequest loginRequest) {
        Utilisateur utilisateur = utilisateurService.getUtilisateurByEmail(loginRequest.getEmail());

        boolean motDePasseCorrect = passwordEncoder.matches(
                loginRequest.getMotDePasse(),
                utilisateur.getMotDePasse()
        );

        if (!motDePasseCorrect) {
            throw new RuntimeException("Mot de passe incorrect");
        }

        String token = jwtUtil.genererToken(utilisateur.getEmail());

        Long stationId = utilisateur.getStation() != null ? utilisateur.getStation().getId() : null;
        String stationNom = utilisateur.getStation() != null ? utilisateur.getStation().getNom() : null;

        return new LoginResponse(token, utilisateur.getEmail(), utilisateur.getRole().toString(), stationId, stationNom);
    }

    @PostMapping("/register")
    public Utilisateur register(@RequestBody Utilisateur utilisateur) {
        // Sécurité : l'inscription publique ne peut jamais créer un ADMIN ou un compte USER (station).
        // Seul un admin peut créer ces comptes via /api/utilisateurs.
        utilisateur.setRole(Role.TECHNICIEN);
        utilisateur.setStation(null);
        return utilisateurService.creerUtilisateur(utilisateur);
    }
}