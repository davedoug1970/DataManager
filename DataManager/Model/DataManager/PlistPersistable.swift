//
//  PlistPersistable.swift
//  DataManager
//
//  Created by David Douglas on 4/4/23.
//

import Foundation

class PlistPersistable: Persistable {
    func load<Entity: Codable>(readonly: Bool) -> [Entity] {
        let fileName = String(describing: Entity.self).lowercased()
        var fileLocation = Bundle.main.url(forResource: fileName, withExtension: "plist")!
    
        if !readonly {
            fileLocation = Utilities.getDocumentsDirectory().appendingPathComponent("\(fileName).plist")
            
            let fileExists = FileManager.default.fileExists(atPath: fileLocation.path())
            
            // if we have not written first file to documents directory then load data from json file
            // included in the app bundle
            if !fileExists {
                fileLocation = Bundle.main.url(forResource: fileName, withExtension: "plist")!
            }
        }
 
        var returnData:[Entity] = []
        
        do {
            // load data from plist file.
            let data = try Data(contentsOf: fileLocation)
            // convert raw plist data into an array of any objects.
            let arrayAny = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [Any]
            // serialize the array of any objects into JSON.
            let jsonData = try JSONSerialization.data(withJSONObject: arrayAny, options: .withoutEscapingSlashes)
            // decode the JSON into the specific entity that is being loaded.
            returnData = try JSONDecoder().decode([Entity].self, from: jsonData)
        } catch {
            print(error.localizedDescription)
        }

        return returnData
    }
    
    func save<Entity: Codable & Identifiable>(data: [Entity], dataUpdates: [Entity.ID: ChangeType], readonly: Bool) -> Bool {
        if readonly {
            return true
        }
        
        let fileName = String(describing: Entity.self).lowercased()
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        do {
            let data = try encoder.encode(data)
            let pathWithFileName = Utilities.getDocumentsDirectory().appendingPathComponent("\(fileName).plist")
            try data.write(to: pathWithFileName)
            return true
        } catch {
            print(error.localizedDescription)
        }
        
        return false
    }
}
