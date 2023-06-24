//
//  ContentView.swift
//  Posts
//
//  Created by Syed Raza on 6/19/23.
//
import SwiftUI
struct ContentView: View {

    @StateObject var viewModel = PostViewModel()
    @State private var sortBy: SortOption = .postID
    @State private var searchQuery: String = ""

    var sortedAndFilteredPosts: [Post] {
        let sortedPosts = sortedPostsBasedOnSortOption()

        if searchQuery.isEmpty {
            return sortedPosts
        } else {
            let lowercaseQuery = searchQuery.lowercased()
            return sortedPosts.filter { post in
                if sortBy == .postID {
                    return "\(post.id)".lowercased() == lowercaseQuery
                } else {
                    return "\(post.userId)".lowercased() == lowercaseQuery
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Sort By:", selection: $sortBy) {
                    Text("Post ID").tag(SortOption.postID)
                    Text("User ID").tag(SortOption.userID)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TextField("Search by Post ID or User ID", text: $searchQuery)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal)

                List(sortedAndFilteredPosts, id: \.id) { post in
                    NavigationLink(destination: PostDetailsView(post: post)) {
                        VStack(alignment: .leading, spacing: 4) {
                            if sortBy == .postID {
                                Text("Post ID: \(post.id)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Text(post.title)
                                    .foregroundColor(.primary)
                            } else {
                                Text("User ID: \(post.userId)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Text(post.title)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(background(for: post.userId))
                    .cornerRadius(20)
                }
            }
            .navigationTitle("Posts")
            .onAppear {
                viewModel.useAsyncAwait()
            }
        }
    }

    func sortedPostsBasedOnSortOption() -> [Post] {
        switch sortBy {
        case .postID:
            return viewModel.posts.sorted { $0.id < $1.id }
        case .userID:
            return viewModel.posts.sorted { $0.userId > $1.userId }
        }
    }

    func background(for userId: Int) -> Color {
        // Customize the background color based on the user ID
        let colors: [Color] = [.blue, .green, .yellow, .orange, .purple]
        let index = userId % colors.count
        return colors[index]
    }
}

enum SortOption {
    case postID
    case userID
}

struct PostDetailsView: View {
    let post: Post

    var body: some View {
        VStack {
            Text("Post Details")
                .font(.title)
                .foregroundColor(.primary)
                .padding()

            VStack(alignment: .leading, spacing: 8) {
                Text("User ID: \(post.userId)")
                    .font(.headline)
                    .foregroundColor(.black)
                Text("Post ID: \(post.id)")
                    .font(.headline)
                    .foregroundColor(.black)
                Text("Title:")
                    .font(.headline)
                    .foregroundColor(.black)

                Text(post.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)

               

//struct ContentView: View {
//
//    @StateObject var viewModel = PostViewModel()
//    @State private var sortBy: SortOption = .postID
//    @State private var searchQuery: String = ""
//
//    var sortedAndFilteredPosts: [Post] {
//        let sortedPosts = sortedPostsBasedOnSortOption()
//
//        if searchQuery.isEmpty {
//            return sortedPosts
//        } else {
//            let lowercaseQuery = searchQuery.lowercased()
//            return sortedPosts.filter { post in
//                if sortBy == .postID {
//                    return "\(post.id)".lowercased() == lowercaseQuery
//                } else {
//                    return "\(post.userId)".lowercased() == lowercaseQuery
//                }
//            }
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Picker("Sort By:", selection: $sortBy) {
//                    Text("Post ID").tag(SortOption.postID)
//                    Text("User ID").tag(SortOption.userID)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//
//                TextField("Search by Post ID or User ID", text: $searchQuery)
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(10)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.gray, lineWidth: 1)
//                    )
//                    .padding(.horizontal)
//
//                List(sortedAndFilteredPosts, id: \.id) { post in
//                    NavigationLink(destination: PostDetailsView(post: post)) {
//                        VStack(alignment: .leading, spacing: 4) {
//                            if sortBy == .postID {
//                                Text("Post ID: \(post.id)")
//                                    .font(.subheadline)
//                                    .foregroundColor(.white)
//                                Text(post.title)
//                                    .foregroundColor(.primary)
//                            } else {
//                                Text("User ID: \(post.userId)")
//                                    .font(.subheadline)
//                                    .foregroundColor(.white)
//                                Text(post.title)
//                                    .foregroundColor(.primary)
//                            }
//                        }
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    .padding()
//                    .background(background(for: post.userId))
//                    .cornerRadius(20)
//                }
//            }
//            .navigationTitle("Posts")
//            .onAppear {
////                viewModel.getPosts()
//                viewModel.useAsyncAwait()
//            }
//        }
//    }
//
//    func sortedPostsBasedOnSortOption() -> [Post] {
//        switch sortBy {
//        case .postID:
//            return viewModel.posts.sorted { $0.id < $1.id }
//        case .userID:
//            return viewModel.posts.sorted { $0.userId > $1.userId }
//        }
//    }
//
//    func background(for userId: Int) -> Color {
//        // Customize the background color based on the user ID
//        let colors: [Color] = [.blue, .green, .yellow, .orange, .purple]
//        let index = userId % colors.count
//        return colors[index]
//    }
//}
//
//enum SortOption {
//    case postID
//    case userID
//}
//
//struct PostDetailsView: View {
//    let post: Post
//
//    var body: some View {
//        VStack {
//            Text("Post Details")
//                .font(.title)
//                .foregroundColor(.primary)
//                .padding()
//
//            VStack(alignment: .leading, spacing: 8) {
//
//                Text("userID: \(post.userId)")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                Text("postID: \(post.id)")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                Text("Title:")
//                    .font(.headline)
//                    .foregroundColor(.black)
//
//                Text(post.title)
//                    .font(.subheadline)
//                    .foregroundColor(.primary)
//
                Text("Body:")
                    .font(.headline)
                    .foregroundColor(.black)

                Text(post.body)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding()

            Spacer()
        }
        .navigationTitle("Details")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


