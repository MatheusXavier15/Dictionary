//
//  Constants.swift
//  Dictionary
//
//  Created by Matheus Xavier on 13/09/22.
//

import Foundation
import UIKit
import Firebase

let lightModeColor: UIColor = .black
let darkModeColor: UIColor = .white
let dynamicColor = lightModeColor | darkModeColor

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_HISTORY = Firestore.firestore().collection("history")
let COLLECTION_FAVORITES = Firestore.firestore().collection("favorites")
