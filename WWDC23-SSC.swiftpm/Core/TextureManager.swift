//
//  TextureManager.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 19/04/23.
//

import Foundation
import SpriteKit

class TextureManager {
    
    enum AvailableTextures {
        case Player
        case BulletLight
        case BulletHeavy
        case BulletDart
        case BulletStar
    }
    enum AvailableTextureSets {
        case LightFairy
        case HeavyFairy
        case Boss
    }
    
    static let shared = TextureManager()
    let enemyAtlas: SKTextureAtlas = SKTextureAtlas(named: "enemies")
    let bulletAtlas: SKTextureAtlas = SKTextureAtlas(named: "bulletVariants")
    let playerAtlas: SKTextureAtlas = SKTextureAtlas(named: "PlayableCharacter")
    
    public static func fetchTextures(for target: AvailableTextureSets) -> [SKTexture] {
        let names = fetchTextureNames(target)
        
        if target == .LightFairy || target == .HeavyFairy || target == .Boss {
            var textures: [SKTexture] = []
            
            for name in names {
                textures.append(TextureManager.shared.enemyAtlas.textureNamed(name))
            }
            
            SKTexture.preload(textures, withCompletionHandler: {})
            return textures
        }
        
        return []
    }
    
    public static func fetchTexture(for target: AvailableTextures) -> SKTexture {
        let name = fetchTextureName(target)
        var fetchedTexture: SKTexture
        
        switch target {
        case .Player:
            fetchedTexture = TextureManager.shared.playerAtlas.textureNamed(name)
        case .BulletLight, .BulletHeavy, .BulletDart, .BulletStar:
            fetchedTexture = TextureManager.shared.bulletAtlas.textureNamed(name)
        }
        
        return fetchedTexture
    }
    
    private static func fetchTextureName(_ texture: AvailableTextures) -> String {
        switch texture {
        case .Player:
            return TextureManager.shared.playerAtlas.textureNames[0]
        case .BulletLight:
            return TextureManager.shared.bulletAtlas.textureNames.filter({ $0.contains(["bulletLight"])})[0]
        case .BulletHeavy:
            return TextureManager.shared.bulletAtlas.textureNames.filter({ $0.contains(["bulletHeavy"])})[0]
        case .BulletDart:
            return TextureManager.shared.bulletAtlas.textureNames.filter({ $0.contains(["bulletDart"])})[0]
        case .BulletStar:
            return TextureManager.shared.bulletAtlas.textureNames.filter({ $0.contains(["bulletStar"])})[0]
        }
    }
    
    private static func fetchTextureNames(_ set: AvailableTextureSets) -> [String] {
        switch set {
        case .LightFairy:
            return TextureManager.shared.enemyAtlas.textureNames.filter({ $0.contains(["lightFairy"]) }).sorted()
        case .HeavyFairy:
            return TextureManager.shared.enemyAtlas.textureNames.filter({ $0.contains(["heavyFairy"]) }).sorted()
        case .Boss:
            return TextureManager.shared.enemyAtlas.textureNames.filter({ $0.contains(["Boss"])}).sorted()
        }
    }
}
