//
//  UserModel.swift
//  Dictionary
//
//  Created by Matheus Xavier on 14/09/22.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var id: String?
    let email: String
    let username: String
    let fullname: String
    
    var isCurrentUser: Bool {
        return AuthDataModel.shared.userSession?.uid == id
    }
}
