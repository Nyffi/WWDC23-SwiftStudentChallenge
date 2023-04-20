//
//  DevLevelDesign.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 30/03/23.
//

import Foundation
import SpriteKit

class DevLevelDesign: SKScene {
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.view?.ignoresSiblingOrder = true
    }
}
