//
//  MovieViewController.swift
//  INFS3202
//
//  Created by Adam Dorogi-Kaposi on 24/5/18.
//  Copyright © 2018 Adam Dorogi-Kaposi. All rights reserved.
//

import UIKit

class MovieViewController: UITableViewController {

    var movieTitle = String()
    var movieImageView = UIImageView()
    var movieDescription = String()
    var movieCategory = String()
    var movieReleaseDate = String()
    var movieCast = String()
    var movieDuration = String()
    var liked = Bool()
    var likes = Int()
    var movieId = Int()
    let likeButton = UIButton()
    let likesLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movieTitle
        
        tableView.backgroundColor = UIColor(red: 5/255, green: 5/255, blue: 5/255, alpha: 1.0)
        tableView.separatorColor = .clear
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        movieImageView.frame.size.height = tableView.frame.height / 2
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        tableView.tableHeaderView = movieImageView
        
        // Set like button
        likeButton.frame.size = CGSize(width: 32, height: 32)
        likeButton.frame.origin = CGPoint(x: movieImageView.frame.width - likeButton.frame.width * 1.5, y: movieImageView.frame.height - likeButton.frame.height)
        likeButton.tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        view.addSubview(likeButton)
        
        // Likes label
        likesLabel.font = .systemFont(ofSize: 20, weight: .bold)
        displayLike()
        likesLabel.frame.origin = CGPoint(x: likeButton.frame.origin.x - likesLabel.frame.width * 2, y: likeButton.frame.origin.y + (likeButton.frame.height - likesLabel.frame.height) / 2)
        likesLabel.textColor = UIColor(white: 1.0, alpha: 0.5)
        
        view.addSubview(likesLabel)
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor(red: 5/255, green: 5/255, blue: 5/255, alpha: 1.0).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = movieImageView.frame
        movieImageView.layer.addSublayer(gradient)
        
        // String to date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let date = dateFormatter.date(from: movieReleaseDate)
        
        // Date to string
        dateFormatter.dateFormat = "MMMM d, yyyy"
        movieReleaseDate = dateFormatter.string(from: date!)
        
        // String to date
        dateFormatter.dateFormat = "HH:mm:ss"
        let time = dateFormatter.date(from: movieDuration)

        // Date to string
        dateFormatter.dateFormat = "H'h' mm'm'"
        movieDuration = dateFormatter.string(from: time!)
    }
    
    func displayLike() {
        likesLabel.text = "\(likes)"
        likesLabel.sizeToFit()
        if liked {
            likeButton.setImage(UIImage(named: "heartIconSelected"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "heartIcon"), for: .normal)
        }
    }
    
    func isLiked() {
        let bodyData = "movie_id=\(movieId))"
        
        liked = false
        
        // Check which movies are liked
        Request().request(file: "isLiked.php", bodyData: bodyData) { json in
            DispatchQueue.main.async {
                self.liked = json[0]["liked"] as! Bool
                self.displayLike()
            }
        }
    }
    
    @objc func likeButtonTapped() {
        print("AAA")
        let bodyData = "movie_id=\(movieId))"
        
        Request().request(file: "like.php", bodyData: bodyData) { json in
            DispatchQueue.main.async {
                if json[0]["status"] as! String == "error" {
                    self.login()
                } else {
                    print("AAAA", json)
                    self.likes = json[0]["likes"] as! Int
                    self.liked = json[0]["liked"] as! Bool
                    self.displayLike()
                }
            }
        }
    }
    
    func login() {
        let loginViewController = LoginViewController()
        
        let loginNavigationController = UINavigationController(rootViewController: loginViewController)
        loginNavigationController.navigationBar.barStyle = .black
        loginNavigationController.navigationBar.prefersLargeTitles = true
        
        present(loginNavigationController, animated: true)
        
        loginViewController.done = {
            self.isLiked()
        }
        
        loginViewController.changeToSignUp = {
            let registerViewController = RegisterViewController()
            
            let registerNavigationController = UINavigationController(rootViewController: registerViewController)
            registerNavigationController.navigationBar.barStyle = .black
            registerNavigationController.navigationBar.prefersLargeTitles = true
            
            self.present(registerNavigationController, animated: true)
            
            registerViewController.done = {
                self.isLiked()
            }
            
            registerViewController.changeToLogin = {
                self.login()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Description", "Category", "Release Date", "Cast", "Duration"][section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 5/255, green: 5/255, blue: 5/255, alpha: 1.0)
        cell.selectedBackgroundView? = UIView()
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.section == 0 {
            cell.textLabel?.text = movieDescription
        } else if indexPath.section == 1 {
            cell.textLabel?.text = movieCategory
        } else if indexPath.section == 2 {
            cell.textLabel?.text = movieReleaseDate
        } else if indexPath.section == 3 {
            cell.textLabel?.text = movieCast
        } else if indexPath.section == 4 {
            cell.textLabel?.text = movieDuration
        }

        return cell
    }
}
