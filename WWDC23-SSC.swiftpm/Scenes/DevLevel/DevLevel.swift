//
//  DevLevel.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 30/03/23.
//

import Foundation
import SpriteKit

class DevLevel: DevLevelDesign, SKPhysicsContactDelegate {
    let bulletAtlas = SKTextureAtlas(named: "bulletVariants")
    
    let player = PlayableCharacter()
    
    let magic = SKSpriteNode(imageNamed: "magicCircle")
    
    let music = SKAudioNode(fileNamed: "tenshi.mp3")
    
    let spawner = BulletSpawner(config: DebugSpawnerConfig.data)
    
    let script = LevelOneScript()
    
    var score = 0
    var topScore = 0
    var graze = 0
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.contactDelegate = self
        
        script.updateTextures(bulletAtlas: bulletAtlas)
        script.initializeEnemies()
        player.initalizeSpawners(bullets: bulletAtlas)
        
        player.isUserInteractionEnabled = true
        player.position.y = -self.frame.height / 4
        addChild(player)
        
        magic.position.y = 350
        magic.size = CGSize(width: 200, height: 200)
        magic.alpha = 0.5
        magic.color = .red
        magic.colorBlendFactor = 1
        magic.run(.repeatForever(.sequence([.resize(toWidth: 0, duration: 5), .resize(toWidth: 200, duration: 5)])))
        magic.run(.repeatForever(.sequence([.rotate(byAngle: 10, duration: 10)])))
        addChild(magic)
        
        let moveToA = SKAction.moveTo(x: -250, duration: 2.25)
        moveToA.timingMode = .easeOut
        let moveToB = SKAction.moveTo(x: 250, duration: 2.25)
        moveToB.timingMode = .easeOut
        
//        magic.run(.repeatForever(.sequence([moveToA,
//                                            .wait(forDuration: 3),
//                                            .run { self.script.spawnEnemy(type: .fairyLight) },
//                                            moveToB,
//                                            .wait(forDuration: 3),
//                                            .run { self.script.spawnEnemy(type: .fairyLight) }])))
        player.addChild(spawner)
        
//        guard let gameScene = self else { print("SCENE WAS NOT ACHIEVABLE"); return }
//        script.gameScene = self
//        script.initializeEnemies()
        addChild(script)
    }
    
    override func sceneDidLoad() {
        addChild(music)
        music.autoplayLooped = true
        
        script.activateSpawn()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.script.deactivateSpawn()
//        }
//        script.spawnEnemy(quantity: 1)
//        self.spawnerTestSetup()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first?.location(in: self)
        
        if player.isBeingControlled {
            player.position = touch ?? CGPoint(x: 0, y: 0)
        }
        
    }
    
    func touchDown(atPoint pos: CGPoint) {
        print(pos)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        print("Score: \(score)")
        print("Graze: \(graze)")
//        spawner.updateSpawnerPosition(follow: magic)
//        spawner.update()
        
        DispatchQueue.main.async {
            for enemy in self.script.fairies {
                if enemy.isActive && enemy.canShoot {
                    for spawner in enemy.spawners {
                        spawner.value.updateSpawnerPosition(follow: enemy)
                        spawner.value.update()
                    }
                } else {
                    for spawner in enemy.spawners {
                        spawner.value.updateWhileAway()
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            for spawner in self.player.spawners {
                spawner.updateSpawnerPosition(follow: self.player)
                spawner.update()
            }
        }
    }
    
    func spawnerTestSetup() {
        spawner.alterBulletPattern(array: 5, bulletsPerArray: 2)
        spawner.alterSpreadBetweenArrays(spread: 70)
        spawner.alterSpreadWithinArrays(spread: 20)
        spawner.alterMaxSpin(max: 20)
        spawner.alterSpin(rate: 0, modif: 1.5)
        spawner.alterFireRate(rate: 3)
        spawner.alterBulletSpeed(speed: 1.5)
        spawner.alterBulletCurve(curve: 0)
        spawner.alterBulletTTL(ttl: 10)
//        spawner.bulletAcceleration = -0.1
        spawner.objectWidth = 25
        spawner.objectHeight = 25
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //        if contact.bodyA.node?.name == "player" {
        //            print("dead")
        //        } else if contact.bodyB.node?.name == "player" {
        //            print("dead")
        //        }
        //
        //        if contact.bodyA.node?.name == "playerGraze" {
        //            print("grazed")
        //        } else if contact.bodyB.node?.name == "playerGraze" {
        //            print("grazed")
        //        }
        
//        print("\nbodyA: \(contact.bodyA.node?.name)\nbodyB: \(contact.bodyB.node?.name)")
        
//        if contact.bodyA.node?.name == "pBullet" || contact.bodyB.node?.name == "pBullet" {
//            print("testing\nbodyA: \(contact.bodyA.node?.name)\nbodyB: \(contact.bodyB.node?.name)")
//        }
        
//        if (contact.bodyA.node?.name == "eBullet" && contact.bodyB.node?.name == "player") ||
//            (contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "eBullet") ||
//            (contact.bodyA.node?.name == "enemy" && contact.bodyB.node?.name == "player") ||
//            (contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "enemy"){
//            print("dead")
//        }
//
//        if (contact.bodyA.node?.name == "eBullet" && contact.bodyB.node?.name == "playerGraze") ||
//            (contact.bodyA.node?.name == "playerGraze" && contact.bodyB.node?.name == "eBullet") {
//            print("grazed")
//        }
//
//        if (contact.bodyA.categoryBitMask == Bitmasks.pBullet.rawValue
//            && contact.bodyB.categoryBitMask == Bitmasks.enemy.rawValue) ||
//            (contact.bodyA.categoryBitMask == Bitmasks.enemy.rawValue
//             && contact.bodyB.categoryBitMask == Bitmasks.pBullet.rawValue) {
//            print("hit an enemy")
//        }
        
        DispatchQueue.main.async {
            if contact.bodyA.categoryBitMask == Bitmasks.eBullet.rawValue {
                if contact.bodyB.categoryBitMask == Bitmasks.playerGraze.rawValue {
                    self.graze += 1
                    self.score += 10
                    
                    return
                }
            } else if contact.bodyB.categoryBitMask == Bitmasks.eBullet.rawValue {
                if contact.bodyA.categoryBitMask == Bitmasks.playerGraze.rawValue {
                    self.graze += 1
                    self.score += 10
                    
                    return
                }
            }
        }
        
        DispatchQueue.main.async {
            if contact.bodyA.categoryBitMask == Bitmasks.pBullet.rawValue {
                if let bullet = contact.bodyA.node as? Bullet {
                    bullet.despawn = true
                }
                
                if let fairy = contact.bodyB.node as? Fairy {
                    fairy.health -= 1
                    self.score += 10
                    if fairy.health <= 0 {
                        fairy.removeFromParent()
                        fairy.isActive = false
                        fairy.skillClass == .light ? (self.score += 100) : (self.score += 500)
                    }
                }
                
                return
            } else if contact.bodyB.categoryBitMask == Bitmasks.pBullet.rawValue {
                if let bullet = contact.bodyA.node as? Bullet {
                    bullet.despawn = true
                }
                
                if let fairy = contact.bodyA.node as? Fairy {
                    fairy.health -= 1
                    self.score += 10
                    if fairy.health <= 0 {
                        fairy.removeFromParent()
                        fairy.isActive = false
                        fairy.skillClass == .light ? (self.score += 100) : (self.score += 500)
                    }
                }
                
                return
            }
        }
        
        
    }
}
