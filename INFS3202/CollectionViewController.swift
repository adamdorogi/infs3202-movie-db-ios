//
//  CollectionViewController.swift
//  INFS3202
//
//  Created by Adam Dorogi-Kaposi on 21/5/18.
//  Copyright © 2018 Adam Dorogi-Kaposi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

let spacing: CGFloat = 20.0
var jsonResponse: [[String: Any]] = []
let refreshControl = UIRefreshControl()

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Set up refresh
        refreshControl.addTarget(self, action: #selector(getMovies), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMovies()
    }
    
    func login() {
        let loginViewController = LoginViewController()
        
        let loginNavigationController = UINavigationController(rootViewController: loginViewController)
        loginNavigationController.navigationBar.barStyle = .black
        loginNavigationController.navigationBar.prefersLargeTitles = true
        
        present(loginNavigationController, animated: true)
        
        loginViewController.done = {
            self.getMovies()
        }
        
        loginViewController.changeToSignUp = {
            let registerViewController = RegisterViewController()
            
            let registerNavigationController = UINavigationController(rootViewController: registerViewController)
            registerNavigationController.navigationBar.barStyle = .black
            registerNavigationController.navigationBar.prefersLargeTitles = true
            
            self.present(registerNavigationController, animated: true)
            
            registerViewController.done = {
                self.getMovies()
            }
            
            registerViewController.changeToLogin = {
                self.login()
            }
        }
    }
    
    @IBAction func accountButton(_ sender: Any) {
        Request().request(file: "getAccount.php") { json in
            print(json)
            DispatchQueue.main.async {
                if json[0]["status"] as! String == "error" {
                    self.login()
                } else {
                    let accountViewController = AccountViewController(style: .grouped)
                    accountViewController.email = json[0]["email"] as! String
                    
                    let navigationController = UINavigationController(rootViewController: accountViewController)
                    navigationController.navigationBar.barStyle = .black
                    navigationController.navigationBar.prefersLargeTitles = true
                    
                    self.present(navigationController, animated: true)
                    
                    accountViewController.done = {
                        self.getMovies()
                    }
                }
            }
        }
    }
    
    @objc func getMovies() {
        Request().request(file: "getMovies.php") { json in
            jsonResponse = json
            DispatchQueue.main.async {
                refreshControl.endRefreshing()
                self.collectionView?.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsonResponse.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        let movie = jsonResponse[indexPath.item]
        
        cell.title = movie["title"] as! String
        cell.releaseDate = movie["release_date"]  as! String
        cell.likes = movie["likes"]  as! Int
        
        let bodyData = "movie_id=\(String(movie["id"] as! Int))"
        
        cell.liked = false
        
        // Check which movies are liked
        Request().request(file: "isLiked.php", bodyData: bodyData) { json in
            DispatchQueue.main.async {
                cell.liked = json[0]["liked"] as! Bool
                cell.layoutSubviews()
            }
        }
        
        // Like movies on heart button press (called from cell)
        cell.toggleLike = { likedCell in
            Request().request(file: "like.php", bodyData: bodyData) { json in
                DispatchQueue.main.async {
                    if json[0]["status"] as! String == "error" {
                        self.login()
                    } else {
                        print("AAAA", json)
                        cell.likes = json[0]["likes"] as! Int
                        cell.liked = json[0]["liked"] as! Bool
                        cell.layoutSubviews()
                    }
                }
            }
        }
        
        // Download movie image from server
        DispatchQueue.global().async {
            do {
                let imageURL = URL(string: "\(Request().serverURL)images/\(String(movie["id"] as! Int)).jpg")
                let imageData = try Data(contentsOf: imageURL!)
                
                DispatchQueue.main.async {
                    cell.backgroundImageView.image = UIImage(data: imageData)!
                }
            } catch {
                print("ERROR: Couldn't download artist profile image.")
            }
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let movie = jsonResponse[indexPath.item]
        
        let movieViewController = MovieViewController(style: .grouped)
        movieViewController.movieTitle = movie["title"] as! String
        movieViewController.movieImageView.image = cell.backgroundImageView.image
        movieViewController.movieDescription = movie["description"] as! String
        movieViewController.movieCategory = movie["category"]  as! String
        movieViewController.movieReleaseDate = movie["release_date"]  as! String
        movieViewController.movieCast = movie["main_cast"]  as! String
        movieViewController.movieDuration = movie["duration"]  as! String
        movieViewController.liked = cell.liked
        movieViewController.likes = cell.likes
        movieViewController.movieId = movie["id"] as! Int
        
        navigationController?.pushViewController(movieViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 2 * spacing, height: view.frame.width / 2)
    }
}
