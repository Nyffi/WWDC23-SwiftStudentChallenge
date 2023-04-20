//
//  Fairy.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 10/04/23.
//

import Foundation
import SpriteKit

class Fairy: SKNode, Enemy {
    var spawners: [BulletSpawner]
    var actionPhases: [SKAction]
    var health: Int
    var maxHealth: Int
    var canTakeDamage: Bool
    var canShoot: Bool
    var isActive: Bool
    var finalSpot: CGPoint
    
    var skillClass: FairyClass
    var sprite: SKSpriteNode
    var hitbox: SKPhysicsBody
    
    init(fairy: FairyClass, pos: CGPoint) {
        spawners = []
        actionPhases = []
        health = 0
        maxHealth = 0
        canTakeDamage = true
        canShoot = false
        isActive = false
        skillClass = fairy
        finalSpot = pos
        sprite = SKSpriteNode(color: .magenta, size: CGSize(width: 40, height: 40))
        
        hitbox = SKPhysicsBody(circleOfRadius: self.sprite.size.width * 0.5)
        hitbox.affectedByGravity = false
        hitbox.allowsRotation = false
        hitbox.isDynamic = false
        hitbox.categoryBitMask = Bitmasks.enemy.rawValue
        hitbox.contactTestBitMask = Bitmasks.pBullet.rawValue
        
        super.init()
        setMaxHealth(hp: skillClass == .light ? 20 : 60)
        addChild(sprite)
        self.physicsBody = hitbox        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMaxHealth(hp: Int) {
        self.health = hp
        self.maxHealth = hp
    }
    
    func activate() {
        self.canTakeDamage = true
    }
}

enum FairyClass {
    case light
    case heavy
}
