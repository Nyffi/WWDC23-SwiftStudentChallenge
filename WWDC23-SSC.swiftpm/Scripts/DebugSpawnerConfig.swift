//
//  DebugSpawnerConfig.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 11/04/23.
//

import Foundation
import SpriteKit

class DebugSpawnerConfig {
    static let data = BulletSpawnerConfigs(texture: SKTexture(imageNamed: "bulletNew"),
                                           spriteSpin: .none,
                                           ownerisPlayer: false,
                                           patternArrays: 5,
                                           bulletsPerArray: 2,
                                           spreadBetweenArray: 70,
                                           spreadWithinArray: 25,
                                           startAngle: 0,
                                           spinRate: 0,
                                           spinModificator: 1.5,
                                           invertSpin: true,
                                           maxSpinRate: 20,
                                           fireRate: 3,
                                           objectWidth: 25,
                                           objectHeight: 25,
                                           bulletSpeed: 5,
                                           bulletAcceleration: 0,
                                           bulletCurve: 0,
                                           bulletTTL: 30)
}
