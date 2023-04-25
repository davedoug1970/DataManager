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
    
    static func getFileLocation(fileName: String, withExtension: String, readonly: Bool) -> (fileLocation: URL?, exists: Bool) {
        if !readonly {
            let docFileLocation = Utilities.getDocumentsDirectory().appendingPathComponent("\(fileName).\(withExtension)")
            let docFileExists = FileManager.default.fileExists(atPath: docFileLocation.path())
            
            // if we have written first file to documents directory then load data from there, otherwise load file
            // included in the app bundle
            if docFileExists {
                return (fileLocation: docFileLocation, exists: true)
            }
        }
        
        if let fileLocation = Bundle.main.url(forResource: fileName, withExtension: withExtension) {
            return (fileLocation: fileLocation, exists: true)
        } else {
            return (fileLocation: nil, exists: false)
        }
    }
}
