//
//  StringExtension.swift
//  WWDC23-SSC
//
//  Created by Paulo César on 08/04/22.
//

import Foundation

extension String {
    func contains(_ strings: [String]) -> Bool {
        strings.contains { contains($0) }
    }
}
