package com.chams.tpe_backend.model;
import jakarta.persistence.*;
import java.time.LocalDate;
@Entity
@Table(name="tpe")
public class Tpe {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id ;
    private LocalDate dateEntreeStock;
    @Column(unique = true,nullable = false)
    private String numeroSerie;
    private String modele ;
    private String marque ;
    @Enumerated(EnumType.STRING)
    private EtatTpe etat = EtatTpe.EN_STOCK ;
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNumeroSerie() {
        return numeroSerie;
    }

    public void setNumeroSerie(String numeroSerie) {
        this.numeroSerie = numeroSerie;
    }

    public String getModele() {
        return modele;
    }

    public void setModele(String modele) {
        this.modele = modele;
    }

    public String getMarque() {
        return marque;
    }

    public void setMarque(String marque) {
        this.marque = marque;
    }

    public EtatTpe getEtat() {
        return etat;
    }

    public void setEtat(EtatTpe etat) {
        this.etat = etat;
    }

    public LocalDate getDateEntreeStock() {
        return dateEntreeStock;
    }

    public void setDateEntreeStock(LocalDate dateEntreeStock) {
        this.dateEntreeStock = dateEntreeStock;
    }
}


