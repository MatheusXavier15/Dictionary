//
//  HistoryDataModel.swift
//  Dictionary
//
//  Created by Matheus Xavier on 13/09/22.
//

import Foundation
import CoreData
import FirebaseFirestoreSwift
import Firebase
import UIKit

struct HistoryModel: Identifiable, Decodable {
    @DocumentID var id: String?
    var word: String
}

struct HistoryDataModel {
    static func uploadHistory(word: String){
        guard let user = AuthDataModel.shared.currentUser else { return }
        var data: [String: Any] = [
            "word": word
        ]
        FavoritesDataModel().verifyIfItsFavorite(word: word) { result, _  in
            data["favorite"] = result
            COLLECTION_HISTORY.document(user.id!).collection("user-history").addDocument(data: data)
        }
    }
    
    func fetchRegisters(completion: @escaping([HistoryModel])->Void){
        guard let uid = AuthDataModel.shared.currentUser?.id else {return}
        
        let query = COLLECTION_HISTORY.document(uid).collection("user-history")
        
        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let history = documents.compactMap({ try? $0.data(as: HistoryModel.self) })
            completion(history)
        }
    }
    
    func deleteRegister(id: String) {
        guard let uid = AuthDataModel.shared.currentUser?.id else {return}
        COLLECTION_HISTORY.document(uid).collection("user-history").document(id).delete()
    }
    
    func deleteAllRegisters() {
        guard let uid = AuthDataModel.shared.currentUser?.id else {return}
        COLLECTION_HISTORY.document(uid).delete()
    }
}

/*
 Observação: Como o projeto é para demonstrar conhecimento, o código comentado a seguir
 poderia ser utilizado para armazenar todos os dados localmente, sem a necessidade do firebase
 utilizando o CoreData nativo. A princípio o projeto foi feito dessa forma, posteriormente optei por armazenar
 os dados no firebase. Optei por deixar o código comentado como sinal de conhecimento do uso do CoreData.
 --------
 Note: As the project is to demonstrate knowledge, the code commented below
 could be used to store all data locally, without firebase, using native CoreData.
 At first, the project was made that way, later I chose to store the data in firebase.
 I chose to leave the code commented out as a sign of knowledge of using CoreData.
 */

//struct WordHistoryCD: Codable {
//    let date: Date?
//    let favorite: Bool
//    let word: String
//    
//    init(record: History){
//        self.date = record.date ?? nil
//        self.favorite = record.favorite
//        self.word = record.word ?? ""
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.date = try container.decodeIfPresent(Date.self, forKey: .date)
//        self.favorite = try container.decode(Bool.self, forKey: .favorite)
//        self.word = try container.decode(String.self, forKey: .word)
//    }
//    
//    init(word: String, fav: Bool, date: Date){
//        self.word = word
//        self.favorite = fav
//        self.date = date
//    }
//}

//class HistoryDataModelCD {
//    static let shared = HistoryDataModelCD()
//    var appDelegate: AppDelegate!
//    var managedContext: NSManagedObjectContext!
//    private var historyEntity: NSEntityDescription!
//
//    init(){
//        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
//        self.managedContext = self.appDelegate?.persistentContainer.viewContext
//        self.historyEntity = NSEntityDescription.entity(forEntityName: "History", in: self.managedContext)
//    }
//
//    func createRegister(wordHistory: WordHistory) throws {
//        let newPoint = NSManagedObject(entity: historyEntity, insertInto: managedContext)
//        newPoint.setValue(wordHistory.word, forKey: "word")
//        newPoint.setValue(wordHistory.favorite, forKey: "favorite")
//        newPoint.setValue(wordHistory.date, forKey: "date")
//
//        do {
//            try managedContext.save()
//        } catch let error {
//            throw error
//        }
//    }
//
//    func fetchRegisters() throws -> [WordHistory]? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
//        do {
//            let result = try managedContext.fetch(fetchRequest) as! [History]
//            var registers: [WordHistory] = []
//            for register in result {
//                registers.append(WordHistory(record: register))
//            }
//            return registers
//        } catch let error {
//            throw error
//        }
//    }
//
//    func fetchRegister(withWord word: String) throws -> WordHistory? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
//        fetchRequest.predicate = NSPredicate(format: "word == %@", word)
//        fetchRequest.fetchLimit = 1
//        do {
//            guard let result = try managedContext.fetch(fetchRequest) as? [History] else { return nil }
//            var registers: [WordHistory] = []
//            for register in result {
//                registers.append(WordHistory(record: register))
//            }
//            return registers.count > 0 ? registers[0] : nil
//        } catch let error {
//            throw error
//        }
//    }
//
//
//    func updateRegister(withWord word: String, data: [String: Any]) throws {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
//        fetchRequest.predicate = NSPredicate(format: "word == %@", word)
//
//        do {
//            guard let result = try managedContext.fetch(fetchRequest) as? [History] else { return }
//            guard let updatable = result.first else { return }
//            data.forEach { (key: String, value: Any) in
//                updatable.setValue(value, forKey: key)
//            }
//            try managedContext.save()
//        } catch let error {
//            throw error
//        }
//    }
//
//    func deleteRegister(withWord word: String) throws {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
//        fetchRequest.predicate = NSPredicate(format: "word == %@", word)
//
//        do{
//            guard let result = try managedContext.fetch(fetchRequest) as? [History] else { return }
//            guard let deletable = result.first else { return }
//            managedContext.delete(deletable)
//            try managedContext.save()
//        } catch let error {
//            throw error
//        }
//    }
//
//    func deleteAllRegisters() throws {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
//        fetchRequest.returnsObjectsAsFaults = false
//        do{
//            guard let result = try managedContext.fetch(fetchRequest) as? [History] else { return }
//            result.forEach { deletable in
//                managedContext.delete(deletable)
//            }
//            try managedContext.save()
//        } catch let error {
//            throw error
//        }
//    }
//}
