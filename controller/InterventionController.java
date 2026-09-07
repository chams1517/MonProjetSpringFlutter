package com.chams.tpe_backend.controller;

import com.chams.tpe_backend.model.Intervention;
import com.chams.tpe_backend.service.InterventionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/interventions")
@PreAuthorize("hasAnyRole('ADMIN','TECHNICIEN')")
public class InterventionController {

    @Autowired
    private InterventionService interventionService;

    @GetMapping
    public List<Intervention> getAllInterventions() {
        return interventionService.getAllInterventionRepository();
    }

    @GetMapping("/{id}")
    public Intervention getInterventionById(@PathVariable Long id) {
        return interventionService.getInerventionById(id);
    }

    @PostMapping
    public Intervention creerIntervention(@RequestBody Intervention intervention) {
        return interventionService.creerIntervention(intervention);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public void deleteIntervention(@PathVariable Long id) {
        interventionService.deleteIntervention(id);
    }
}