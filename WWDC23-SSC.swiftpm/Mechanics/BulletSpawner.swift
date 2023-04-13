//
//  BulletSpawner.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 09/04/23.
//

import Foundation
import SpriteKit

class BulletSpawner: SKNode, Scriptable {
    let texture: SKTexture
    var spriteSpin: SKAction?
    let ownerisPlayer: Bool
    
    // Arrays
    var bulletArray: [Bullet] = []  // All bullets spawned and still alive
    var patternArrays = 1           // Total bullet arrays
    var bulletsPerArray = 1         // How many bullets each array will shoot
    
    // Angle Variables
    var spreadBetweenArray = 300    // Spread between Arrays
    var spreadWithinArray = 90      // Bullet spread in an Array
    var startAngle = 0.0            // Starting angle (➡️ 0 | ⬇️ 90 | ⬅️ 180 | ⬆️ 270)
    var defaultAngle = 0.0
    
    // Spinning Variables
    var spinRate = 0.0              // Rate at which the pattern spins
    var spinModificator = 0.0       // Spin modifier
    var invertSpin = true           // If true, spinRate gets inverted when it goes over maxSpinRate
    var maxSpinRate = 10.0          // Complementary to invertSpin; if spinRate >= maxSpinRate then invert spin
    
    // Fire Rate Variables
    var fireRate = 5                // How fast the spawner shoots bullets; Higher is slower
    var shoot = 0                   // Auxiliary variable
    
    // Offsets
    var objectWidth = 0.0           // Width of the bullet firing object
    var objectHeight = 0.0          // Height of the bullet firing object
    var xOffset = 0.0               // Shift spawn point of the bullets along the X-Axis
    var yOffset = 0.0               // Shift spawn point of the bullets along the Y-Axis
    
    // Bullet Variables
    var bulletSpeed = 3.0
    var bulletAcceleration = 0.0
    var bulletCurve = 0.0
    var bulletTTL: TimeInterval = 10 // How long the bullet will live, in seconds, before despawning
    
    init(config: BulletSpawnerConfigs) {
        self.texture = config.texture
        self.ownerisPlayer = config.ownerisPlayer
        super.init()
        self.updateConfigData(config: config)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateConfigData(config: BulletSpawnerConfigs) {
        switch config.spriteSpin {
        case .none:
            self.spriteSpin = nil
        case .clockwise:
            self.spriteSpin = .repeatForever(.rotate(byAngle: 360, duration: 0.25))
        case .counterclockwise:
            self.spriteSpin = .repeatForever(.rotate(byAngle: -360, duration: 0.25))
        }
        
//        super.init()
        self.patternArrays = config.patternArrays
        self.bulletsPerArray = config.bulletsPerArray
        self.spreadBetweenArray = config.spreadBetweenArray
        self.spreadWithinArray = config.spreadWithinArray
        self.startAngle = config.startAngle
        self.spinRate = config.spinRate
        self.spinModificator = config.spinModificator
        self.invertSpin = config.invertSpin
        self.maxSpinRate = config.maxSpinRate
        self.fireRate = config.fireRate
        self.objectWidth = config.objectWidth
        self.objectHeight = config.objectHeight
        self.bulletSpeed = config.bulletSpeed
        self.bulletAcceleration = config.bulletAcceleration
        self.bulletCurve = config.bulletCurve
        self.bulletTTL = config.bulletTTL
    }
    
    func update() {
        var bulletLength = bulletsPerArray - 1
        if bulletLength == 0 { bulletLength = 1 }
        
        var arrayLength = patternArrays - 1 * patternArrays
        if arrayLength == 0 { arrayLength = 1 }
        
        let arrayAngle = (spreadWithinArray / bulletLength)
        let bulletAngle = (spreadBetweenArray / arrayLength)
        
        if shoot == 0 {
            for i in 0..<patternArrays {
                for j in 0..<bulletsPerArray {
                    calculation(i: i, j: j, arrayAngle: CGFloat(arrayAngle), bulletAngle: CGFloat(bulletAngle))
                }
            }
            
            if defaultAngle > 360 { defaultAngle = 0 }
            defaultAngle += spinRate
            spinRate += spinModificator
            
            if invertSpin {
                if spinRate < -maxSpinRate || spinRate > maxSpinRate {
                    spinModificator = -spinModificator
                }
            }
        }
        
        for bullet in bulletArray {
            if bullet.despawn {
                bullet.removeFromParent()
                guard let index = bulletArray.firstIndex(of: bullet) else { continue }
                bulletArray.remove(at: index)
            }
            
            bullet.updatePos()
        }
        
        shoot += 1
        if shoot >= fireRate {
            shoot = 0
        }
        
//        print(bulletArray.count)
    }
    
    func updateWhileAway() {
        for bullet in bulletArray {
            if bullet.despawn {
                bullet.removeFromParent()
                guard let index = bulletArray.firstIndex(of: bullet) else { continue }
                bulletArray.remove(at: index)
            }
            
            bullet.updatePos()
        }
    }
    
    // Calculate directions of spawning points
    
    func calculation(i: Int, j: Int, arrayAngle: CGFloat, bulletAngle: CGFloat) {
        var angleCalc = defaultAngle + (bulletAngle * CGFloat(i))
        angleCalc += (arrayAngle * CGFloat(j))
        angleCalc += startAngle
        
        let x1 = xOffset + self.lengthDirX(dist: objectWidth, angle: angleCalc)
        let y1 = yOffset + self.lengthDirY(dist: objectHeight, angle: angleCalc)
                
        let bullet = Bullet(sprite: SKSpriteNode(texture: self.texture), spawnX: x1, spawnY: y1, travelSpeed: bulletSpeed, acceleration: bulletAcceleration, direction: angleCalc, curve: bulletCurve, timeBeforeDespawn: bulletTTL)
        if let spin = self.spriteSpin {
            bullet.run(spin)
        }
        
        if ownerisPlayer {
            bullet.name = "pBullet"
            bullet.hitbox.categoryBitMask = Bitmasks.pBullet.rawValue
            bullet.hitbox.contactTestBitMask = Bitmasks.enemy.rawValue
            
        } else {
            bullet.name = "eBullet"
            bullet.hitbox.categoryBitMask = Bitmasks.eBullet.rawValue
            bullet.hitbox.contactTestBitMask = Bitmasks.player.rawValue
        }
        
        guard let scene = self.scene else { print("ERROR: Failed to find Scene."); return }
        bullet.spawn(scene: scene)
        
        bulletArray.append(bullet)
    }
    
    // Trigonometry functions
    
    func lengthDirX (dist: CGFloat, angle: CGFloat) -> CGFloat {
        return dist * cos((angle * .pi) / 180)
    }
    
    func lengthDirY (dist: CGFloat, angle: CGFloat) -> CGFloat {
        return dist * -sin((angle * .pi) / 180)
    }
    
    // Follow entity
    
    func updateSpawnerPosition(follow entity: SKNode) {
        self.xOffset = entity.position.x
        self.yOffset = entity.position.y
    }
}
