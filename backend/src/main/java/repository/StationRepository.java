package com.chams.tpe_backend.repository;
import com.chams.tpe_backend.model.Station;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
public interface StationRepository extends JpaRepository<Station, Long> {

}
