package com.chams.tpe_backend.service;

import com.chams.tpe_backend.model.*;
import com.chams.tpe_backend.repository.InterventionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class InterventionService {

    @Autowired
    private InterventionRepository interventionRepository;

    @Autowired
    private PanneService panneService;

    @Autowired
    private TpeService tpeService;

    @Autowired
    private AffectationService affectationService;

    public List<Intervention> getAllInterventionRepository() {
        return interventionRepository.findAll();
    }

    public Intervention getInerventionById(long id) {
        return interventionRepository.findById(id).orElseThrow(() -> new RuntimeException("id introuvable !"));
    }

    public Intervention creerIntervention(Intervention intervention) {
        Panne panne = panneService.getPanneById(intervention.getPanne().getId());
        intervention.setPanne(panne);

        if (intervention.getResultat() == ResultatIntervention.REUSSIE) {
            panne.setStatut(StatutPanne.RESOLUE);
            panneService.updatePanne(panne);

            Tpe tpe = panne.getTpe();

            if (panne.getStation() != null) {
                // Réaffectation automatique à la même station qu'avant la panne
                affectationService.affecterTpe(tpe.getId(), panne.getStation().getId());
            } else {
                // Cas rare : le TPE n'était affecté à aucune station au moment de la panne
                tpe.setEtat(EtatTpe.REPARE);
                tpeService.updateTpe(tpe);
            }
        }

        return interventionRepository.save(intervention);
    }

    public void deleteIntervention(Long id) {
        interventionRepository.deleteById(id);
    }
}