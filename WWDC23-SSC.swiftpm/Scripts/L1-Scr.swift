//
//  L1-Scr.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 11/04/23.
//

import Foundation
import SpriteKit

class LevelOneScript: SKNode {
    var fairies: [Fairy] = []
    var enemyCounter = 0
    var lightFairyBulletSpawner: BulletSpawnerConfigs
    var heavyFairyBulletSpawner: BulletSpawnerConfigs
    
    var timerMain = Timer()
        
    override init() {
        lightFairyBulletSpawner = BulletSpawnerConfigs(texture: SKTexture(),
                                                  spriteSpin: .none,
                                                  ownerisPlayer: false,
                                                  patternArrays: 1,
                                                  bulletsPerArray: 3,
                                                  spreadBetweenArray: 1,
                                                  spreadWithinArray: 20,
                                                  startAngle: 80,
                                                  spinRate: 0,
                                                  spinModificator: 1,
                                                  invertSpin: true,
                                                  maxSpinRate: 1,
                                                  fireRate: 50,
                                                  objectWidth: 25,
                                                  objectHeight: 1,
                                                  bulletSpeed: 3,
                                                  bulletAcceleration: 0,
                                                  bulletCurve: 0,
                                                  bulletTTL: 10)
        heavyFairyBulletSpawner = BulletSpawnerConfigs(texture: SKTexture(),
                                                  spriteSpin: .none,
                                                  ownerisPlayer: false,
                                                  patternArrays: 1,
                                                  bulletsPerArray: 3,
                                                  spreadBetweenArray: 1,
                                                  spreadWithinArray: 50,
                                                  startAngle: 62,
                                                  spinRate: 0,
                                                  spinModificator: 1,
                                                  invertSpin: true,
                                                  maxSpinRate: 1,
                                                  fireRate: 150,
                                                  objectWidth: 25,
                                                  objectHeight: 1,
                                                  bulletSpeed: 0.25, // 1.5
                                                  bulletAcceleration: 0.005,
                                                  bulletCurve: 0,
                                                  bulletTTL: 10)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTextures(bulletAtlas: SKTextureAtlas) {
        lightFairyBulletSpawner.texture = bulletAtlas.textureNamed("bulletLight")
        heavyFairyBulletSpawner.texture = bulletAtlas.textureNamed("bulletHeavy")
    }
    
    func randomizeFireRate(config: inout BulletSpawnerConfigs, in between: ClosedRange<Int>) {
        let newRate = Int.random(in: between)
        config.fireRate = newRate
        print("new fireRate generated: \(newRate)")
    }
    
    func initializeEnemies() {
        var auxX = -320
        var auxY = 160
        
        for i in 0..<3 {
            for j in 0..<9 {
                randomizeFireRate(config: &lightFairyBulletSpawner, in: 40...60)
                randomizeFireRate(config: &heavyFairyBulletSpawner, in: 140...160)
                
                let fairyLight = Fairy(fairy: .light, pos: CGPoint(x: auxX - 15, y: auxY))
                fairyLight.name = "enemy_fairyLight_\(i)_\(j)"
//                fairyLight.position = CGPoint(x: CGFloat.random(in: -450...450), y: 475)
                fairyLight.setupNewSpawners(spawnerConfigs: [lightFairyBulletSpawner])
                fairyLight.setupNewActionPhase(actions: [.move(to: CGPoint(x: CGFloat.random(in: -450...450), y: 475), duration: 0),
                                                         .move(to: fairyLight.finalSpot, duration: 2),
                                                         .wait(forDuration: 0.25),
                                                         .run { fairyLight.isActive = true }])
                fairies.append(fairyLight)
                
                let fairyHeavy = Fairy(fairy: .heavy, pos: CGPoint(x: auxX + 15, y: auxY))
                fairyHeavy.name = "enemy_fairyHeavy_\(i)_\(j)"
//                fairyHeavy.position = CGPoint(x: CGFloat.random(in: -450...450), y: 475)
                fairyHeavy.setupNewSpawners(spawnerConfigs: [heavyFairyBulletSpawner])

                fairyHeavy.setupNewActionPhase(actions: [.move(to: CGPoint(x: CGFloat.random(in: -450...450), y: 475), duration: 0),
                                                         .move(to: fairyHeavy.finalSpot, duration: 2),
                                                         .wait(forDuration: 0.25),
                                                         .run { fairyHeavy.isActive = true }])
                fairyHeavy.sprite.color = .black
                fairies.append(fairyHeavy)
                
                auxX += 80
            }
            auxX = -320
            auxY += 120
        }
    }
    
    func spawnEnemy(quantity: Int) {
        if quantity <= 0 { return }
        
        var unspawned: [Fairy] = []
        
        for _ in 0..<quantity {
            unspawned = fairies.filter({$0.isActive == false})
            guard let fairy = unspawned.randomElement() else { continue }
            
            fairy.canShoot = true
            if fairy.parent == nil {
                self.addChild(fairy)
            }
            fairy.executePhase(progressThroughTheList: false)
        }
    }
    
    func activateSpawn() {
        timerMain = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            self.spawnEnemy(quantity: Int.random(in: 1...4))
        }
        print("spawn has been enabled")
    }
    
    func deactivateSpawn() {
        timerMain.invalidate()
        print("spawn has been disabled")
    }
}

enum EnemyType {
    case fairyLight
    case fairyHeavy
    case random
}
