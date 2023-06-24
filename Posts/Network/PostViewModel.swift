//
//  PostViewModel.swift
//  Posts
//
//  Created by Syed Raza on 6/19/23.
//

import Foundation
import Combine
class PostViewModel: ObservableObject {
    @Published var sectionPosts = [SectionData]()
    @Published var posts = [Post]()
    let service = PostService()

    @MainActor func useAsyncAwait() {
        Task {
            do {
                self.posts = try await service.fetchPostUsingAsyncAwait()
                self.sectionPosts = self.processPosts(posts, userID: "your_user_id")
            } catch {
                if let error = error as? APIError {
                    print(error.description)
                } else {
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func processPosts(_ posts: [Post], userID: String) -> [SectionData] {
        let sectionData = SectionData(userID: userID, posts: posts)
        return [sectionData]
    }
}

//    func getPosts() {
//        service.fetchPosts()
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }, receiveValue: { [weak self] posts in
//                self?.posts = posts
//            })
//            .store(in: &cancelable)
//    }
//}
