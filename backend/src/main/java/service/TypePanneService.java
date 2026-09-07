package com.chams.tpe_backend.service;

import com.chams.tpe_backend.model.TypePanne;
import com.chams.tpe_backend.repository.TypePanneRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TypePanneService {

    @Autowired
    private TypePanneRepository typePanneRepository;

    public List<TypePanne> getAllTypePannes() {
        return typePanneRepository.findAll();
    }

    public TypePanne getTypePanneById(Long id) {
        return typePanneRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Type de panne introuvable avec l'id " + id));
    }

    public TypePanne createTypePanne(TypePanne typePanne) {
        return typePanneRepository.save(typePanne);
    }

    public void deleteTypePanne(Long id) {
        typePanneRepository.deleteById(id);
    }
}