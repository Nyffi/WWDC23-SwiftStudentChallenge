//
//  Bullet.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 31/03/23.
//

import Foundation
import SpriteKit

class Bullet: SKNode {
    var sprite: SKSpriteNode
    var hitbox: SKPhysicsBody
    
//    var spawnX: CGFloat
//    var spawnY: CGFloat
    var travelSpeed: CGFloat
    var direction: CGFloat
    var acceleration: CGFloat
    var curve: CGFloat
    var dirX: CGFloat
    var dirY: CGFloat
    var timeBeforeDespawn: TimeInterval
    
    var despawn: Bool
    
    init(sprite: SKSpriteNode, spawnX: CGFloat, spawnY: CGFloat, travelSpeed: CGFloat, acceleration: CGFloat, direction: CGFloat, curve: CGFloat, timeBeforeDespawn: TimeInterval) {
        self.sprite = sprite
        self.hitbox = SKPhysicsBody(circleOfRadius: sprite.size.width * 0.25)
        
        self.acceleration = acceleration
        self.direction = direction
        self.curve = curve
        self.travelSpeed = travelSpeed
        self.dirX = 0
        self.dirY = 0
        self.timeBeforeDespawn = timeBeforeDespawn
        self.despawn = false
        
        super.init()
        
        self.position.x = spawnX
        self.position.y = spawnY
        
        addChild(self.sprite)
        
        self.hitbox.affectedByGravity = false
        self.hitbox.allowsRotation = false
//        self.hitbox.isDynamic = false
        self.hitbox.collisionBitMask = 0
        self.sprite.physicsBody = self.hitbox
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawn(scene: SKScene) {
        scene.addChild(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.timeBeforeDespawn) {
            self.despawn = true
        }
    }
    
    func updatePos() {
        self.direction = self.direction + self.curve
        self.travelSpeed = self.travelSpeed + self.acceleration
        
        self.dirX = Bullet.xDir(angle: self.direction)
        self.dirY = Bullet.yDir(angle: self.direction)
        
        self.position.x = (self.position.x + self.dirX * self.travelSpeed)
        self.position.y = (self.position.y + self.dirY * self.travelSpeed)
        
        if self.position.x > 400 || self.position.x < -400 { self.despawn = true }
        if self.position.y > 500 || self.position.y < -500 { self.despawn = true }
    }
    
    static func xDir(angle: CGFloat) -> CGFloat {
        let radians = angle * .pi / 180
        return cos(radians)
    }
    
    static func yDir(angle: CGFloat) -> CGFloat {
        let radians = angle * .pi / 180
        return -sin(radians)
    }
}
