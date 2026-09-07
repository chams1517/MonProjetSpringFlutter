package com.chams.tpe_backend.repository;

import com.chams.tpe_backend.model.TypePanne;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TypePanneRepository extends JpaRepository<TypePanne, Long> {

}