//
//  ApiPersistable.swift
//  DataManager
//
//  Created by David Douglas on 4/11/23.
//

import Foundation

class ApiPersistable: Persistable {
    private var baseURL: String
    private var fetchAllEndPoint: String
    private var fetchEndPoint: String
    private var updateEndPoint: String
    private var deleteEndPoint: String
    private var entityData: [Any] = []
    
    init(baseURL: String, fetchAllEndPoint: String, fetchEndPoint: String, updateEndPoint: String, deleteEndPoint: String) {
        self.baseURL = baseURL
        self.fetchAllEndPoint = fetchAllEndPoint
        self.fetchEndPoint = fetchEndPoint
        self.updateEndPoint = updateEndPoint
        self.deleteEndPoint = deleteEndPoint
    }
    
    func load<Entity: Codable>(readonly: Bool) -> [Entity] {
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .default).async {
            Task {
                var returnData:[Entity] = []
                
                do {
                    returnData = try await self.fetchEntities()
                    self.saveData(data: returnData)
                } catch {
                    print(error.localizedDescription)
                }
                group.leave()
            }
        }
        
        group.wait()
        
        return entityData as! [Entity]
    }
    
    func save<Entity: Codable & Identifiable>(data: [Entity], dataUpdates: [Entity.ID : ChangeType], readonly: Bool) -> Bool {
        return false
    }
    
    private func saveData(data: [Any]) {
        entityData = data
    }
    
    private func fetchEntities<Entity: Decodable>() async throws -> [Entity] {
        //create the new url
        let url = URL(string: "\(baseURL)\(fetchAllEndPoint)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            
        //create a new urlRequest passing the url
        let request = URLRequest(url: url!)
            
        //run the request and retrieve both the data and the response of the call
        let (data, response) = try await URLSession.shared.data(for: request)
            
        //checks if there are errors regarding the HTTP status code and decodes using the passed struct
        do {
            let fetchedData = try JSONDecoder().decode([Entity].self, from: try handleResponse(response: (data,response)))
            return fetchedData
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
    
    private func handleResponse(response: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            return response.data
        }
        
        if httpResponse.statusCode > 299 {
            print("Bad Response Code Returned - \(httpResponse.statusCode)")
        }
        
        return response.data
    }
}
