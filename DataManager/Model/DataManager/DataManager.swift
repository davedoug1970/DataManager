//
//  DataManager.swift
//  DataManager
//
//  Created by David Douglas on 4/3/23.
//

import Foundation

class DataManager<Entity: Codable & Identifiable> {
    private var data: [Entity] = []
    private var dataUpdates: [Entity.ID: ChangeType] = [:]
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
            addChange(id: item.id, type: .update)
            return save()
        }
        return false
    }

    func delete(id: Entity.ID) -> Bool {
        if let i = data.firstIndex(where: { $0.id == id }) {
            data.remove(at: i)
            addChange(id: id, type: .delete)
            return save()
        }
        return false
    }
    
    func add(item: Entity) -> Bool {
        data.append(item)
        addChange(id: item.id, type: .add)
        return save()
    }
    
    private func addChange(id: Entity.ID, type: ChangeType) {
        switch type {
        case .add:
            dataUpdates[id] = type
        case .update:
            if dataUpdates.contains(where: { $0.key == id }) {
                if dataUpdates[id] != .add {
                    dataUpdates[id] = type
                }
            } else {
                dataUpdates[id] = type
            }
        case .delete:
            dataUpdates[id] = type
        }
    }
    
    private func save() -> Bool {
        let success = persistanceStrategy.save(data: data, dataUpdates: dataUpdates, readonly: readonly)
        
        if success {
            dataUpdates = [:]
        }
        
        return success
    }
}

enum ChangeType: String {
    case update
    case add
    case delete
}
