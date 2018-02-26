//
//  DBService.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

enum AppError: Error {
    case invalidChildren
}

class DBService {
    static let manager = DBService()
    private init() {
        dbRef = Database.database().reference()
        usersRef = dbRef.child("users")
        postRef = dbRef.child("posts")
    }
    private var dbRef: DatabaseReference!
    private var usersRef: DatabaseReference!
    private var postRef: DatabaseReference!
    
    public func getDbRef()-> DatabaseReference { return dbRef }
    public func getUsersRef()-> DatabaseReference { return usersRef }
    public func getPostsRef()-> DatabaseReference { return postRef }
    
    public func addPost(comment: String, image: UIImage) {
        let childByAutoId = DBService.manager.getPostsRef().childByAutoId()
        let newPost = Post(imageURL: "", comment: comment, userId: Auth.auth().currentUser?.uid)
        let dict = newPost.toJosn()
        childByAutoId.setValue(dict) { (error, dbRef) in
            if let error = error {
                print("addJob error: \(error)")
            } else  {
                print("database reference: \(dbRef)")
                // add an image to storage
                StorageService.manager.storeImage(image: image, postId: childByAutoId.key)
            }
        }
        
    }
    public func getPosts(completionHandler: @escaping ([Post]?, Error?) -> Void) {
        DBService.manager.getPostsRef().observe(.value) { (snapshot) in
            guard let childSnapShots = snapshot.children.allObjects as? [DataSnapshot] else {
                completionHandler(nil, AppError.invalidChildren)
                return
            }
            var posts = [Post]()
            for childSnapshot in childSnapShots {
                guard let rawJson = childSnapshot.value else {continue}
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: rawJson, options: [])
                    let post = try JSONDecoder().decode(Post.self, from: jsonData)
                    posts.append(post)
                } catch {
                    print(error)
                }
            }
            completionHandler(posts, nil)
        }
    }
    
    
}









