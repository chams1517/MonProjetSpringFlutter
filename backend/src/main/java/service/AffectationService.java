package com.chams.tpe_backend.service;

import com.chams.tpe_backend.model.*;
import com.chams.tpe_backend.repository.AffectationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class AffectationService {

    @Autowired
    private AffectationRepository affectationRepository;

    @Autowired
    private TpeService tpeService;

    @Autowired
    private StationService stationService;

    public List<Affectation> getAllAffectations() {
        return affectationRepository.findAll();
    }

    /** Uniquement les affectations en cours (dateFin = NULL) — pour la liste filtrable et le sélecteur de station. */
    public List<Affectation> getAffectationsActives() {
        return affectationRepository.findByDateFinIsNull();
    }

    public Affectation affecterTpe(Long tpeId, Long stationId) {
        Tpe tpe = tpeService.getTpeById(tpeId);
        Station station = stationService.getStationById(stationId);

        // Garde-fou métier : on n'affecte pas un TPE en panne ou en réparation à une station.
        // Il doit d'abord être réparé (retour automatique via InterventionService) ou revenir en stock.
        if (tpe.getEtat() == EtatTpe.EN_PANNE || tpe.getEtat() == EtatTpe.EN_REPARATION) {
            throw new RuntimeException("Ce TPE est " + tpe.getEtat() + " et ne peut pas être affecté pour le moment");
        }

        affectationRepository.findByTpeAndDateFinIsNull(tpe).ifPresent(ancienne -> {
            ancienne.setDateFin(LocalDateTime.now());
            affectationRepository.save(ancienne);
        });

        Affectation affectation = new Affectation();
        affectation.setTpe(tpe);
        affectation.setStation(station);
        affectation.setDateDebut(LocalDateTime.now());
        Affectation saved = affectationRepository.save(affectation);

        tpe.setEtat(EtatTpe.AFFECTE);
        tpeService.updateTpe(tpe);

        return saved;
    }

    public Affectation desaffecterTpe(Long tpeId) {
        Tpe tpe = tpeService.getTpeById(tpeId);

        Affectation affectation = affectationRepository.findByTpeAndDateFinIsNull(tpe)
                .orElseThrow(() -> new RuntimeException("Ce TPE n'est actuellement affecté à aucune station"));

        affectation.setDateFin(LocalDateTime.now());
        Affectation saved = affectationRepository.save(affectation);

        tpe.setEtat(EtatTpe.EN_STOCK);
        tpeService.updateTpe(tpe);

        return saved;
    }

    public void desaffecterSiActive(Tpe tpe) {
        affectationRepository.findByTpeAndDateFinIsNull(tpe).ifPresent(affectation -> {
            affectation.setDateFin(LocalDateTime.now());
            affectationRepository.save(affectation);
        });
    }
}