//
//  PostViewModel.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit


class PostViewModel {
    
    //MARK: - Outputs
    
    var post: Box<Post?> = Box(nil)
    
    var comments = Box<[Comment]>([])
   
    var user: Box<User?> = Box(nil)
    
    //MARK: - Inputs
    
    func ready() {
        guard let post = post.value else {
            return
        }
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
                self?.user.value = user
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
                self?.comments.value = commentsForPost
            }
        }
    }
}

