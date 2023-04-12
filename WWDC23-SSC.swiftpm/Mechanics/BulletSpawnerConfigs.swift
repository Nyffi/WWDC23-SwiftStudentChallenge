//
//  BulletSpawnerConfigs.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 11/04/23.
//

import Foundation
import SpriteKit

struct BulletSpawnerConfigs {
    let texture: SKTexture
    
    let patternArrays: Int
    let bulletsPerArray: Int
    
    let spreadBetweenArray: Int
    let spreadWithinArray: Int
    let startAngle: CGFloat
    
    let spinRate: CGFloat
    let spinModificator: CGFloat
    let invertSpin: Bool
    let maxSpinRate: CGFloat
    
    let fireRate: Int
    
    let objectWidth: CGFloat
    let objectHeight: CGFloat
    
    let bulletSpeed: CGFloat
    let bulletAcceleration: CGFloat
    let bulletCurve: CGFloat
    let bulletTTL: TimeInterval
}
