//
//  NetworkManager.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import Foundation



protocol NetworkingService {
    
    func loadPosts(_ completion: @escaping ([Post]?) -> ())
    
    func loadUsers(_ completion: @escaping ([User]?) -> ())
    
    func loadComments(_ completion: @escaping ([Comment]?) -> ())
}

class NetworkManager: NetworkingService {
    
    static let shared = NetworkManager()
    
    
    func loadPosts(_ completion: @escaping ([Post]?) -> ()) {
        load(.posts, completion)
    }
    
    func loadUsers(_ completion: @escaping ([User]?) -> ()) {
        load(.users, completion)
    }
    
    func loadComments(_ completion: @escaping ([Comment]?) -> ()) {
        load(.comments, completion)
    }
    
    
    //MARK: - private
    
    //TODO: error handling, NetErrorType model, return Result<T, NetErrorType> in completion
    private func load<T: Decodable>(_ endPoint: EndPoint,
                                    _ completion: @escaping (T?) -> ()) {
        
        let request = endPoint.makeURLRequest()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                
                completion(decodedData)
                
            } else {
                print("ERROR: failed to decode received data")
                print(data)
            }
        }.resume()
    }
}

