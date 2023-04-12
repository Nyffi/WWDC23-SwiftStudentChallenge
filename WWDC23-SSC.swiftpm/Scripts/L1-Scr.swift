//
//  L1-Scr.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 11/04/23.
//

import Foundation
import SpriteKit

class LevelOneScript: SKNode {
    var fairies: [Fairy] = []
    var enemyCounter = 0
    let fairyBulletSpawner: BulletSpawnerConfigs
    
//    var spawnPoints: [SKNode] = []
//    var spawnMatrix: [[Character]] = [["O", "O", "O", "O", "O", "O", "O"],  // Shows where an enemy can spawn
//                                      ["O", "O", "O", "O", "O", "O", "O"],  // O = Vacant
//                                      ["O", "O", "O", "O", "O", "O", "O"]]  // X = Occupied
//    var spawnMatrix = [[(14,"O"), (15,"O"), (16,"O"), (17,"O"), (18,"O"), (19,"O"), (20,"O")],
//                       [(7,"O"), (8,"O"), (9,"O"), (10,"O"), (11,"O"), (12,"O"), (13,"O")],
//                       [(0,"O"), (1,"O"), (2,"O"), (3,"O"), (4,"O"), (5,"O"), (6,"O")]]
//    var selectedSpawnPoint: CGPoint = CGPoint(x: -1, y: -1)
        
    override init() {
        fairyBulletSpawner = BulletSpawnerConfigs(texture: SKTexture(imageNamed: "bulletNew"),
                                                  patternArrays: 1,
                                                  bulletsPerArray: 3,
                                                  spreadBetweenArray: 1,
                                                  spreadWithinArray: 20,
                                                  startAngle: 80,
                                                  spinRate: 0,
                                                  spinModificator: 1,
                                                  invertSpin: true,
                                                  maxSpinRate: 1,
                                                  fireRate: 25,
                                                  objectWidth: 25,
                                                  objectHeight: 1,
                                                  bulletSpeed: 3,
                                                  bulletAcceleration: 0,
                                                  bulletCurve: 0,
                                                  bulletTTL: 10)
        
        super.init()
        
        var auxX = -320
        var auxY = 160
        
        for i in 0..<3 {
            for j in 0..<9 {
                let fairyLight = Fairy(fairy: .light, pos: CGPoint(x: auxX - 15, y: auxY))
                fairyLight.name = "fairyLight_\(i)_\(j)"
                fairyLight.position = CGPoint(x: CGFloat.random(in: -450...450), y: 475)
                fairyLight.setupNewSpawners(spawnerConfigs: [fairyBulletSpawner])
                fairyLight.setupNewActionPhase(actions: [.move(to: fairyLight.finalSpot, duration: 2),
                                                         .wait(forDuration: 0.25),
                                                         .run { fairyLight.canShoot = true }])
                fairies.append(fairyLight)
                
                let fairyHeavy = Fairy(fairy: .heavy, pos: CGPoint(x: auxX + 15, y: auxY))
                fairyHeavy.name = "fairyHeavy_\(i)_\(j)"
                fairyHeavy.position = CGPoint(x: CGFloat.random(in: -450...450), y: 475)
                fairyHeavy.setupNewSpawners(spawnerConfigs: [fairyBulletSpawner])

                fairyHeavy.setupNewActionPhase(actions: [.move(to: fairyHeavy.finalSpot, duration: 2),
                                                         .wait(forDuration: 0.25),
                                                         .run { fairyHeavy.canShoot = true }])
                fairyHeavy.sprite.color = .black
                fairies.append(fairyHeavy)
                
                auxX += 80
            }
            auxX = -320
            auxY += 120
        }
        
//        spawnPoints.append(contentsOf: (self.parent?.children.filter({$0.name?.contains(["spawn"]) == true})))
//        spawnPoints.sort(by: { $0.name! < $1.name! })
        
//        for i in 0...20 {
//
//            spawn
//            let fairyLight = Fairy(fairy: .light)
//            fairyLight.addNewSpawners(spawners: [fairyBulletSpawner])
//            fairyLight.position = CGPoint(x: CGFloat.random(in: -450...450), y: 475)
//            fairyLight.setupNewActionPhase(actions: [.run { fairyLight.canShoot = true }])
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawnEnemy(quantity: Int) {
        if quantity <= 0 { return }
        
        var unspawned: [Fairy] = []
        
        for _ in 0..<quantity {
            unspawned = fairies.filter({$0.isActive == false})
            guard let fairy = unspawned.randomElement() else { continue }
            
            fairy.isActive = true
            self.addChild(fairy)
            fairy.executePhase()
        }
    }
}

enum EnemyType {
    case fairyLight
    case fairyHeavy
    case random
}
