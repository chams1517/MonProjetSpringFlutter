package com.chams.tpe_backend.repository;

import com.chams.tpe_backend.model.TypeIntervention;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TypeInterventionRepository extends JpaRepository<TypeIntervention, Long> {

}