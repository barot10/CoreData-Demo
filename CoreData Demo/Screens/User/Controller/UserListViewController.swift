//
//  UserListViewController.swift
//  CoreData Demo
//
//  Created by Parth Barot on 7/13/23.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    private var users: [User] = []
    private let manager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users = manager.fetchUsers()
        userTableView.reloadData()
    }
    
    @IBAction func addUserButtonTapped(_ sender: UIBarButtonItem) {
        addUpdateUserNavigation()
    }

    func addUpdateUserNavigation(user: User? = nil) {
        guard let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        registerVC.user = user
        navigationController?.pushViewController(registerVC, animated: true)
    }
}


extension UserListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell else {
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }

}

extension UserListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(style: .normal, title: "Update") { _, _, _ in
            self.addUpdateUserNavigation(user: self.users[indexPath.row])
        }
        update.backgroundColor = .systemIndigo

        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.manager.deleteUser(userEntity: self.users[indexPath.row]) // Core Data
            self.users.remove(at: indexPath.row) // Array
            self.userTableView.reloadData() // Table Reload karna hai
        }

        return UISwipeActionsConfiguration(actions: [delete, update])
    }

}

