//
//  PlayableCharacter.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 30/03/23.
//

import Foundation
import SpriteKit

class PlayableCharacter: SKSpriteNode {
    let atlas: SKTextureAtlas = SKTextureAtlas(named: "PlayableCharacter")
    let hitbox: SKPhysicsBody = SKPhysicsBody(circleOfRadius: 5)
    let visualHitbox: SKShapeNode = SKShapeNode(circleOfRadius: 5)
    let graze: SKNode = SKNode()
    let grazeHitbox: SKPhysicsBody = SKPhysicsBody(circleOfRadius: 25)
    
    var spawners: [BulletSpawner] = []
    
    var isBeingControlled: Bool
    
    init() {
        self.isBeingControlled = false
//        self.hitbox.isDynamic = false
        self.hitbox.allowsRotation = false
        self.hitbox.affectedByGravity = false
        self.hitbox.collisionBitMask = Bitmasks.nothing.rawValue
        self.hitbox.contactTestBitMask = Bitmasks.eBullet.rawValue | Bitmasks.enemy.rawValue
        self.hitbox.categoryBitMask = Bitmasks.player.rawValue
        
        super.init(texture: atlas.textureNamed("player1"), color: .blue, size: CGSize(width: 50, height: 50))
        
        self.name = "player"
        self.physicsBody = hitbox
        
        self.visualHitbox.fillColor = .red
        self.visualHitbox.strokeColor = .red
        self.visualHitbox.glowWidth = 1
        self.visualHitbox.zPosition = 1
        self.addChild(visualHitbox)
        
        self.graze.name = "playerGraze"
        self.addChild(self.graze)
        self.grazeHitbox.isDynamic = false
        self.grazeHitbox.allowsRotation = false
        self.grazeHitbox.affectedByGravity = false
        self.grazeHitbox.contactTestBitMask = Bitmasks.eBullet.rawValue
        self.grazeHitbox.categoryBitMask = Bitmasks.playerGraze.rawValue
        self.graze.physicsBody = self.grazeHitbox
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isBeingControlled = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first?.location(in: self.parent!), isBeingControlled {
            self.position = touch
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isBeingControlled = false
        makePlayerPosAccessible()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isBeingControlled = false
        makePlayerPosAccessible()
    }
    
    func makePlayerPosAccessible() {
        if self.position.y > 450 { self.run(.moveTo(y: 400, duration: 0.25))}
        if self.position.y < -450 { self.run(.moveTo(y: -400, duration: 0.25))}
        if self.position.x > 340 { self.run(.moveTo(x: 300, duration: 0.25))}
        if self.position.x < -340 { self.run(.moveTo(x: -300, duration: 0.25))}
    }
    
    func initalizeSpawners(bullets: SKTextureAtlas) {
        let mainSpawner = BulletSpawner(config: BulletSpawnerConfigs(texture: bullets.textureNamed("bulletDart"),
                                                                     spriteSpin: .none,
                                                                     ownerisPlayer: true,
                                                                     patternArrays: 1,
                                                                     bulletsPerArray: 3,
                                                                     spreadBetweenArray: 0,
                                                                     spreadWithinArray: 5,
                                                                     startAngle: 268,
                                                                     spinRate: 0,
                                                                     spinModificator: 0,
                                                                     invertSpin: true,
                                                                     maxSpinRate: 1,
                                                                     fireRate: 3,
                                                                     objectWidth: 25,
                                                                     objectHeight: 1,
                                                                     bulletSpeed: 25,
                                                                     bulletAcceleration: 0,
                                                                     bulletCurve: 0,
                                                                     bulletTTL: 5))

        
        let starSpawner = BulletSpawner(config: BulletSpawnerConfigs(texture: bullets.textureNamed("bulletStar"),
                                                                     spriteSpin: .clockwise,
                                                                     ownerisPlayer: true,
                                                                     patternArrays: 1,
                                                                     bulletsPerArray: 2,
                                                                     spreadBetweenArray: 0,
                                                                     spreadWithinArray: 10,
                                                                     startAngle: 265,
                                                                     spinRate: 0,
                                                                     spinModificator: 0,
                                                                     invertSpin: true,
                                                                     maxSpinRate: 1,
                                                                     fireRate: 3,
                                                                     objectWidth: 100,
                                                                     objectHeight: 1,
                                                                     bulletSpeed: 25,
                                                                     bulletAcceleration: 0,
                                                                     bulletCurve: 0,
                                                                     bulletTTL: 5))
        self.spawners.append(mainSpawner)
        self.addChild(mainSpawner)
        self.spawners.append(starSpawner)
        self.addChild(starSpawner)
    }
}
