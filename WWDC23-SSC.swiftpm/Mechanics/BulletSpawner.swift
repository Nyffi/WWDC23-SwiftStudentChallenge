//
//  BulletSpawner.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 09/04/23.
//

import Foundation
import SpriteKit

class BulletSpawner: SKNode {
    // Arrays
    var bulletArray: [Bullet] = []
    var patternArrays = 2
    var bulletsPerArray = 10
    
    // Angle Variables
    var spreadBetweenArray = 180
    var spreadWithinArray = 90
    var startAngle = 0
    var defaultAngle = 0
    
    // Spinning Variables
    var beginSpinSpeed = 0
    var spinRate = 0
    var spinModificator = 0
    var invertSpin = 1
    var maxSpinRate = 10
    
    // Fire Rate Variables
    var fireRate = 10
    var shoot = 0
    
    // Offsets
    var objectWidth = 0
    var objectHeight = 0
    var xOffset = 0.0
    var yOffset = 0.0
    
    // Bullet Variables
    var bulletSpeed = 3
    var bulletAcceleration = 0
    var bulletCurve = 0.2
    var bulletTTL: TimeInterval = 10 // Seconds
    
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
                    calculation(i: i, j: j, arrayAngle: arrayAngle, bulletAngle: bulletAngle)
                }
            }
            
            if defaultAngle > 360 { defaultAngle = 0}
            defaultAngle += spinRate
            spinRate += spinModificator
            
            if invertSpin == 1 {
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
        
        print(bulletArray.count)
    }
    
    // Calculate directions of spawning points
    
    func calculation(i: Int, j: Int, arrayAngle: Int, bulletAngle: Int) {
        var angleCalc = defaultAngle + (bulletAngle * i)
        angleCalc += (arrayAngle * j)
        angleCalc += startAngle
        
        let x1 = xOffset + self.lengthDirX(dist: objectWidth, angle: CGFloat(angleCalc))
        let y1 = yOffset + self.lengthDirY(dist: objectHeight, angle: CGFloat(angleCalc))
                
        let bullet = Bullet(sprite: SKSpriteNode(imageNamed: "bullet"), spawnX: CGFloat(x1), spawnY: CGFloat(y1), travelSpeed: bulletSpeed, acceleration: bulletAcceleration, direction: CGFloat(angleCalc), curve: bulletCurve, timeBeforeDespawn: bulletTTL)
        
        guard let scene = self.scene else { print("ERROR: Failed to find Scene."); return }
        bullet.spawn(scene: scene)
        
        bulletArray.append(bullet)
    }
    
    // Trigonometry functions
    
    func lengthDirX (dist: Int, angle: CGFloat) -> CGFloat {
        return CGFloat(dist) * cos((angle * .pi) / 180)
    }
    
    func lengthDirY (dist: Int, angle: CGFloat) -> CGFloat {
        return CGFloat(dist) * -sin((angle * .pi) / 180)
    }
    
    // Follow entity
    
    func updateSpawnerPosition(follow entity: SKNode) {
        self.xOffset = entity.position.x
        self.yOffset = entity.position.y
    }
}
