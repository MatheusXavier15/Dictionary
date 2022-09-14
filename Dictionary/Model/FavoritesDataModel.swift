//
//  FavoritesDataModel.swift
//  Dictionary
//
//  Created by Matheus Xavier on 13/09/22.
//

import Foundation
import CoreData
import UIKit

struct Favorite {
    let word: String
    
    init(record: Favorites) {
        self.word = record.word ?? ""
    }
}

class FavoritesDataModel {
    static let shared = FavoritesDataModel()
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    private var favEntity: NSEntityDescription!
    
    init(){
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = self.appDelegate?.persistentContainer.viewContext
        self.favEntity = NSEntityDescription.entity(forEntityName: "Favorites", in: self.managedContext)
    }
    
    func createRegister(word: String) throws {
        let alreadyExists = try? self.fetchRegister(withWord: word)
        if alreadyExists == nil {
            let newPoint = NSManagedObject(entity: favEntity, insertInto: managedContext)
            newPoint.setValue(word, forKey: "word")
            
            do {
                try managedContext.save()
            } catch let error {
                throw error
            }
        }
    }
    
    func fetchRegisters() throws -> [Favorite]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        do {
            let result = try managedContext.fetch(fetchRequest) as! [Favorites]
            var registers: [Favorite] = []
            for register in result {
                registers.append(Favorite(record: register))
            }
            return registers
        } catch let error {
            throw error
        }
    }
    
    func fetchRegister(withWord word: String) throws -> Favorite? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "word == %@", word)
        fetchRequest.fetchLimit = 1
        do {
            guard let result = try managedContext.fetch(fetchRequest) as? [Favorites] else { return nil }
            var registers: [Favorite] = []
            for register in result {
                registers.append(Favorite(record: register))
            }
            return registers.count > 0 ? registers[0] : nil
        } catch let error {
            throw error
        }
    }
    
    func updateRegister(withWord word: String, data: [String: Any]) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "word == %@", word)
        
        do {
            guard let result = try managedContext.fetch(fetchRequest) as? [Favorites] else { return }
            guard let updatable = result.first else { return }
            data.forEach { (key: String, value: Any) in
                updatable.setValue(value, forKey: key)
            }
            try managedContext.save()
        } catch let error {
            throw error
        }
    }
    
    func deleteRegister(withWord word: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "word == %@", word)
        
        do{
            guard let result = try managedContext.fetch(fetchRequest) as? [Favorites] else { return }
            guard let deletable = result.first else { return }
            managedContext.delete(deletable)
            try managedContext.save()
        } catch let error {
            throw error
        }
    }
}
