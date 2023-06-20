//
//  PostService.swift
//  Posts
//
//  Created by Syed Raza on 6/19/23.
//

import Foundation
import Combine

class PostService {
    var cancelable = Set <AnyCancellable>()
    let urlString = "https://jsonplaceholder.typicode.com/posts"
    
    func fetchPosts () -> Future<[Post], Error> {
        return Future <[Post], Error> {
            promise in
            guard let url = URL(string: self.urlString) else {
                let error = NSError(domain: "InvalidURL", code: 0, postInfo: nil)
                promise(.failure (error))
                return
            }
            URL.session.shared.data(for: url)
                .map{$0.data}
                .decode(type: [Post].self, Decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink (receiveCompletion: {completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure (let error):
                        promise (.failure(error))
                    }
                
                    }, receiveValue: { response in
                        promise (.success(response))
                })
                .store(in: &self.cancelable)
        }
    }
}
