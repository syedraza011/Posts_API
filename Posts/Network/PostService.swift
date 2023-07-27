//
//  PostsService.swift
//  PostsDemo
//
//  Created by Syed Raza on 6/22/23.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidUrl
    case invalidResponse
    case emptyData
    case serviceUnavailable
    case decodingError
    
    var description: String {
        switch self {
        case .invalidUrl:
            return "invalid url"
        case .invalidResponse:
            return "invalid response"
        case .emptyData:
            return "empty data"
        case .serviceUnavailable:
            return "service unavailable"
        case .decodingError:
            return "decoding error"
        }
    }
}

protocol PostsServiceProtocol {
    func fetchPostsUsingAsyncAwait() async throws -> [Post]
    func fetchPosts() -> Future<[Post], Error>
}

class PostsService: PostsServiceProtocol {
    
    struct Constants {
        static let baseURL = "https://jsonplaceholder.typicode.com/posts"
    }
    
    var cancellables = Set<AnyCancellable>()
    
    // Using Async await for GET call
    func fetchPostsUsingAsyncAwait() async throws -> [Post] {
        guard let url = URL(string: Constants.baseURL) else { throw APIError.invalidUrl }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let resp = response as? HTTPURLResponse, 200...299 ~= resp.statusCode else {
            throw APIError.invalidResponse
        }
        return try JSONDecoder().decode([Post].self, from: data)
    }
    
    // Using Future for GET call
    func fetchPosts() -> Future<[Post], Error> {
        return Future {[weak self] promise in
            guard let self = self, let url = URL(string: Constants.baseURL) else {
                promise(.failure(APIError.invalidUrl))
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [Post].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let err):
                        promise(.failure(err))
                    case .finished:
                        break
                    }
                } receiveValue: { posts in
                    promise(.success(posts))
                }
                .store(in: &self.cancellables)
        }
    }
    
    // Using Async await and POST call
    func addPost(_ postData: PostData) async throws -> Post {
        guard let url = URL(string: Constants.baseURL) else {
            throw APIError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(postData)
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let resp = (response as? HTTPURLResponse), resp.statusCode == 201 else {
            throw APIError.serviceUnavailable
        }

        if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
        }
        
        return try JSONDecoder().decode(Post.self, from: data)
    }
    
    // Using generics and Async await
    func fetchPostsAsyncAwait<T: Decodable>() async throws -> T {
        guard let url = URL(string: Constants.baseURL) else {
            throw APIError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    
}

