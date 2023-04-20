//
//  Bitmasks.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 13/04/23.
//

import Foundation

enum Bitmasks: UInt32 {
    case player = 0b1
    case playerGraze = 0b10
    case enemy = 0b100
    
    case pBullet = 0b1000
    case eBullet = 0b10000
    
    case nothing = 0
}
