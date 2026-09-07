package com.chams.tpe_backend.controller;

import com.chams.tpe_backend.model.Panne;
import com.chams.tpe_backend.service.PanneService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pannes")
public class PanneController {

    @Autowired
    private PanneService panneService;

    @PreAuthorize("hasAnyRole('ADMIN','TECHNICIEN')")
    @GetMapping
    public List<Panne> GetAllPannes() {
        return panneService.getAllPannes();
    }

    @PreAuthorize("hasAnyRole('ADMIN','TECHNICIEN')")
    @GetMapping("/{id}")
    public Panne GetPanneById(@PathVariable long id) {
        return panneService.getPanneById(id);
    }


    @PostMapping
    public Panne declarerPanne(@RequestBody Panne panne) {
        return panneService.declarerPanne(panne);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public void deletePanne(@PathVariable Long id) {
        panneService.deletePanne(id);
    }
}