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
    
    let spawner = BulletSpawner(sprite: SKTexture(imageNamed: "bullet"))
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
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
        
        let moveToA = SKAction.moveTo(x: -250, duration: 1.25)
        moveToA.timingMode = .easeOut
        let moveToB = SKAction.moveTo(x: 250, duration: 1.25)
        moveToB.timingMode = .easeOut
        
        magic.run(.repeatForever(.sequence([moveToA, .wait(forDuration: 3), moveToB, .wait(forDuration: 3)])))
        
        player.addChild(spawner)
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
        spawner.updateSpawnerPosition(follow: magic)
        spawner.update()
    }
}
