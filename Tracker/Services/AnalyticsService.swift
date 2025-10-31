//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Roman Yaschenkov on 31.10.2025.
//

import AppMetricaCore

struct AnalyticsService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "d99308e7-6754-4b7a-8f78-7f3d44aa4887") else {
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
