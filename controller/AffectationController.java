package com.chams.tpe_backend.controller;

import com.chams.tpe_backend.model.Affectation;
import com.chams.tpe_backend.service.AffectationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/affectations")
@PreAuthorize("hasAnyRole('ADMIN','TECHNICIEN')")
public class AffectationController {

    @Autowired
    private AffectationService affectationService;

    @GetMapping
    public List<Affectation> getAllAffectations() {
        return affectationService.getAllAffectations();
    }

    /** Affectations en cours — pour la liste filtrable et le sélecteur de station en déclarant une panne. */
    @GetMapping("/actives")
    public List<Affectation> getAffectationsActives() {
        return affectationService.getAffectationsActives();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/affecter")
    public Affectation affecterTpe(@RequestParam Long tpeId, @RequestParam Long stationId) {
        return affectationService.affecterTpe(tpeId, stationId);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/desaffecter")
    public Affectation desaffecterTpe(@RequestParam Long tpeId) {
        return affectationService.desaffecterTpe(tpeId);
    }
}