//
//  Self_BooksApp.swift
//  Self Books
//
//  Created by softwave on 21/07/23.
//

import SwiftUI
#if TARGET_OS_IOS
import UIKit
#endif
import BackgroundTasks

//Xcode non supporta più l'uso dell'AppDelegate automaticamente, prima c'erano delle opzioni all'init del progetto.
//Ora ci sono due strade,
// 1. UIApplicationDelegateAdaptor -> bisogna gestire MacOS, iOS ecc
// 2. usare l'init di App -> scelta consigliata

//Se si ha l'esigenza di gestire le push notification, bisogna usare l'approccio UIApplicationDelegateAdaptor
//

#if TARGET_OS_IOS
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}
#endif

@main
struct Self_BooksApp: App {
    
    @Environment(\.scenePhase) var scenePhase //-> si può fare ovunque
    
    init() {
        //FirebaseApp.configure()
    }
    
#if TARGET_OS_IOS
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    
    var body: some Scene {
        WindowGroup {
            Tab()
                .environmentObject(BooksModel(network: DefaultNetwork())) //Must be observable object!
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .background:
                print("Background")
                scheduleAppRefresh()
            case .active:
                print("Active")
            case .inactive:
                print("Inactive")
            @unknown default:
                break
            }
        }
#if TARGET_OS_IOS
        .backgroundTask(.appRefresh("myapprefresh")) {
        }
        .backgroundTask(.urlSession("myurlsession")) {
        // questo per il download in background
        }
#endif
    }
    
    func scheduleAppRefresh() {
        //codice di esempio per il task di background
        //let request = BGAppRefreshTaskRequest(identifier: "myapprefresh")
        //request.earliestBeginDate = .now.addingTimeInterval(24 * 3600)
        //try? BGTaskScheduler.shared.submit(request)
    }
}
