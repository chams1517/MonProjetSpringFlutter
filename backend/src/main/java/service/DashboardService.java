package com.chams.tpe_backend.service;

import com.chams.tpe_backend.dto.DashboardStats;
import com.chams.tpe_backend.model.*;
import com.chams.tpe_backend.repository.InterventionRepository;
import com.chams.tpe_backend.repository.PanneRepository;
import com.chams.tpe_backend.repository.TpeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class DashboardService {

    @Autowired
    private TpeRepository tpeRepository;

    @Autowired
    private PanneRepository panneRepository;

    @Autowired
    private InterventionRepository interventionRepository;

    public DashboardStats getStats() {
        DashboardStats stats = new DashboardStats();

        stats.setTotalTpe(tpeRepository.count());
        stats.setTpeEnStock(tpeRepository.countByEtat(EtatTpe.EN_STOCK));
        stats.setTpeAffecte(tpeRepository.countByEtat(EtatTpe.AFFECTE));
        stats.setTpeEnPanne(tpeRepository.countByEtat(EtatTpe.EN_PANNE));
        stats.setTpeEnReparation(tpeRepository.countByEtat(EtatTpe.EN_REPARATION));
        stats.setTpeRepare(tpeRepository.countByEtat(EtatTpe.REPARE));
        stats.setTpeHorsService(tpeRepository.countByEtat(EtatTpe.HORS_SERVICE));

        LocalDateTime debutMois = LocalDateTime.now().withDayOfMonth(1).toLocalDate().atStartOfDay();
        long interventionsCeMois = interventionRepository.findAll().stream()
                .filter(i -> i.getDateIntervention().isAfter(debutMois))
                .count();
        stats.setInterventionsCeMois(interventionsCeMois);

        List<Panne> pannes = panneRepository.findAll();

        Map<String, Long> parTpe = pannes.stream()
                .collect(Collectors.groupingBy(p -> p.getTpe().getNumeroSerie(), Collectors.counting()));
        List<Map<String, Object>> topTpe = parTpe.entrySet().stream()
                .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
                .limit(5)
                .map(e -> Map.<String, Object>of("numeroSerie", e.getKey(), "nombrePannes", e.getValue()))
                .collect(Collectors.toList());
        stats.setTpeLesPlusEnPanne(topTpe);

        Map<String, Long> parType = pannes.stream()
                .collect(Collectors.groupingBy(p -> p.getTypePanne().getLibelle(), Collectors.counting()));
        List<Map<String, Object>> topTypes = parType.entrySet().stream()
                .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
                .limit(5)
                .map(e -> Map.<String, Object>of("typePanne", e.getKey(), "nombre", e.getValue()))
                .collect(Collectors.toList());
        stats.setTypesPanneLesPlusFrequents(topTypes);

        return stats;
    }
}