//
//  BulletSpawnerConfigs.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 11/04/23.
//

import Foundation
import SpriteKit

struct BulletSpawnerConfigs {
    var texture: SKTexture
    let spriteSpin: SpriteSpin
    let ownerisPlayer: Bool
    
    let patternArrays: Int
    let bulletsPerArray: Int
    
    var spreadBetweenArray: Int
    var spreadWithinArray: Int
    let startAngle: CGFloat
    
    let spinRate: CGFloat
    var spinModificator: CGFloat
    let invertSpin: Bool
    let maxSpinRate: CGFloat
    
    var fireRate: Int
    
    let objectWidth: CGFloat
    let objectHeight: CGFloat
    
    var bulletSpeed: CGFloat
    var bulletAcceleration: CGFloat
    var bulletCurve: CGFloat
    var bulletTTL: TimeInterval
}

enum SpriteSpin {
    case none
    case clockwise
    case counterclockwise
}
