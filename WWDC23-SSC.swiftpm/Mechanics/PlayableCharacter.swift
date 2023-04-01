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
    let hitbox: SKPhysicsBody = SKPhysicsBody(circleOfRadius: 7.5)
    let visualHitbox: SKShapeNode = SKShapeNode(circleOfRadius: 7.5)
    
    var isBeingControlled: Bool
    
    init() {
        self.isBeingControlled = false
        self.hitbox.isDynamic = false
        self.hitbox.allowsRotation = false
        self.hitbox.affectedByGravity = false
        
        super.init(texture: atlas.textureNamed("player1"), color: .blue, size: CGSize(width: 50, height: 50))
        
        self.name = "player"
        self.physicsBody = hitbox
        
        self.visualHitbox.fillColor = .red
        self.visualHitbox.strokeColor = .red
        self.visualHitbox.glowWidth = 1
        self.visualHitbox.zPosition = 1
        self.addChild(visualHitbox)
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
}
