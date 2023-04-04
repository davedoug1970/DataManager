//
//  Persistable.swift
//  DataManager
//
//  Created by David Douglas on 4/3/23.
//

import Foundation

protocol Persistable {
    func load<Entity:Codable>(readonly: Bool) -> [Entity]
    func save<Entity:Codable>(data: [Entity], readonly: Bool) -> Bool
}
