package com.chams.tpe_backend.controller;

import com.chams.tpe_backend.model.TypeIntervention;
import com.chams.tpe_backend.service.TypeInterventionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/types-intervention")
public class TypeInterventionController {

    @Autowired
    private TypeInterventionService typeInterventionService;

    @GetMapping
    public List<TypeIntervention> getAllTypeInterventions() {
        return typeInterventionService.getAllTypeInterventions();
    }

    @GetMapping("/{id}")
    public TypeIntervention getTypeInterventionById(@PathVariable Long id) {
        return typeInterventionService.getTypeInterventionById(id);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public TypeIntervention createTypeIntervention(@RequestBody TypeIntervention typeIntervention) {
        return typeInterventionService.createTypeIntervention(typeIntervention);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public void deleteTypeIntervention(@PathVariable Long id) {
        typeInterventionService.deleteTypeIntervention(id);
    }
}