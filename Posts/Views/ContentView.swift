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

    var sortedPosts: [Post] {
        switch sortBy {
        case .postID:
            return viewModel.posts.sorted { $0.id < $1.id }
        case .userID:
            return viewModel.posts.sorted { $0.userId > $1.userId }
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

                List(sortedPosts, id: \.id) { post in
                    NavigationLink(destination: PostDetailsView(post: post)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("User ID: \(post.userId)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text("Post ID: \(post.id)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text(post.title)
                                .foregroundColor(.primary)
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
                viewModel.getPosts()
            }
        }
    }

    func background(for userId: Int) -> Color {
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
                Text("userID: \(post.userId)")
                    .font(.headline)
                    .foregroundColor(.black)

                Text("Title:")
                    .font(.headline)
                    .foregroundColor(.black)

                Text(post.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)

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


