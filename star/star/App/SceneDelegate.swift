//
//  SceneDelegate.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-21.
//

import SwiftUI
import UIKit
import FamilyControls

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let familyControlsManager = FamilyControlsManager.shared
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentViewContainer()
            .environmentObject(familyControlsManager)
        
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        navigationController.setViewControllers([SpaceViewController()], animated: true)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    

}
