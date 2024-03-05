//
//  SDKAddediOSApp.swift
//  SDKAddediOS
//
//  Created by Dimuthu Lakshan on 2024-02-29.
//

import SwiftUI
import Flutter
import FlutterPluginRegistrant

class FlutterDependencies: ObservableObject {
    let flutterEngine = FlutterEngine(name: "nps_flutter_engine_name")
    init(){
        // Runs the default Dart entrypoint with a default Flutter route.
        flutterEngine.run()
        // Connects plugins with iOS platform code to this app.
        GeneratedPluginRegistrant.register(with: self.flutterEngine);
    }
}

@available(iOS 14.0, *)
@main
struct SDKAddediOSApp: App {
    var flutterDependencies = FlutterDependencies()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(flutterDependencies)
        }
    }
}
