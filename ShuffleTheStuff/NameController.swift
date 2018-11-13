//
//  NameController.swift
//  ShuffleTheStuff
//
//  Created by Levi Linchenko on 12/11/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import Foundation

class NameController{
    
    static let shared = NameController()
    
    var name: [String] = []
    
    init() {
        loadFromPersistentStorage()
    }
    
    // MARK: - Persistence
    
    private func fileURL() -> URL {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "nameShuffler.json"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    
    private func loadFromPersistentStorage() {
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let names = try decoder.decode([String].self, from: data)
            self.name = names
        } catch let error {
            print("There was an error saving to persistent storage: \(error)")
        }
    }
    
    func saveToPersistentStorage() {
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(name)
            try data.write(to: fileURL())
        } catch let error {
            print("There was an error saving to persistent storage: \(error)")
        }
    }
    
    
}
