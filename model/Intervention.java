package com.chams.tpe_backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "intervention")
public class Intervention {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "panne_id", nullable = false)
    private Panne panne;

    @ManyToOne
    @JoinColumn(name = "type_intervention_id", nullable = false)
    private TypeIntervention typeIntervention;

    private String observations;

    @Column(nullable = false)
    private LocalDateTime dateIntervention = LocalDateTime.now();

    @Enumerated(EnumType.STRING)
    private ResultatIntervention resultat;

    // --- Getters et Setters ---

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Panne getPanne() {
        return panne;
    }

    public void setPanne(Panne panne) {
        this.panne = panne;
    }

    public TypeIntervention getTypeIntervention() {
        return typeIntervention;
    }

    public void setTypeIntervention(TypeIntervention typeIntervention) {
        this.typeIntervention = typeIntervention;
    }

    public String getObservations() {
        return observations;
    }

    public void setObservations(String observations) {
        this.observations = observations;
    }

    public LocalDateTime getDateIntervention() {
        return dateIntervention;
    }

    public void setDateIntervention(LocalDateTime dateIntervention) {
        this.dateIntervention = dateIntervention;
    }

    public ResultatIntervention getResultat() {
        return resultat;
    }

    public void setResultat(ResultatIntervention resultat) {
        this.resultat = resultat;
    }
}