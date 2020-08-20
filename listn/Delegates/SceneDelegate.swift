//
//  SceneDelegate.swift
//  listn
//
//  Created by Pierre Rodgers on 22/7/20.
//  Copyright © 2020 Pierre Rodgers. All rights reserved.
//

import UIKit
import SwiftUI
import RealmSwift


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        /*let app = ListnApp()
        let loginService = MongoLoginService(app:app.realmApp)
        let loginModel = LoginViewModel(loginService: loginService)
        let contentView = LoginView(viewModel: loginModel)*/
        
        
        /*
        let realm = try! Realm(configuration: app.currentUser()!.configuration(partitionValue:(app.currentUser()?.identity)!))*/
        UINavigationBar.appearance().tintColor = UIColor.label
        let _ = ListnApp() { isLoggedIn, app in
            if isLoggedIn {
                DispatchQueue.main.async {
                    let window = UIWindow(windowScene: scene as! UIWindowScene)
                    let view = AppView(app:app)
                    window.rootViewController = UIHostingController(rootView:view)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            }
            else {
                DispatchQueue.main.async {
                    let window = UIWindow(windowScene: scene as! UIWindowScene)
                    let view = LoginView(viewModel: LoginViewModel(loginService: app.loginService))
                    window.rootViewController = UIHostingController(rootView:view)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            }
            
            
        }
        /*let feedModel = FeedModel(app: app.appData!)
        let contentView = FeedView(model: feedModel)*/
        /*
        let searchModel = TestSearchViewModel(appData: app.appData!)
        let contentView = TestSearchView(model: searchModel)*/
        let contentView = ContentView()
        

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

