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
    var lightFairyBulletSpawner: BulletSpawnerConfigs
    var heavyFairyBulletSpawner: BulletSpawnerConfigs
    
    var boss: Boss
    var bossSpawners: [[BulletSpawnerConfigs]] = []
    
    var enemyCounter = 0
    
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
        boss = Boss(health: 7500)
        bossSpawners.append([BulletSpawnerConfigs(texture: SKTexture(),
                                                  spriteSpin: .none,
                                                  ownerisPlayer: false,
                                                  patternArrays: 4,
                                                  bulletsPerArray: 20,
                                                  spreadBetweenArray: 90,
                                                  spreadWithinArray: 100,
                                                  startAngle: 0,
                                                  spinRate: 5,
                                                  spinModificator: 0.5,
                                                  invertSpin: true,
                                                  maxSpinRate: 20,
                                                  fireRate: 50,
                                                  objectWidth: 1,
                                                  objectHeight: 1,
                                                  bulletSpeed: 0.75,
                                                  bulletAcceleration: -0.01,
                                                  bulletCurve: 0.25,
                                                  bulletTTL: 20)])
        
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTextures(bulletAtlas: SKTextureAtlas) {
        lightFairyBulletSpawner.texture = bulletAtlas.textureNamed("bulletLight")
        heavyFairyBulletSpawner.texture = bulletAtlas.textureNamed("bulletHeavy")
        
        bossSpawners[0][0].texture = bulletAtlas.textureNamed("bulletLight")
    }
    
    func randomizeFireRate(config: inout BulletSpawnerConfigs, in between: ClosedRange<Int>) {
        let newRate = Int.random(in: between)
        config.fireRate = newRate
        print("new fireRate generated: \(newRate)")
    }
    
    func initializeEnemies() {
        var smooth: SKAction
        
        var auxX = -320
        var auxY = 180
        
        for i in 0..<3 {
            for j in 0..<9 {
                randomizeFireRate(config: &lightFairyBulletSpawner, in: 40...60)
                randomizeFireRate(config: &heavyFairyBulletSpawner, in: 140...160)
                
                let fairyLight = Fairy(fairy: .light, pos: CGPoint(x: auxX - 15, y: auxY))
                fairyLight.name = "enemy_fairyLight_\(i)_\(j)"
//                fairyLight.position = CGPoint(x: CGFloat.random(in: -450...450), y: 475)
                smooth = .move(to: fairyLight.finalSpot, duration: 2)
                smooth.timingMode = .easeOut
                fairyLight.setupNewSpawners(spawnerConfigs: [lightFairyBulletSpawner])
                fairyLight.setupNewActionPhase(actions: .sequence([.move(to: CGPoint(x: CGFloat.random(in: -450...450), y: 500), duration: 0),
                                                         smooth,
                                                         .wait(forDuration: 0.25),
                                                         .run { fairyLight.isActive = true }]))
                fairies.append(fairyLight)
                
                let fairyHeavy = Fairy(fairy: .heavy, pos: CGPoint(x: auxX + 15, y: auxY))
                fairyHeavy.name = "enemy_fairyHeavy_\(i)_\(j)"
//                fairyHeavy.position = CGPoint(x: CGFloat.random(in: -450...450), y: 475)
                smooth = .move(to: fairyHeavy.finalSpot, duration: 2)
                smooth.timingMode = .easeOut
                fairyHeavy.setupNewSpawners(spawnerConfigs: [heavyFairyBulletSpawner])
                fairyHeavy.setupNewActionPhase(actions: .sequence([.move(to: CGPoint(x: CGFloat.random(in: -450...450), y: 500), duration: 0),
                                                         smooth,
                                                         .wait(forDuration: 0.25),
                                                         .run { fairyHeavy.isActive = true }]))
                fairyHeavy.sprite.color = .black
                fairies.append(fairyHeavy)
                
                auxX += 80
            }
            auxX = -320
            auxY += 120
        }
        
        boss.position = CGPoint(x: -500, y: 500)
        smooth = .move(to: CGPoint(x: 0, y: (self.scene?.view?.frame.height ?? 960) / 4), duration: 1)
        smooth.timingMode = .easeOut
        boss.setupNewSpawners(spawnerConfigs: bossSpawners[0])
        boss.setupNewActionPhase(actions: .sequence([.run {
            self.boss.isActive = true
        },
                                                     smooth]))
        boss.setupNewActionPhase(actions: .sequence([.run {
            self.boss.activate()
            let randPos = CGPoint(x: CGFloat.random(in: -250...250), y: CGFloat.random(in: 50...350))
            self.boss.run(.move(to: randPos, duration: 2))
        },
                                                     .wait(forDuration: 5)]))
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
    
    func despawnEnemy() {
        deactivateSpawn()
        for fairy in fairies {
            let fairyLeave = SKAction.move(to: CGPoint(x: CGFloat.random(in: -450...450), y: 500), duration: 2)
            fairyLeave.timingMode = .easeOut
            
            fairy.canShoot = false
            fairy.run(fairyLeave) {
                fairy.isActive = false
                fairy.canTakeDamage = false
//                if fairy.parent != nil {
//                    fairy.removeFromParent()
//                }
            }
        }
    }
    
    func spawnBoss() {
        addChild(boss)
        boss.executePhase(progressThroughTheList: true)
    }
    
    func activateSpawn() {
        timerMain = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            self.spawnEnemy(quantity: Int.random(in: 10...20))
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
