//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 31.10.2025.
//

import AppMetricaCore

struct AnalyticsService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "58711e6c-7b9e-411f-bfb8-1033bbe59eac") else {
            return
        }
        AppMetrica.activate(with: configuration)
    }
    
    func report(event: String, params: [AnyHashable: Any]) {
        AppMetrica.reportEvent(name: event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
