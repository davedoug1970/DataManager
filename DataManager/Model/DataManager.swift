//
//  DataManager.swift
//  DataManager
//
//  Created by David Douglas on 4/2/23.
//

import Foundation

protocol DataManager {
    associatedtype T:Codable, Identifiable
    
    func fetch() -> [T]
    func fetch(id: T.ID) -> T?
    func update(item: T) -> Bool
    func delete(id: T.ID) -> Bool
    func add(item: T) -> Bool
    func save() -> Bool
}
