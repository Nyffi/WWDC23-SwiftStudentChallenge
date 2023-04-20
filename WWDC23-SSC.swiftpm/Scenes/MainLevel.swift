//
//  MainLevel.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 30/03/23.
//

import Foundation
import SpriteKit

class MainLevel: SKScene, SKPhysicsContactDelegate {
    let bulletAtlas = SKTextureAtlas(named: "bulletVariants")
    
    let player = PlayableCharacter()
        
    let music = SKAudioNode(fileNamed: "levelMusic.mp3")
    let bossMusic = SKAudioNode(fileNamed: "bossMusic.mp3")
    
    let script = LevelOneScript()
    
    var score = 0
    var topScore = 0
    var graze = 0
    
    var timeCounter = 0
    var fairyTimeLimit = 45  // 45
    var bossTimeLimit = 90   // 90
    var currentStep = -1 {   // -1 - Invalid | 0 - Common Enemies | 1 - Cooldown | 2 - Boss Fight | 3 - End
        didSet {
            if currentStep == 0 { setCounter(self.fairyTimeLimit); return }
            if currentStep == 1 { setCounter(8); script.despawnEnemy(); return }
            if currentStep == 2 { setCounter(self.bossTimeLimit); script.spawnBoss(); music.removeFromParent(); addChild(bossMusic); return }
            if currentStep == 3 { setCounter(10); script.despawnBoss(); return }
        }
    }
    let timerBG = SKShapeNode(circleOfRadius: 30)
    let timerLabel = SKLabelNode()
    
    let scoreBG = SKShapeNode(rectOf: CGSize(width: 200, height: 50))
    let scoreLabel = SKLabelNode()
    var gameTimer = Timer()

    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.view?.ignoresSiblingOrder = true
//        super.didMove(to: view)
        physicsWorld.contactDelegate = self
        
        timerBG.fillColor = .darkGray
        timerBG.strokeColor = .clear
        timerBG.zPosition = 100
        timerBG.position.y = self.size.height / 2.25
        timerLabel.fontName = "IM_FELL_DW_Pica_Roman_SC"
        timerLabel.fontSize = 32
        timerLabel.zPosition = 1
        timerLabel.verticalAlignmentMode = .center
        timerLabel.horizontalAlignmentMode = .center
        timerBG.addChild(timerLabel)
        timerLabel.position = CGPoint(x: 0, y: 0)
        
        
        scoreBG.fillColor = .darkGray
        scoreBG.strokeColor = .clear
        scoreBG.zPosition = 100
        scoreBG.position.x = -self.size.width / 3
        scoreBG.position.y = -self.size.height / 2.25
        scoreLabel.fontName = "IM_FELL_DW_Pica_Roman_SC"
        scoreLabel.fontSize = 32
        scoreLabel.zPosition = 1
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.horizontalAlignmentMode = .center
        scoreBG.addChild(scoreLabel)
        scoreLabel.position = CGPoint(x: 0, y: 0)
        scoreLabel.text = String(format: "%08d", self.score)
        
        let background = self.childNode(withName: "gameBG") as! SKSpriteNode
        background.run(.repeatForever(.sequence([.moveTo(y: -480, duration: 15),
                                                 .moveTo(y: 480, duration: 0)])))
        
        script.initializeEnemies()
        player.initalizeSpawners(bullets: bulletAtlas)
        
        player.isUserInteractionEnabled = true
        player.position.y = -self.frame.height / 4
        addChild(player)
        
        let moveToA = SKAction.moveTo(x: -250, duration: 2.25)
        moveToA.timingMode = .easeOut
        let moveToB = SKAction.moveTo(x: 250, duration: 2.25)
        moveToB.timingMode = .easeOut

