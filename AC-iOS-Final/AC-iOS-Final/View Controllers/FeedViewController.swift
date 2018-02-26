//
//  FeedViewController.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit
//import Kingfisher
class FeedViewController: UIViewController {

    var posts = [Post]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       self.tableView.estimatedRowHeight = 450
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.register(FeedCell.self, forCellReuseIdentifier: "feedCell")
        loadPosts()
    }
    
    func loadPosts() {
        DBService.manager.getPosts { (posts, error) in
            if let error = error {
                print("getting posts error: \(error)")
            }
            if let onlinePosts = posts {
                self.posts = onlinePosts
            }
        }
    }
   
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        FirebaseAPIClient.manager.signOut()
        let loginVC = LoginViewController.storyboardInstance()
        present(loginVC, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FeedViewController: UITableViewDelegate {
    
}
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        
        if let imageUrl = URL.init(string: posts[indexPath.row].imageURL){
        do {
        let imageData = try Data.init(contentsOf: imageUrl)
        let image = UIImage(data: imageData)
        cell.postImageView?.image = image
        } catch {
            print("imageData error: \(error)")
        }
        }
        cell.commentLabel?.text = posts[indexPath.row].comment
        return cell
    }
}
