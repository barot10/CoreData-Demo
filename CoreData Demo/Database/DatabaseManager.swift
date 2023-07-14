//
//  DatabaseManager.swift
//  CoreData Demo
//
//  Created by Parth Barot on 7/13/23.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager {

    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func addUser(_ user: UserModel) {
        let userEntity = User(context: context) // User create karta the
        addUpdateUser(userEntity: userEntity, user: user)
    }

    func updateUser(user: UserModel, userEntity: User) {
        addUpdateUser(userEntity: userEntity, user: user)
        // Database mai reflect karne ke liye - IMP
    }

    private func addUpdateUser(userEntity: User, user: UserModel) {
        userEntity.firstName = user.firstName
        userEntity.lastName = user.lastName
        userEntity.email = user.email
        userEntity.password = user.password
        userEntity.imageName = user.imageName
        saveContext()
    }

    func fetchUsers() -> [User] {
        var users: [User] = []

        do {
            users = try context.fetch(User.fetchRequest())
        }catch {
            print("Fetch user error", error)
        }

        return users
    }

    func saveContext() {
        do {
            try context.save() // MIMP
        }catch {
            print("User saving error:", error)
        }
    }

    func deleteUser(userEntity: User) {
        let imageURL = URL.documentsDirectory.appending(components: userEntity.imageName ?? "").appendingPathExtension("png")
        do {
            try FileManager.default.removeItem(at: imageURL)
        }catch {
            print("remove image from DD", error)
        }
        context.delete(userEntity)
        saveContext() //MIMP
    }

}
