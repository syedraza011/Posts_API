//
//  PostDemoTest.swift
//  PostsUITests
//
//  Created by Syed Raza on 7/27/23.
//

import XCTest

@testable import Posts
import Combine

enum FileName: String {
    case postsFailure, postsSuccess
}

final class PostsDemoTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables = []
    }
    
    func test_getPostsAsyncAwait_should_succeed() async throws {
        let viewModel = PostsViewModel(service: MockPostsService(fileName: .postsSuccess))
        
        // Expectation: The sectionPosts should be populated correctly
        // Set up any necessary mock objects or data
        let expectation = XCTestExpectation(description: "Posts fetched successfully")
        
        // Call the function being tested
        await viewModel.getPostsAsyncAwait()
        
        // Assert the expected results
        viewModel.$sectionPosts
            .dropFirst() // Skip initial value
            .sink { sectionPosts in
                // Perform your assertions on the sectionPosts here
                XCTAssertFalse(sectionPosts.isEmpty, "sectionPosts should not be empty")
                let firstSection = sectionPosts.first!
                XCTAssertEqual(firstSection.posts.first!.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
                // Fulfill the expectation
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Wait for the expectation to be fuzMoclfilled
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func test_getPostsUsingFuture_should_succeed() {
        let viewModel = PostsViewModel(service: MockPostsService(fileName: .postsSuccess))
        
        let exp = XCTestExpectation(description: "fetch posts should succeed")
        
        viewModel.getPosts()
        
        viewModel.$sectionPosts
            .sink { sectionPosts in
                XCTAssertFalse(sectionPosts.isEmpty, "sectionPosts should not be empty")
                let firstSection = sectionPosts.first!
                XCTAssertEqual(firstSection.posts.first!.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
                // Fulfill the expectation
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_getPostsUsingAsyncAwait_should_fail() async throws {
        let viewModel = PostsViewModel(service: MockPostsService(fileName: .postsFailure))
        
        let exp = XCTestExpectation(description: "fetch call should fail")
        
        await viewModel.getPostsAsyncAwait()
        
        viewModel.$sectionPosts
            .sink { sectionPosts in
                XCTAssertTrue(sectionPosts.isEmpty)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 5.0)
    }
    
    func test_getPostsUsingFuture_should_fail() {
        let viewModel = PostsViewModel(service: MockPostsService(fileName: .postsFailure))
        
        let exp = XCTestExpectation(description: "fetch call should fail")
        
        viewModel.getPosts()
        
        viewModel.$sectionPosts
            .sink { sectionPosts in
                XCTAssertTrue(sectionPosts.isEmpty)
                exp.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [exp], timeout: 5.0)
    }

}

class MockPostsService: PostsServiceProtocol {
    
    let fileName: FileName
    
    init(fileName: FileName) {
        self.fileName = fileName
    }
    
    private func load(_ fileName: String) -> URL? {
        return Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json")
    }
    
    func fetchPostsUsingAsyncAwait() async throws -> [Posts.Post] {
        guard let url = load(fileName.rawValue) else { throw APIError.invalidUrl }
        
        let data = try! Data(contentsOf: url)
        do {
            let result = try JSONDecoder().decode([Post].self, from: data)
            return result
        } catch {
            return []
        }
        
    }
    
    func fetchPosts() -> Future<[Posts.Post], Error> {
        return Future {[weak self] promise in
            guard let self = self, let url = self.load(fileName.rawValue) else {
                promise(.failure(APIError.invalidUrl))
                return
            }
            
            let data = try! Data(contentsOf: url)
            
            do {
                let result = try JSONDecoder().decode([Post].self, from: data)
                promise(.success(result))
            } catch {
                promise(.failure(APIError.decodingError))
            }
        }
    }
    
    
}
