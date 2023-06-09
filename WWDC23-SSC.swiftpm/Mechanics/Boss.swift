//
//  Boss.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 31/03/23.
//

import Foundation
import SpriteKit

class Boss: SKNode, Enemy {
    var spawners: [BulletSpawner]
    var actionPhases: [SKAction]
    var health: Int
    var maxHealth: Int
    var canTakeDamage: Bool
    var canShoot: Bool
    var isActive: Bool
    
    var sprite: SKSpriteNode
    var magicCircleBG: SKSpriteNode
    var hitbox: SKPhysicsBody
    
    var nextPhaseAt: [Int]
    
    init(health: Int) {
        spawners = []
        actionPhases = []
        maxHealth = health
        self.health = health
        nextPhaseAt = []
        
        canTakeDamage = false
        canShoot = false
        isActive = false
        
        sprite = SKSpriteNode(color: .red, size: CGSize(width: 140, height: 125))
        hitbox = SKPhysicsBody(circleOfRadius: sprite.size.width * 0.75)
        hitbox.affectedByGravity = false
        hitbox.allowsRotation = false
        hitbox.isDynamic = false
        hitbox.categoryBitMask = Bitmasks.enemy.rawValue
        hitbox.contactTestBitMask = Bitmasks.pBullet.rawValue
        
        magicCircleBG = SKSpriteNode(imageNamed: "magicCircle")
        magicCircleBG.size = CGSize(width: 200, height: 200)
        magicCircleBG.alpha = 0.5
        magicCircleBG.color = .red
        magicCircleBG.colorBlendFactor = 1
        magicCircleBG.zPosition = -10
        magicCircleBG.run(.repeatForever(.sequence([.resize(toWidth: 100, duration: 5), .resize(toWidth: 200, duration: 5)])))
        magicCircleBG.run(.repeatForever(.sequence([.rotate(byAngle: 10, duration: 10)])))
        
        super.init()
        
        addChild(sprite)
        addChild(magicCircleBG)
        self.physicsBody = hitbox
        self.name = "enemy_boss"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func definePhases() {
        if actionPhases.isEmpty { return }
        
        let section = maxHealth / actionPhases.count
        var auxHealth = maxHealth
        
        while auxHealth > 0 {
            auxHealth -= section
            nextPhaseAt.append(auxHealth)
        }
    }
    
    func activate() {
        canTakeDamage = true
        canShoot = true
    }
    
    func deactivate() {
        canTakeDamage = false
        canShoot = false
    }
    
    private func phaseCooldown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.canTakeDamage = true
            self.canShoot = true
        }
    }
    
    private func phaseSpawnerUpdate(configs: [BulletSpawnerConfigs]) {
        if configs.count != spawners.count { print("[ERROR] Number of spawner configs does not match number of spawners, updating what's possible...")}
        
        for i in 0..<spawners.count {
            if i >= spawners.count || i >= configs.count { return }
            
            spawners[i].updateConfigData(config: configs[i])
        }
    }
    
    func initiateNewPhase(newBulletConfigs: [BulletSpawnerConfigs]) {
        canTakeDamage = false
        canShoot = false
        
        phaseSpawnerUpdate(configs: newBulletConfigs)
        phaseCooldown()
    }
    
}
