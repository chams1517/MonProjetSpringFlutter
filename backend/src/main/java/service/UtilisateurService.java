package com.chams.tpe_backend.service;

import com.chams.tpe_backend.model.Station;
import com.chams.tpe_backend.model.Utilisateur;
import com.chams.tpe_backend.repository.UtilisateurRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UtilisateurService {

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private StationService stationService;

    public Utilisateur creerUtilisateur(Utilisateur user) {
        String motDePasseHache = passwordEncoder.encode(user.getMotDePasse());
        user.setMotDePasse(motDePasseHache);

       
        if (user.getStation() != null && user.getStation().getId() != null) {
            Station station = stationService.getStationById(user.getStation().getId());
            user.setStation(station);
        }

        return utilisateurRepository.save(user);
    }

    public Utilisateur getUtilisateurByEmail(String email) {
        return utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Utilisateur introuvable avec l'email " + email));
    }

    public List<Utilisateur> getAllUtilisateurs() {
        return utilisateurRepository.findAll();
    }

    public Utilisateur getUtilisateurById(Long id) {
        return utilisateurRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Utilisateur introuvable avec l'id " + id));
    }

    public Utilisateur updateUtilisateur(Long id, Utilisateur donneesMaj) {
        Utilisateur utilisateur = getUtilisateurById(id);

        utilisateur.setNom(donneesMaj.getNom());
        utilisateur.setPrenom(donneesMaj.getPrenom());
        utilisateur.setEmail(donneesMaj.getEmail());
        utilisateur.setRole(donneesMaj.getRole());

        if (donneesMaj.getStation() != null && donneesMaj.getStation().getId() != null) {
            Station station = stationService.getStationById(donneesMaj.getStation().getId());
            utilisateur.setStation(station);
        } else {
            utilisateur.setStation(null);
        }

        if (donneesMaj.getMotDePasse() != null && !donneesMaj.getMotDePasse().isBlank()) {
            utilisateur.setMotDePasse(passwordEncoder.encode(donneesMaj.getMotDePasse()));
        }

        return utilisateurRepository.save(utilisateur);
    }

    public void deleteUtilisateur(Long id) {
        utilisateurRepository.deleteById(id);
    }
}
