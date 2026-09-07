package com.chams.tpe_backend.controller;

import com.chams.tpe_backend.dto.DashboardStats;
import com.chams.tpe_backend.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    @GetMapping
    public DashboardStats getDashboard() {
        return dashboardService.getStats();
    }
}