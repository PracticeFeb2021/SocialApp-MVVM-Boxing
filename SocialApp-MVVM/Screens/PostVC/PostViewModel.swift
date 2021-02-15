//
//  PostViewModel.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit


protocol PostViewModelP: class {

    //MARK: Outputs

    var didUpdateUser: ((User) -> Void)? {get set}
    var didUpdatePost: ((Post) -> Void)? {get set}
    var didUpdateComments: (([Comment]) -> Void)? {get set}
    
    var post: Post! {get set}
    var comments: [Comment] {get}
    var user: User! {get}
    
    //MARK: Inputs
    
    func ready()
}

class PostViewModel: PostViewModelP {
    
    //MARK: - Outputs
    
    var didUpdateUser: ((User) -> Void)?
    var didUpdatePost: ((Post) -> Void)?
    var didUpdateComments: (([Comment]) -> Void)?
    
    var post: Post! {
        didSet {
            didUpdatePost?(post)
        }
    }
    private(set) var comments: [Comment] = [Comment]() {
        didSet {
            didUpdateComments?(comments)
        }
    }
    private(set) var user: User! {
        didSet {
            didUpdateUser?(user)
        }
    }
    
    //MARK: - Inputs
    
    func ready() {
        loadUser(with: post.userId)
        loadComments(forPostWithID: post.id)
    }
   
    //MARK: - Dependencies
    
    let netService: NetworkingService
    
    init(_ netService: NetworkingService) {
        self.netService = netService
    }
    
    //MARK: - Private
    
    private func loadUser(with id: Int) {
        netService.loadUsers { users in
            guard let user = users?.first(where: {
                $0.id == id
            }) else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.user = user
            }
        }
    }
    
    private func loadComments(forPostWithID id: Int) {
        netService.loadComments { newComments in
            guard let comments = newComments else {
                print("INFO: No comments received from network")
                return
            }
            let commentsForPost = comments.filter {
                $0.postId == id
            }
            print("INFO: found \(commentsForPost.count) comments for this post")
            
            DispatchQueue.main.async { [weak self] in
                self?.comments = commentsForPost
            }
        }
    }
    
}

