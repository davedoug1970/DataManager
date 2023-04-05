//
//  Utilities.swift
//  DataManager
//
//  Created by David Douglas on 4/4/23.
//

import Foundation

class Utilities {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
