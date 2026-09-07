package com.chams.tpe_backend.repository;

import com.chams.tpe_backend.model.Affectation;
import com.chams.tpe_backend.model.Station;
import com.chams.tpe_backend.model.Tpe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AffectationRepository extends JpaRepository<Affectation, Long> {
    Optional<Affectation> findByTpeAndDateFinIsNull(Tpe tpe);
    List<Affectation> findByDateFinIsNull();
    List<Affectation> findByStationAndDateFinIsNull(Station station);
}