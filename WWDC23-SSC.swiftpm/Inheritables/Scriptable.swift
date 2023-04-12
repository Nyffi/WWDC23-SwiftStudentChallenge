//
//  Scriptable.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 10/04/23.
//

import Foundation
import SpriteKit

protocol Scriptable {
    
}

extension Scriptable where Self: BulletSpawner {
    func alterSpin(rate: CGFloat, modif: CGFloat) {
        self.spinRate = rate
        self.spinModificator = modif
    }
    
    func alterMaxSpin(max: CGFloat) {
        self.maxSpinRate = max
    }
    
    func alterBulletPattern(array: Int, bulletsPerArray: Int) {
        self.patternArrays = array
        self.bulletsPerArray = bulletsPerArray
    }
    
    func alterFireRate(rate: Int) {
        self.fireRate = rate
    }
    
    func alterBulletSpeed(speed: CGFloat) {
        self.bulletSpeed = speed
    }
    
    func alterBulletCurve(curve: CGFloat) {
        self.bulletCurve = curve
    }
    
    func alterBulletTTL(ttl: TimeInterval) {
        self.bulletTTL = ttl
    }
    
    func toggleSpinInvert() {
        self.invertSpin.toggle()
    }
    
    func alterSpreadBetweenArrays(spread: Int) {
        self.spreadBetweenArray = spread
    }
    
    func alterSpreadWithinArrays(spread: Int) {
        self.spreadWithinArray = spread
    }
    
    func fluctuateAngleBetween(x: Int, y: Int) {
        
    }
}
