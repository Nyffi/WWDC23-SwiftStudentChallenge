//
//  DevLevel.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 30/03/23.
//

import Foundation
import SpriteKit

class DevLevel: DevLevelDesign, SKPhysicsContactDelegate {
    let player = PlayableCharacter()
    
    let magic = SKSpriteNode(imageNamed: "magicCircle")
    
    let music = SKAudioNode(fileNamed: "tenshi.mp3")
    
    let spawner = BulletSpawner(config: DebugSpawnerConfig.data)
    
    let script = LevelOneScript()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        physicsWorld.contactDelegate = self
        
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
        
        addChild(script)
    }
    
    override func sceneDidLoad() {
        addChild(music)
        music.autoplayLooped = true
        
        script.spawnEnemy(quantity: 1)
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
//        spawner.updateSpawnerPosition(follow: magic)
//        spawner.update()
        for enemy in script.fairies {
            if enemy.isActive && enemy.canShoot {
                for spawner in enemy.spawners {
                    spawner.value.updateSpawnerPosition(follow: enemy)
                    spawner.value.update()
                }
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
        if contact.bodyA.node?.name == "player" {
            print("dead")
        } else if contact.bodyB.node?.name == "player" {
            print("dead")
        }
        
        if contact.bodyA.node?.name == "playerGraze" {
            print("grazed")
        } else if contact.bodyB.node?.name == "playerGraze" {
            print("grazed")
        }
    }
}
