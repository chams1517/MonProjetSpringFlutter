package com.chams.tpe_backend.service;

import com.chams.tpe_backend.model.EtatTpe;
import com.chams.tpe_backend.model.Panne;
import com.chams.tpe_backend.model.Station;
import com.chams.tpe_backend.model.Tpe;
import com.chams.tpe_backend.repository.AffectationRepository;
import com.chams.tpe_backend.repository.PanneRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PanneService {

    @Autowired
    private PanneRepository panneRepository;

    @Autowired
    private TpeService tpeService;

    @Autowired
    private AffectationService affectationService;

    @Autowired
    private AffectationRepository affectationRepository;

    public List<Panne> getAllPannes() {
        return panneRepository.findAll();
    }

    public Panne getPanneById(long id) {
        return panneRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("panne introuvable avec l'id"));
    }

    public Panne declarerPanne(Panne panne) {
        Tpe tpe = tpeService.getTpeById(panne.getTpe().getId());

        // Garde-fou : on ne déclare pas une panne sur un TPE déjà en panne, en réparation, ou hors service.
        if (tpe.getEtat() == EtatTpe.EN_PANNE || tpe.getEtat() == EtatTpe.EN_REPARATION || tpe.getEtat() == EtatTpe.HORS_SERVICE) {
            throw new RuntimeException("Ce TPE a déjà une panne en cours (état : " + tpe.getEtat() + ")");
        }

        Station stationActuelle = affectationRepository.findByTpeAndDateFinIsNull(tpe)
                .map(a -> a.getStation())
                .orElse(null);
        panne.setStation(stationActuelle);

        affectationService.desaffecterSiActive(tpe);

        tpe.setEtat(EtatTpe.EN_PANNE);
        tpeService.updateTpe(tpe);

        panne.setTpe(tpe);
        return panneRepository.save(panne);
    }

    public Panne updatePanne(Panne panne) {
        return panneRepository.save(panne);
    }

    public void deletePanne(Long id) {
        panneRepository.deleteById(id);
    }

}