        addChild(script)
    }
    
    override func sceneDidLoad() {
        addChild(music)
        addChild(timerBG)
        addChild(scoreBG)
        
        script.activateSpawn()
        self.currentStep = 0
    }
    
    func setCounter(_ time: Int) {
        if self.gameTimer.isValid { self.gameTimer.invalidate() }
        
        self.timeCounter = time
        if self.currentStep == 0 || self.currentStep == 2 {
            self.timerLabel.text = String.init(format: "%02d", self.timeCounter)
        }
        
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeCounter), userInfo: nil, repeats: true)
        self.timeCounter = time
    }
    
    @objc func updateTimeCounter() {
        if self.timeCounter > 0 {
            self.timeCounter -= 1
            if self.currentStep == 0 || self.currentStep == 2 {
                self.timerLabel.text = String.init(format: "%02d", self.timeCounter)
            }
        } else {
            self.gameTimer.invalidate()
            if self.currentStep == 3 { saveScore(); SceneManager.switchScenes(from: self, to: .Menu) } else {
                self.currentStep += 1
            }
        }
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
        DispatchQueue.main.async {
            for fairy in self.script.fairies {
                if fairy.isActive && fairy.canShoot {
                    for spawner in fairy.spawners {
                        spawner.updateSpawnerPosition(follow: fairy)
                        spawner.update()
                    }
                } else {
                    for spawner in fairy.spawners {
                        spawner.updateWhileAway()
                        if spawner.bulletArray.isEmpty && !fairy.hasActions() { fairy.removeFromParent() }
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            for spawner in self.player.spawners {
                spawner.updateSpawnerPosition(follow: self.player)
                spawner.update()
            }
        }
        
        DispatchQueue.main.async {
            if self.script.boss.isActive && self.script.boss.canShoot {
                for bossSpawner in self.script.boss.spawners {
                    bossSpawner.updateSpawnerPosition(follow: self.script.boss)
                    bossSpawner.update()
                }
            } else {
                for bossSpawner in self.script.boss.spawners {
                    bossSpawner.updateWhileAway()
                    if bossSpawner.bulletArray.isEmpty && !self.script.boss.hasActions() { self.script.boss.removeFromParent() }
                }
            }
            
        }
        
        DispatchQueue.main.async {
            self.scoreLabel.text = String(format: "%08d", self.score)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        DispatchQueue.main.async {
            if contact.bodyA.categoryBitMask == Bitmasks.player.rawValue ||
                contact.bodyB.categoryBitMask == Bitmasks.player.rawValue {
                self.score - 1500 <= 0 ? (self.score = 0) : (self.score -= 1500)
                self.player.gotHit()
            }
        }
        
        DispatchQueue.main.async {
            if contact.bodyA.categoryBitMask == Bitmasks.eBullet.rawValue {
                if contact.bodyB.categoryBitMask == Bitmasks.playerGraze.rawValue {
                    self.graze += 1
                    self.score += 10
                    self.run(.playSoundFileNamed("graze.mp3", waitForCompletion: false))
                    return
                }
            } else if contact.bodyB.categoryBitMask == Bitmasks.eBullet.rawValue {
                if contact.bodyA.categoryBitMask == Bitmasks.playerGraze.rawValue {
                    self.graze += 1
                    self.score += 10
                    self.run(.playSoundFileNamed("graze.mp3", waitForCompletion: false))
                    return
                }
            }
        }
        
        DispatchQueue.main.async {
            if contact.bodyA.categoryBitMask == Bitmasks.pBullet.rawValue {
                if let bullet = contact.bodyA.node as? Bullet {
                    bullet.despawn = true
                }
                
                if let fairy = contact.bodyB.node as? Fairy {
                    fairy.health -= 1
                    self.score += 10
                    if fairy.health <= 0 {
                        fairy.removeFromParent()
                        fairy.isActive = false
                        fairy.skillClass == .light ? (self.score += 100) : (self.score += 500)
                    }
                }
                
                if let boss = contact.bodyB.node as? Boss {
                    if boss.canTakeDamage {
                        boss.health -= 1
                        self.score += 25
                        boss.run(.playSoundFileNamed("hit.mp3", waitForCompletion: false))
                    }
                    
                }
                
                return
            } else if contact.bodyB.categoryBitMask == Bitmasks.pBullet.rawValue {
                if let bullet = contact.bodyA.node as? Bullet {
                    bullet.despawn = true
                }
                
                if let fairy = contact.bodyA.node as? Fairy {
                    fairy.health -= 1
                    self.score += 10
                    if fairy.health <= 0 {
                        fairy.removeFromParent()
                        fairy.isActive = false
                        fairy.skillClass == .light ? (self.score += 100) : (self.score += 500)
                    }
                    
                    return
                }
                
                if let boss = contact.bodyA.node as? Boss {
                    if boss.canTakeDamage {
                        boss.health -= 1
                        self.score += 25
                        boss.run(.playSoundFileNamed("hit.mp3", waitForCompletion: false))
                    }
                    
                    return
                }
                
                return
            }
        }
    }
    
    func saveScore() {
        let uD = UserDefaults.standard
        self.topScore = uD.integer(forKey: "highScore")
        
        uD.set(self.score, forKey: "currentAttemptScore")
        
        if self.topScore < self.score {
            uD.set(self.score, forKey: "highScore")
        }
        
        uD.set(true, forKey: "gameHasBeenPlayed")
    }
}
