//
//  PostService.swift
//  Posts
//
//  Created by Syed Raza on 6/19/23.
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
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .emptyData:
            return "Invalid URL"
        case .serviceUnavailable:
            return "Service Not Available"
        case .decodingError:
            return "Decoding Error"
        }
    }
}

class PostService {
    var cancelable = Set<AnyCancellable>()
    let urlString = "https://jsonplaceholder.typicode.com/posts"
    
    func fetchPostUsingAsyncAwait() async throws -> [Post] {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let resp = response as? HTTPURLResponse, resp.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([Post].self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}



//    func fetchPosts() -> Future<[Post], Error> {
//        return Future<[Post], Error> { promise in
//            guard let url = URL(string: self.urlString) else {
//                let error = NSError(domain: "InvalidURL", code: 0, userInfo: nil)
//                promise(.failure(error))
//                return
//            }
//
//            URLSession.shared.dataTaskPublisher(for: url)
//                .map(\.data)
//                .decode(type: [Post].self, decoder: JSONDecoder())
//                .receive(on: DispatchQueue.main)
//                .sink(receiveCompletion: { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        promise(.failure(error))
//                    }
//                }, receiveValue: { response in
//                    promise(.success(response))
//            })
//                .store(in: &self.cancelable)
//        } //ending return
//
//    }// ending fetch post
//
//} // Ending class


