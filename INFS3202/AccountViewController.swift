//
//  AccountViewController.swift
//  INFS3202
//
//  Created by Adam Dorogi-Kaposi on 23/5/18.
//  Copyright © 2018 Adam Dorogi-Kaposi. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
    var email = String()
    var done: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Account"
        tableView.backgroundColor = UIColor(red: 5/255, green: 5/255, blue: 5/255, alpha: 1.0)
        tableView.separatorColor = .clear
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        doneButton.tintColor = .white
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Email"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 5/255, green: 5/255, blue: 5/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        cell.textLabel?.textColor = .white
        
        if indexPath.section == 0 {
            cell.textLabel?.text = email
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "Log Out"
        } else {
            cell.textLabel?.text = "Delete Account"
            cell.textLabel?.textColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let alert = UIAlertController(title: "Log Out?", message: "Are you sure you want to log out?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { action in
                Request().request(file: "logout.php") { json in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: {
                            self.done!()
                        })
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        } else if indexPath.section == 2 {
            let alert = UIAlertController(title: "Delete Account?", message: "Are you sure you want to delete your account? This cannot be undone.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete Account", style: .destructive, handler: { action in
                Request().request(file: "delete.php") { json in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: {
                            self.done!()
                        })
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
