//
//  JsonDataManager.swift
//  DataManager
//
//  Created by David Douglas on 4/3/23.
//

import Foundation

class JsonPersistable: Persistable {
    func load<Entity:Codable>(readonly: Bool) -> [Entity] {
        let fileInfo = Utilities.getFileLocation(fileName: String(describing: Entity.self).lowercased(),
                                                 withExtension: "json", readonly: readonly)
        
        // if unable to find the file, it probably doesnt exist in the bundle, so just return an empty array.
        if !fileInfo.exists {
            return []
        }

        do {
            let data = try Data(contentsOf: fileInfo.fileLocation!)
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
    
    func save<Entity:Codable & Identifiable>(data: [Entity], readonly: Bool) -> Bool {
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
