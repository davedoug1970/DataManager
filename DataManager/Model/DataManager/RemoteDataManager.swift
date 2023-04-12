//
//  RemoteDataManager.swift
//  DataManager
//
//  Created by David Douglas on 4/12/23.
//

import Foundation

class RemoteDataManager<Entity: Codable & Identifiable> {
    private var baseURL: String
    private var fetchAllEndPoint: String
    private var fetchEndPoint: String
    private var addEndPoint: String
    private var updateEndPoint: String
    private var deleteEndPoint: String
    
    init(baseURL: String, fetchAllEndPoint: String, fetchEndPoint: String, addEndPoint: String, updateEndPoint: String, deleteEndPoint: String) {
        self.baseURL = baseURL
        self.fetchAllEndPoint = fetchAllEndPoint
        self.fetchEndPoint = fetchEndPoint
        self.addEndPoint = addEndPoint
        self.updateEndPoint = updateEndPoint
        self.deleteEndPoint = deleteEndPoint
    }
    
    func fetchItem(matching query: [String: String], queryType: QueryType, completion: @escaping (Result<Entity, Error>) -> Void) {
        var urlComponents = URLComponents()

        if queryType == .querystring {
            urlComponents = URLComponents(string: "\(baseURL)\(fetchEndPoint)")!
            urlComponents.queryItems = query.map({ URLQueryItem(name: $0.key, value: $0.value) })
        } else {
            urlComponents = URLComponents(string: "\(baseURL)\(fetchEndPoint)\(formatParameters(parameters: query))")!
        }
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let searchResponse = try decoder.decode(Entity.self, from: data)
                    completion(.success(searchResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func fetchItems(matching query: [String: String], queryType: QueryType, completion: @escaping (Result<[Entity], Error>) -> Void) {
        var urlComponents = URLComponents()
        
        if query.count > 0 {
            if queryType == .querystring {
                urlComponents = URLComponents(string: "\(baseURL)\(fetchEndPoint)")!
                urlComponents.queryItems = query.map({ URLQueryItem(name: $0.key, value: $0.value) })
            } else {
                urlComponents = URLComponents(string: "\(baseURL)\(fetchEndPoint)\(formatParameters(parameters: query))")!
            }
        } else {
            urlComponents = URLComponents(string: "\(baseURL)\(fetchAllEndPoint)")!
        }
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let searchResponse = try decoder.decode([Entity].self, from: data)
                    completion(.success(searchResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

private extension RemoteDataManager {
    func formatParameters(parameters: [String: String]) -> String {
        var queryParameters = ""
        
        parameters.forEach { queryParameter in
            queryParameters = "\(queryParameters)\(queryParameter.value)"
        }
        
        return queryParameters
    }
}

enum QueryType: String {
    case querystring
    case url
}
