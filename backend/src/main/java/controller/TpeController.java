package com.chams.tpe_backend.controller;

import com.chams.tpe_backend.model.Role;
import com.chams.tpe_backend.model.Tpe;
import com.chams.tpe_backend.model.Utilisateur;
import com.chams.tpe_backend.repository.TpeRepository;
import com.chams.tpe_backend.service.TpeService;
import com.chams.tpe_backend.service.UtilisateurService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tpe")
public class TpeController {

    @Autowired
    private TpeService tpeService;

    @Autowired
    private TpeRepository tpeRepository;

    @Autowired
    private UtilisateurService utilisateurService;

    @PreAuthorize("hasAnyRole('ADMIN','TECHNICIEN')")
    @GetMapping
    public List<Tpe> getAllTpe() {
        return tpeService.getAllTpe();
    }

    @PreAuthorize("hasAnyRole('ADMIN','TECHNICIEN')")
    @GetMapping("/{id}")
    public Tpe getTpeById(@PathVariable long id) {
        return tpeService.getTpeById(id);
    }

    @GetMapping("/pour-declaration")
    public List<Tpe> getTpePourDeclaration() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        Utilisateur utilisateur = utilisateurService.getUtilisateurByEmail(email);

        if (utilisateur.getRole() == Role.USER && utilisateur.getStation() != null) {
            return tpeRepository.findTpeActifsParStation(utilisateur.getStation().getId());
        }
        return tpeService.getAllTpe();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public Tpe createTpe(@RequestBody Tpe tpe) {
        return tpeService.createTpe(tpe);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public void deleteTpe(@PathVariable Long id) {
        tpeService.deleteTpe(id);
    }
}
