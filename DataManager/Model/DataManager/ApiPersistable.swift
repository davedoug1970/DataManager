//
//  ApiPersistable.swift
//  DataManager
//
//  Created by David Douglas on 4/11/23.
//

import Foundation

class ApiPersistable {
    private var baseURL: String
    private var fetchAllEndPoint: String
    private var fetchEndPoint: String
    private var addEndPoint: String
    private var updateEndPoint: String
    private var deleteEndPoint: String
    private var entityData: [Any] = []
    
    init(baseURL: String, fetchAllEndPoint: String, fetchEndPoint: String, addEndPoint: String, updateEndPoint: String, deleteEndPoint: String) {
        self.baseURL = baseURL
        self.fetchAllEndPoint = fetchAllEndPoint
        self.fetchEndPoint = fetchEndPoint
        self.addEndPoint = addEndPoint
        self.updateEndPoint = updateEndPoint
        self.deleteEndPoint = deleteEndPoint
    }
    
    func load<Entity: Codable>(readonly: Bool) -> [Entity] {
        // using a dispatch group to wait for retrieval of API data before exiting method...
        let group = DispatchGroup()
        group.enter()
        
        // avoid deadlocks by not using .main queue here
        DispatchQueue.global(qos: .default).async {
            Task {
                var returnData:[Entity] = []
                
                do {
                    returnData = try await self.fetchEntities()
                    // set private attribute equal to the data that is retured...
                    self.saveData(data: returnData)
                } catch {
                    print(error.localizedDescription)
                }
                group.leave()
            }
        }
        
        // wait for data to be retrieved...
        group.wait()
        
        // use private attribute to return data fetched from API...
        return entityData as! [Entity]
    }
    
    func save<Entity: Codable & Identifiable>(data: [Entity], readonly: Bool) -> Bool {
        return false
    }
    
    func saveData(data: [Any]) {
        entityData = data
    }
}

// MARK: Networking
private extension ApiPersistable {
    func fetchEntities<Entity: Decodable>() async throws -> [Entity] {
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
    
    func handleResponse(response: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            return response.data
        }
        
        if httpResponse.statusCode > 299 {
            print("Bad Response Code Returned - \(httpResponse.statusCode)")
        }
        
        return response.data
    }
}
