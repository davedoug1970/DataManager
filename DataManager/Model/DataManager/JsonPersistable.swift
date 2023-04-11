//
//  JsonDataManager.swift
//  DataManager
//
//  Created by David Douglas on 4/3/23.
//

import Foundation

class JsonPersistable: Persistable {

    func load<Entity:Codable>(readonly: Bool) -> [Entity] {
        let fileName = String(describing: Entity.self).lowercased()
        var fileLocation = Bundle.main.url(forResource: fileName, withExtension: "json")!
    
        if !readonly {
            fileLocation = Utilities.getDocumentsDirectory().appendingPathComponent("\(fileName).json")
            
            let fileExists = FileManager.default.fileExists(atPath: fileLocation.path())
            
            // if we have not written first file to documents directory then load data from json file
            // included in the app bundle
            if !fileExists {
                fileLocation = Bundle.main.url(forResource: fileName, withExtension: "json")!
            }
        }

        do {
            let data = try Data(contentsOf: fileLocation)
            let returnData = try JSONDecoder().decode([Entity].self, from: data)

            return returnData
          } catch let DecodingError.dataCorrupted(context) {
              print(context)
          } catch let DecodingError.keyNotFound(key, context) {
              print("Key '\(key)' not found:", context.debugDescription)
              print("codingPath:", context.codingPath)
          } catch let DecodingError.valueNotFound(value, context) {
              print("Value '\(value)' not found:", context.debugDescription)
              print("codingPath:", context.codingPath)
          } catch let DecodingError.typeMismatch(type, context)  {
              print("Type '\(type)' mismatch:", context.debugDescription)
              print("codingPath:", context.codingPath)
          } catch {
              print("error: ", error.localizedDescription)
        }

        return []
    }
    
    func save<Entity:Codable & Identifiable>(data: [Entity], dataUpdates: [Entity.ID: ChangeType], readonly: Bool) -> Bool {
        if readonly {
            return true
        }
        
        let fileName = String(describing: Entity.self).lowercased()
        let jsonEncoder = JSONEncoder()
        // added to make output json more readable
        jsonEncoder.outputFormatting = .prettyPrinted
        let jsonString = try! jsonEncoder.encode(data)
        
        if let jsonData = String(data: jsonString, encoding: .utf8) {
            let pathWithFileName = Utilities.getDocumentsDirectory().appendingPathComponent("\(fileName).json")
            do {
                try jsonData.write(to: pathWithFileName, atomically: true, encoding: .utf8)
                return true
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return false
    }
}
