//
//  GenericDataManager.swift
//  DataManager
//
//  Created by David Douglas on 4/3/23.
//

import Foundation

class GenericDataManager<Entity: Codable & Identifiable> {
    private var data: [Entity] = []
    private var persistanceStrategy: Persistable
    private var readonly: Bool
    
    init(persistanceStrategy: Persistable, readonly: Bool) {
        self.readonly = readonly
        self.persistanceStrategy = persistanceStrategy
        data = self.persistanceStrategy.load(readonly: self.readonly)
    }
    
    func fetch() -> [Entity] {
        return data
    }
    
    func fetch(id: Entity.ID) -> Entity? {
        if let firstItem = data.first(where: { $0.id == id }) {
            return firstItem
        }
        return nil
    }
    
    func update(item: Entity) -> Bool {
        if let i = data.firstIndex(where: { $0.id == item.id }) {
            data[i] = item
            return save()
        }
        return false
    }

    func delete(id: Entity.ID) -> Bool {
        if let i = data.firstIndex(where: { $0.id == id }) {
            data.remove(at: i)
            return save()
        }
        return false
    }
    
    func add(item: Entity) -> Bool {
        data.append(item)
        return save()
    }

    func save() -> Bool {
        return persistanceStrategy.save(data: data, readonly: readonly)
    }
}
