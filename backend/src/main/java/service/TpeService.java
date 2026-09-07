package com.chams.tpe_backend.service;

import com.chams.tpe_backend.model.Tpe;
import com.chams.tpe_backend.repository.TpeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TpeService {

    @Autowired
    private TpeRepository tpeRepository;

    public List<Tpe> getAllTpe() {
        return tpeRepository.findAll();
    }

    public Tpe getTpeById(Long id) {
        return tpeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("TPE introuvable avec l'id " + id));
    }

    public Tpe createTpe(Tpe tpe) {
        return tpeRepository.save(tpe);
    }
    public Tpe updateTpe(Tpe tpe) {
        return tpeRepository.save(tpe);
    }

    public void deleteTpe(Long id) {
        tpeRepository.deleteById(id);
    }
}