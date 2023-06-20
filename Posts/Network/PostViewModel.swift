//
//  PostViewModel.swift
//  Posts
//
//  Created by Syed Raza on 6/19/23.
//

import Foundation
import Combine
class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    var cancelable = Set<AnyCancellable>()
    let service = PostService()
    
    func getPosts() {
        service.fetchPosts()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] posts in
                self?.posts = posts
            })
            .store(in: &cancelable)
    }
}
