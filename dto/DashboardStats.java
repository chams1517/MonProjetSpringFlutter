package com.chams.tpe_backend.dto;

import java.util.List;
import java.util.Map;

public class DashboardStats {
    private long totalTpe;
    private long tpeEnStock;
    private long tpeAffecte;
    private long tpeEnPanne;
    private long tpeEnReparation;
    private long tpeRepare;
    private long tpeHorsService;
    private long interventionsCeMois;
    private List<Map<String, Object>> tpeLesPlusEnPanne;
    private List<Map<String, Object>> typesPanneLesPlusFrequents;

    // Getters et setters
    public long getTotalTpe() { return totalTpe; }
    public void setTotalTpe(long totalTpe) { this.totalTpe = totalTpe; }
    public long getTpeEnStock() { return tpeEnStock; }
    public void setTpeEnStock(long tpeEnStock) { this.tpeEnStock = tpeEnStock; }
    public long getTpeAffecte() { return tpeAffecte; }
    public void setTpeAffecte(long tpeAffecte) { this.tpeAffecte = tpeAffecte; }
    public long getTpeEnPanne() { return tpeEnPanne; }
    public void setTpeEnPanne(long tpeEnPanne) { this.tpeEnPanne = tpeEnPanne; }
    public long getTpeEnReparation() { return tpeEnReparation; }
    public void setTpeEnReparation(long tpeEnReparation) { this.tpeEnReparation = tpeEnReparation; }
    public long getTpeRepare() { return tpeRepare; }
    public void setTpeRepare(long tpeRepare) { this.tpeRepare = tpeRepare; }
    public long getTpeHorsService() { return tpeHorsService; }
    public void setTpeHorsService(long tpeHorsService) { this.tpeHorsService = tpeHorsService; }
    public long getInterventionsCeMois() { return interventionsCeMois; }
    public void setInterventionsCeMois(long interventionsCeMois) { this.interventionsCeMois = interventionsCeMois; }
    public List<Map<String, Object>> getTpeLesPlusEnPanne() { return tpeLesPlusEnPanne; }
    public void setTpeLesPlusEnPanne(List<Map<String, Object>> tpeLesPlusEnPanne) { this.tpeLesPlusEnPanne = tpeLesPlusEnPanne; }
    public List<Map<String, Object>> getTypesPanneLesPlusFrequents() { return typesPanneLesPlusFrequents; }
    public void setTypesPanneLesPlusFrequents(List<Map<String, Object>> typesPanneLesPlusFrequents) { this.typesPanneLesPlusFrequents = typesPanneLesPlusFrequents; }
}