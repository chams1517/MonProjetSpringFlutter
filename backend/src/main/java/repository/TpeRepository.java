package com.chams.tpe_backend.repository;

import com.chams.tpe_backend.model.EtatTpe;
import com.chams.tpe_backend.model.Tpe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TpeRepository extends JpaRepository<Tpe, Long> {
    long countByEtat(EtatTpe etat);

    @Query("SELECT a.tpe FROM Affectation a WHERE a.station.id = :stationId AND a.dateFin IS NULL")
    List<Tpe> findTpeActifsParStation(@Param("stationId") Long stationId);
}