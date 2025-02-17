//
//  SceneDelegate.swift
//  star
//
//  Created by t0000-m0112 on 2025-01-21.
//

import UIKit
import FamilyControls

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?                   
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        navigationController.setViewControllers([AppLaunchViewController()], animated: true)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

