//
//  Enemy.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 10/04/23.
//

import Foundation
import SpriteKit

protocol Enemy: SKNode, Scriptable {
    var spawners: [Int:BulletSpawner] { get set }   // All the spawners an enemy can have. Multiple spawners can be used for more complex patterns
    var actionPhases: [[SKAction]] { get set }  // Array containing scripts of all phases an enemy can have
    var health: Int { get set }                 // Current Health
    var maxHealth: Int { get set }              // Total Health
    var canTakeDamage: Bool { get set }         // If enabled, enemy can take and deal damage to player.
    var canShoot: Bool { get set }              // If enabled, activate the enemy's bullet spawners.
    var isActive: Bool { get set }              // If it's currently on screen or not
    var hitbox: SKPhysicsBody { get set }
    
    func setupNewSpawners(spawnerConfigs: [BulletSpawnerConfigs])
    func addNewSpawners(spawners: [BulletSpawner])
    func setupNewActionPhase(actions: [SKAction])
    func executePhase(progressThroughTheList: Bool)
}

extension Enemy where Self: SKNode {
    func setupNewSpawners(spawnerConfigs: [BulletSpawnerConfigs]) {
        var aux = 0
        for config in spawnerConfigs {
            let spawner = BulletSpawner(config: config)
            spawners[aux] = spawner
            addChild(spawner)
            aux += 1
        }
    }
    
    func addNewSpawners(spawners: [BulletSpawner]) {
        var aux = 0
        for spawner in spawners {
            self.spawners[aux] = spawner
            addChild(spawner)
            aux += 1
        }
    }
    
     func setupNewActionPhase(actions: [SKAction]) {
        actionPhases.append(actions)
    }
    
    func executePhase(progressThroughTheList: Bool) {
        if !actionPhases.isEmpty {
            let phase: [SKAction]
            
            if progressThroughTheList {
                phase = actionPhases.removeFirst()
            } else {
                phase = actionPhases[0]
            }
            
            self.run(.sequence(phase), withKey: "currentPhase")
        }
    }
}