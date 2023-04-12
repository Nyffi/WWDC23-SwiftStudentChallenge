//
//  Fairy.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 10/04/23.
//

import Foundation
import SpriteKit

class Fairy: SKNode, Enemy {
    var spawners: [Int:BulletSpawner]
    var actionPhases: [[SKAction]]
    var health: Int
    var maxHealth: Int
    var canTakeDamage: Bool
    var canShoot: Bool
    var isActive: Bool
    var finalSpot: CGPoint
    
    var skillClass: FairyClass
    var sprite: SKSpriteNode
    
    init(fairy: FairyClass, pos: CGPoint) {
        spawners = [:]
        actionPhases = []
        health = 0
        maxHealth = 0
        canTakeDamage = true
        canShoot = false
        isActive = false
        skillClass = fairy
        finalSpot = pos
        sprite = SKSpriteNode(color: .magenta, size: CGSize(width: 25, height: 40))
        super.init()
        setMaxHealth(hp: skillClass == .light ? 20 : 60)
        addChild(sprite)
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
