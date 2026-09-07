package com.chams.tpe_backend.repository;

import com.chams.tpe_backend.model.Panne;
import com.chams.tpe_backend.model.Station;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PanneRepository extends JpaRepository<Panne, Long> {
    List<Panne> findByStation(Station station);
}