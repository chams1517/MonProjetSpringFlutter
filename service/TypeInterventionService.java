package com.chams.tpe_backend.service;

import com.chams.tpe_backend.model.TypeIntervention;
import com.chams.tpe_backend.repository.TypeInterventionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TypeInterventionService {

    @Autowired
    private TypeInterventionRepository typeInterventionRepository;

    public List<TypeIntervention> getAllTypeInterventions() {
        return typeInterventionRepository.findAll();
    }

    public TypeIntervention getTypeInterventionById(Long id) {
        return typeInterventionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Type d'intervention introuvable avec l'id " + id));
    }

    public TypeIntervention createTypeIntervention(TypeIntervention typeIntervention) {
        return typeInterventionRepository.save(typeIntervention);
    }

    public void deleteTypeIntervention(Long id) {
        typeInterventionRepository.deleteById(id);
    }
}