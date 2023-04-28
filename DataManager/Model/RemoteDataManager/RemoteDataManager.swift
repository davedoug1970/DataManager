//
//  RemoteDataManager.swift
//  DataManager
//
//  Created by David Douglas on 4/12/23.
//
//  This class uses a companion docker image that can be retrieved here:
//  https://hub.docker.com/r/davedoug1970/swiftpersonapi
//  source code is here: https://github.com/davedoug1970/swift-person-api

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
        let task = URLSession.shared.dataTask(with: formatFetchURL(query: query, queryType: queryType).url!) { (data, response, error) in
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
        let task = URLSession.shared.dataTask(with: formatFetchURL(query: query, queryType: queryType).url!) { (data, response, error) in
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
    
    func addItem(item: Entity, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "\(baseURL)\(addEndPoint)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let encoded = try? JSONEncoder().encode(item) {
            let task = URLSession.shared.uploadTask(with: request, from: encoded) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let response = response as? HTTPURLResponse {
                    if response.statusCode < 300 {
                        completion(.success(true))
                    } else {
                        completion(.success(false))
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func updateItem(item: Entity, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "\(baseURL)\(updateEndPoint)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let encoded = try? JSONEncoder().encode(item) {
            let task = URLSession.shared.uploadTask(with: request, from: encoded) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let response = response as? HTTPURLResponse {
                    if response.statusCode < 300 {
                        completion(.success(true))
                    } else {
                        completion(.success(false))
                    }
                }
            }
            
            task.resume()
        }
    }
 
    func deleteItem(id: Entity.ID, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "\(baseURL)\(deleteEndPoint)\(id)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
      
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let response = response as? HTTPURLResponse {
                if response.statusCode < 300 {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
        
        task.resume()
    }
}

private extension RemoteDataManager {
    func formatFetchURL(query: [String: String], queryType: QueryType) -> URLComponents {
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
        
        return urlComponents
    }
    
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
