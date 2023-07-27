//
//  PostsViewModel.swift
//  PostsDemo
//
//  Created by Syed Raza on 6/22/23.
//

import Foundation
import Combine

struct SectionData: Identifiable {
    let id = UUID()
    let userId: String
    let posts: [Post]
}

struct PostData: Codable {
    let userId: Int
    let body: String
    let title: String
}

final class PostsViewModel: ObservableObject {
    @Published var sectionPosts = [SectionData]()
    @Published var state: AsyncState = .initial
    
    var cancellables = Set<AnyCancellable>()
    
    let service: PostsServiceProtocol
    
    init(service: PostsServiceProtocol = PostsService()) {
        self.service = service
        Task {
            await getPostsAsyncAwait()
        }
    }
    
    @MainActor func getPostsAsyncAwait() {
        state = .loading
        Task {
            do {
                let posts: [Post] = try await service.fetchPostsUsingAsyncAwait()
                self.sectionPosts = self.processPosts(posts)
                state = .loaded
            } catch {
                if let error = error as? APIError {
                   print(error.description)
                } else {
                    print(error.localizedDescription)
                }
                state = .error
            }
        }
    }
 
    // Example of a POST call
//    @MainActor func addPost() {
//        Task {
//            do {
//                let post: Post = try await service.addPost(PostData(userId: 1, body: "Post body test", title: "Post title test"))
//                print("post = \(post)")
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func getPosts() {
        service.fetchPosts()
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("err during fetching posts = \(err.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: {[weak self] posts in
                self?.sectionPosts = self?.processPosts(posts) ?? []
            }
            .store(in: &cancellables)
    }
    
    private func processPosts(_ posts: [Post]) -> [SectionData] {
        var currentUser = ""
        var postArr = [Post]()
        var sectionDataArr = [SectionData]()
        
        for ele in posts {
            if currentUser.isEmpty {
                currentUser = "\(ele.userId)"
            }
            
            if String(ele.userId) == currentUser {
                postArr.append(ele)
            } else {
                let sectionData = SectionData(userId: currentUser, posts: postArr)
                sectionDataArr.append(sectionData)
                currentUser = ""
                postArr = []
            }
        }
        return sectionDataArr
    }
    
    
}

