//
//  UsersViewController.swift
//  DMNetworkingIntro
//
//  Created by David Ruvinskiy on 4/10/23.
//

import UIKit

/**
 1. Create the user interface. See the provided screenshot for how the UI should look.
 2. Follow the instructions in the `User` file.
 3. Follow the instructions in the `NetworkManager` file.
 */
class UsersViewController: UIViewController, NetworkManagerDelegate, UITableViewDataSource  {
    
    /**
     4. Create a variable called `users` and set it to an empty array of `User` objects.
     */
    var users: [User] = []
    
    /**
     5. Connect the UITableView to the code. Create a function called `configureTableView` that configures the table view. You may find the `Constants` file helpful. Make sure to call the function in the appropriate spot.
     */
    
    @IBOutlet weak var tableView: UITableView!
    
    func configureTableView() {
        tableView.dataSource = self
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.userReuseID, for: indexPath)
        // how to get firstName and email
        var content = cell.defaultContentConfiguration()
        content.text = users[indexPath.row].firstName
        content.secondaryText = users[indexPath.row].email
        
        cell.contentConfiguration = content
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return users.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getUsers()
    }
    
    /**
     6.1 Set the `NetworkManager`'s delegate property to the `UsersViewController`. Have the `UsersViewController` conform to the `NetworkManagerDelegate` protocol. In the `usersRetrieved` function, assign the `users` property to the array we got back from the API and call `reloadData` on the table view.
     */
    func getUsers() {
//        NetworkManager.shared.delegate = self
        //should this be seperate function  or nested 
        func presentAlert() {
            
        }
        NetworkManager.shared.getUsers { [weak self] result in
            self?.getUsers()
            switch result {
            case .success(let users):
                //tried autocomplete after self no help
                self.updateUI(with: users)
            case .failure(let error):
                self.presentAlert(title: "bad stuff happed", message: error.rawValue, buttonTitle: "ok")
            }
            self.isLoadingMoreUsers = false
            
        }
        
        
        
    }
    
    func usersRetrieved(user: [User]) {
        users = user
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}
