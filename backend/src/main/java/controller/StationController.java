package com.chams.tpe_backend.controller;

import com.chams.tpe_backend.model.Station;
import com.chams.tpe_backend.service.StationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stations")
public class StationController {
    @Autowired
    private StationService stationservice;

    @GetMapping
    public List<Station> getAllStation() {
        return stationservice.getAllStations();
    }

    @GetMapping("/{id}")
    public Station getStationById(@PathVariable long id) {
        return stationservice.getStationById(id);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public Station createStation(@RequestBody Station station) {
        return stationservice.createStation(station);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public void deleteStation(@PathVariable Long id) {
        stationservice.deleteStation(id);
    }
}