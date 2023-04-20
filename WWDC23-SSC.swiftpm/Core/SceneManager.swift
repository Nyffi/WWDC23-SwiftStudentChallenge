//
//  SceneManager.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 19/04/23.
//

import Foundation
import SpriteKit

class SceneManager {
    enum AvailableScenes {
        case Menu
        case Level
    }
    
    public static func switchScenes(from source: SKScene?, to target: AvailableScenes) {
        guard let targetScene = getScene(target) else { return }
        
        targetScene.size = CGSize(width: 720, height: 960)
        targetScene.scaleMode = .fill
        
        source?.view?.presentScene(targetScene)
    }
    
    private static func getScene(_ scene: AvailableScenes) -> SKScene? {
        switch scene {
        case .Menu:
            return MainScene(fileNamed: "MainMenu")
        case .Level:
            return MainLevel(fileNamed: "LevelOne")
        }
    }
}
