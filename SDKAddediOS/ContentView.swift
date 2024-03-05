//
//  ContentView.swift
//  SDKAddediOS
//
//  Created by Dimuthu Lakshan on 2024-02-29.
//

import SwiftUI
import Flutter
import AVFoundation


struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}

extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
}


struct ContentView: View {
    @EnvironmentObject var flutterDependencies: FlutterDependencies
    @State var flutterMethodChannel : FlutterMethodChannel?
    @State var viewDidLoad = false
    
    let captureSession = AVCaptureSession()
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("Hello, world!")
            Spacer()
            Button("ClickSDK"){
                print("Clicked!")
                
                
                //                checkCameraPermission()
                showFlutter()
            }
            Spacer()
        }.onViewDidLoad {
            handleMethodChannel()
        }
    }
    
    func handleMethodChannel() {
        flutterMethodChannel = FlutterMethodChannel(name: "CHANNEL_100110", binaryMessenger: flutterDependencies.flutterEngine.binaryMessenger)
        flutterMethodChannel?.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch(call.method) {
            case "methodName":
                result("Successfully executed iOS MethoD @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!")
            case "sendArgsToNative":
                let user = call.arguments as! [String: Any]
                let arg1 = user["arg1"]
                let arg2 = user["arg2"]
                let arg3 = user["arg3"]
                print("Recived Data! : ")
                print(arg2 as Any)
                print(arg1 as Any)
                print(arg3 as Any)
                result("Received on iOS side!")
            default:
                print("Unrecognized method: \(call.method)")
            }
        })
        do {
            flutterMethodChannel?.invokeMethod("sendDataToFlutter", arguments: [
                "name":"Dimuthu",
                "age":12,
                "isEmployee":true
            ])
        } catch {
            print("ERRRROROROROOROROR$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        }
        
    }

    func showFlutter() {
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
            let window = windowScene.windows.first(where: \.isKeyWindow),
            let rootViewController = window.rootViewController
        else { return }
        
        let flutterViewController = FlutterViewController(
            engine: flutterDependencies.flutterEngine,
            nibName: nil,
            bundle: nil)
        flutterViewController.modalPresentationStyle = .overCurrentContext
        flutterViewController.isViewOpaque = false
        
        rootViewController.present(flutterViewController, animated: true)
    }
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Camera access is already granted, proceed with capture session setup
            setupCaptureSession(captureSession: captureSession)
        case .notDetermined:
            // Request permission
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                DispatchQueue.main.async {
                    if authorized {
                        self.setupCaptureSession(captureSession: captureSession)
                    } else {
                        // Handle permission denied case
                        print("Camera permission denied")
                    }
                }}
            
        case .restricted, .denied:
            // Camera access is restricted or denied, handle the case
            print("Camera access is denied")
        }
    }
    
    func setupCaptureSession(captureSession: AVCaptureSession) {
        showFlutter()
        // ... your code to configure the capture session ...
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
