//
//  PostListViewModel.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit

class PostListViewModel { 
         
    //MARK: - Outputs
    
    var didSelectPost: ((Post) -> Void)?
    
    var posts = Box<[Post]>([])
    
    //MARK: - Inputs
    
    func ready() {
        netService.loadPosts { posts in
            guard let posts = posts else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.posts.value = posts
            }
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        didSelectPost?(posts.value[indexPath.row])
    }
    
    //MARK: - Dependencies
    
    let netService: NetworkingService
    
    init(_ netService: NetworkingService) {
        self.netService = netService
    }
}

