//
//  GameRules.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 11/04/23.
//

import Foundation
import SpriteKit

class GameRules: SKScene, SKPhysicsContactDelegate {
    let player = PlayableCharacter()
    var enemies: [Enemy] = []
    let boss = Boss()
    var bgM = SKAudioNode()
    
    let bulletAtlas = SKTextureAtlas(named: "bulletVariants")
    
    var score = 0
    var topScore = 0
    var graze = 0
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        player.initalizeSpawners(bullets: bulletAtlas)
        player.position.y = -self.frame.height - 50
        player.run(.moveTo(y: (-self.frame.height / 4), duration: 2), completion: { self.player.isUserInteractionEnabled = true
        })
    }
}
