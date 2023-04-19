//
//  SharedDataManager.swift
//  DataManager
//
//  Created by David Douglas on 4/13/23.
//

import Foundation

protocol SharedDataManager {
    associatedtype T: Codable & Identifiable
    
    static var shared: DataManager<T> { get }
}
