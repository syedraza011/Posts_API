//
//  PostViewModelTests.swift
//  Posts
//
//  Created by Syed Raza on 7/15/23.
//

import Foundation

final class MockPosts: PostServiceProtocol {
    let fileName: FileName
    
    init( fileName: FileName) {
        self.fileName = fileName
    }
    func load (_ fileName: FileName)-> URL? {
        return Bundle (for: type(of: self).url(forResource: fileName.rawValue , withExtension: "json"))
    }
    func fetchPostAsyncAwait() async throws -> [PostsDemo.Post]{
        guard let url = load(fileName) else {throw APIError.invalidUrl}
        let data = try! Data (contentsOf: url)
        return try JSONDecoder()
    }
    func fetcposts()-> Future<[PostsDemo.Post], Error> {
        return Future {[weak self] promise in
            guard let self = self, let url = self.load (self.fileName) else {
                promise (.failure (APIError.invalidUrl))
                return
            }
            let data = try! Data (contentOf: url)
            do {
                let result = try JSONDecoder().decode([Post].self, from: data)
                promise (.sucess(result))
            }catch {
                promise(.failure (APIError.decodingError))
            }
        }
    
}
