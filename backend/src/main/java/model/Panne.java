package com.chams.tpe_backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "panne")
public class Panne {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "tpe_id", nullable = false)
    private Tpe tpe;

    @ManyToOne
    @JoinColumn(name = "type_panne_id", nullable = false)
    private TypePanne typePanne;

    @ManyToOne
    @JoinColumn(name = "station_id", nullable = true)
    private Station station;

    private String description;

    @Column(nullable = false)
    private LocalDateTime datedeclaration = LocalDateTime.now();

    @Enumerated(EnumType.STRING)
    private StatutPanne statut = StatutPanne.DECLAREE;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Tpe getTpe() { return tpe; }
    public void setTpe(Tpe tpe) { this.tpe = tpe; }
    public TypePanne getTypePanne() { return typePanne; }
    public void setTypePanne(TypePanne typePanne) { this.typePanne = typePanne; }
    public Station getStation() { return station; }
    public void setStation(Station station) { this.station = station; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public LocalDateTime getDateDeclaration() { return datedeclaration; }
    public void setDateDeclaration(LocalDateTime dateDeclaration) { this.datedeclaration = dateDeclaration; }
    public StatutPanne getStatut() { return statut; }
    public void setStatut(StatutPanne statut) { this.statut = statut; }
}