//
//  FavoritesDataModel.swift
//  Dictionary
//
//  Created by Matheus Xavier on 13/09/22.
//

import Foundation
import CoreData
import FirebaseFirestoreSwift
import Firebase
import UIKit

struct FavoriteModel: Identifiable, Decodable {
    @DocumentID var id: String?
    var word: String
}

class FavoritesDataModel {
    
    static func uploadFavorite(word: String){
        guard let user = AuthDataModel.shared.currentUser else { return }
        let data: [String: Any] = [
            "word": word
        ]
        COLLECTION_FAVORITES.document(user.id!).collection("user-favorites").addDocument(data: data)
    }
    
    func fetchFavorites(completion: @escaping([FavoriteModel])->Void){
        guard let uid = AuthDataModel.shared.currentUser?.id else {return}
        
        let query = COLLECTION_FAVORITES.document(uid).collection("user-favorites")
        
        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let favs = documents.compactMap({ try? $0.data(as: FavoriteModel.self) })
            completion(favs)
        }
    }
    
    func verifyIfItsFavorite(word: String, completion: @escaping(Bool, FavoriteModel?)->Void) {
        guard let uid = AuthDataModel.shared.userSession?.uid else {return}
        
        COLLECTION_FAVORITES.document(uid).collection("user-favorites").whereField("word", isEqualTo: word).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let favs = documents.compactMap({ try? $0.data(as: FavoriteModel.self) })
            if favs.count > 0 && favs[0].word == word {
                completion(true, favs[0])
                return
            } else {
                completion(false, nil)
                return
            }
        }
    }
    
    func deleteRegister(id: String) {
        guard let uid = AuthDataModel.shared.currentUser?.id else {return}
        COLLECTION_FAVORITES.document(uid).collection("user-favorites").document(id).delete()
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

//struct FavoriteCD {
//    let word: String
//
//    init(record: Favorites) {
//        self.word = record.word ?? ""
//    }
//}
//
//class FavoritesDataModelCD {
//    static let shared = FavoritesDataModelCD()
//    var appDelegate: AppDelegate!
//    var managedContext: NSManagedObjectContext!
//    private var favEntity: NSEntityDescription!
//
//    init(){
//        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
//        self.managedContext = self.appDelegate?.persistentContainer.viewContext
//        self.favEntity = NSEntityDescription.entity(forEntityName: "Favorites", in: self.managedContext)
//    }
//
//    func createRegister(word: String) throws {
//        let alreadyExists = try? self.fetchRegister(withWord: word)
//        if alreadyExists == nil {
//            let newPoint = NSManagedObject(entity: favEntity, insertInto: managedContext)
//            newPoint.setValue(word, forKey: "word")
//
//            do {
//                try managedContext.save()
//            } catch let error {
//                throw error
//            }
//        }
//    }
//
//    func fetchRegisters() throws -> [Favorite]? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
//        do {
//            let result = try managedContext.fetch(fetchRequest) as! [Favorites]
//            var registers: [Favorite] = []
//            for register in result {
//                registers.append(Favorite(record: register))
//            }
//            return registers
//        } catch let error {
//            throw error
//        }
//    }
//
//    func fetchRegister(withWord word: String) throws -> Favorite? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
//        fetchRequest.predicate = NSPredicate(format: "word == %@", word)
//        fetchRequest.fetchLimit = 1
//        do {
//            guard let result = try managedContext.fetch(fetchRequest) as? [Favorites] else { return nil }
//            var registers: [Favorite] = []
//            for register in result {
//                registers.append(Favorite(record: register))
//            }
//            return registers.count > 0 ? registers[0] : nil
//        } catch let error {
//            throw error
//        }
//    }
//
//    func updateRegister(withWord word: String, data: [String: Any]) throws {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
//        fetchRequest.predicate = NSPredicate(format: "word == %@", word)
//
//        do {
//            guard let result = try managedContext.fetch(fetchRequest) as? [Favorites] else { return }
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
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
//        fetchRequest.predicate = NSPredicate(format: "word == %@", word)
//
//        do{
//            guard let result = try managedContext.fetch(fetchRequest) as? [Favorites] else { return }
//            guard let deletable = result.first else { return }
//            managedContext.delete(deletable)
//            try managedContext.save()
//        } catch let error {
//            throw error
//        }
//    }
//}
