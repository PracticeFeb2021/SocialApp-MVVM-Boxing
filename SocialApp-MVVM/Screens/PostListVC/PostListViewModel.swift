//
//  PostListViewModel.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit


protocol PostListViewModelP: class {

    //MARK: Outputs

    var didSelectPost: ((Post) -> Void)? {get set}
    
    var didUpdatePosts: (() -> Void)? {get set}

    var posts: [Post] {get}
    
    //MARK: Inputs

    func ready()
    
    func didSelectRow(at indexPath: IndexPath)
}


class PostListViewModel: PostListViewModelP { 
         
    //MARK: - Outputs
    
    var didSelectPost: ((Post) -> Void)?
    
    var didUpdatePosts: (() -> Void)?
    
    private(set) var posts: [Post] = [Post]() {
        didSet {
            didUpdatePosts?()
        }
    }
    
    //MARK: - Inputs
    
    func ready() {
        netService.loadPosts { posts in
            guard let posts = posts else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.posts = posts
            }
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        didSelectPost?(posts[indexPath.row])
    }
    
    //MARK: - Dependencies
    
    let netService: NetworkingService
    
    init(_ netService: NetworkingService) {
        self.netService = netService
    }
}

