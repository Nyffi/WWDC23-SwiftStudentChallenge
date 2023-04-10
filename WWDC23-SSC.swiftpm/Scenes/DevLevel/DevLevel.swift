//
//  DevLevel.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 30/03/23.
//

import Foundation
import SpriteKit

class DevLevel: DevLevelDesign {
    let player = PlayableCharacter()
    
    let magic = SKSpriteNode(imageNamed: "magicCircle")
    
    let music = SKAudioNode(fileNamed: "tenshi.mp3")
    
    let spawner = BulletSpawner()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        player.isUserInteractionEnabled = true
        player.position.y = -self.frame.height / 4
        addChild(player)
        
        magic.size = CGSize(width: 200, height: 200)
        magic.alpha = 0.5
        magic.color = .red
        magic.colorBlendFactor = 1
        magic.run(.repeatForever(.sequence([.resize(toWidth: 0, duration: 5), .resize(toWidth: 200, duration: 5)])))
        magic.run(.repeatForever(.sequence([.rotate(byAngle: 10, duration: 10)])))
        addChild(magic)
        
        player.addChild(spawner)
        
//        magic.physicsBody = SKPhysicsBody(circleOfRadius: 50)
//        magic.physicsBody?.allowsRotation = false
//        magic.physicsBody?.affectedByGravity = false
//        magic.physicsBody?.applyForce(CGVector(dx: 0, dy: -25))
//        magic.physicsBody?.velocity = CGVector(dx: 3, dy: 0)
//        magic.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 0))
//        magic.run(.applyImpulse(CGVector(dx: 0, dy: -50), at: player.position, duration: 3))
//        magic.run(.applyImpulse(CGVector(dx: 0, dy: -50), duration: 3))
//        magic.run(.applyForce(CGVector(dx: 0, dy: -50), duration: 3))
//        magic.run(.playSoundFileNamed("magiccircle.wav", waitForCompletion: false))
    }
    
    override func sceneDidLoad() {
        addChild(music)
        music.autoplayLooped = true
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
        spawner.updateSpawnerPosition(follow: player)
        spawner.update()
    }
}
