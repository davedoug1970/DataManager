//
//  PlistPersistable.swift
//  DataManager
//
//  Created by David Douglas on 4/4/23.
//

import Foundation

class PlistPersistable: Persistable {
    func load<Entity: Codable>(readonly: Bool) -> [Entity] {
        let fileInfo = Utilities.getFileLocation(fileName: String(describing: Entity.self).lowercased(),
                                                 withExtension: "plist", readonly: readonly)
        
        // if unable to find the file, it probably doesnt exist in the bundle, so just return an empty array.
        if !fileInfo.exists {
            return []
        }

        do {
            // load data from plist file.
            let data = try Data(contentsOf: fileInfo.fileLocation!)
            // convert raw plist data into an array of any objects. Unable to cast to Entity type.
            let arrayAny = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [Any]
            // serialize the array of any objects into JSON.
            let jsonData = try JSONSerialization.data(withJSONObject: arrayAny, options: .withoutEscapingSlashes)
            // decode the JSON into the specific entity type (rather than Any type) that is being loaded.
            let returnData = try JSONDecoder().decode([Entity].self, from: jsonData)
            return returnData
        } catch {
            print(error.localizedDescription)
        }

        return []
    }
    
    func save<Entity: Codable & Identifiable>(data: [Entity], readonly: Bool) -> Bool {
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
