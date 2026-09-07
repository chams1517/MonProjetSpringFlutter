package com.chams.tpe_backend.service;
import com.chams.tpe_backend.model.Tpe;
import com.chams.tpe_backend.repository.TpeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.chams.tpe_backend.model.Station;
import com.chams.tpe_backend.repository.StationRepository;
import java.util.List;

@Service
public class StationService {
    @Autowired
    private StationRepository stationRepository;

    public List<Station> getAllStations() {
        return stationRepository.findAll();
    }
    public Station getStationById(long id ){
        return stationRepository.findById(id).orElseThrow(() -> new RuntimeException("station introuvable avec l'id ! "));

    }
    public Station createStation(Station station) {
        return stationRepository.save(station);
    }

    public void deleteStation(Long id) {
        stationRepository.deleteById(id);
    }
}


