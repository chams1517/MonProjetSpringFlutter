package com.chams.tpe_backend.controller;

import com.chams.tpe_backend.model.TypePanne;
import com.chams.tpe_backend.service.TypePanneService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/types-panne")
public class TypePanneController {

    @Autowired
    private TypePanneService typePanneService;

    @GetMapping
    public List<TypePanne> getAllTypePannes() {
        return typePanneService.getAllTypePannes();
    }

    @GetMapping("/{id}")
    public TypePanne getTypePanneById(@PathVariable Long id) {
        return typePanneService.getTypePanneById(id);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public TypePanne createTypePanne(@RequestBody TypePanne typePanne) {
        return typePanneService.createTypePanne(typePanne);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public void deleteTypePanne(@PathVariable Long id) {
        typePanneService.deleteTypePanne(id);
    }
}