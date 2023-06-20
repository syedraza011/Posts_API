//
//  ContentView.swift
//  Posts
//
//  Created by Syed Raza on 6/19/23.
//
import SwiftUI
struct ContentView: View {
    @StateObject var viewModel = PostViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.posts) { post in
                    NavigationLink(destination: PostDetailsView(post: post)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(post.id)")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Text(post.title)
                                .foregroundColor(.primary)
//                            Text(post.body)
//                                .foregroundColor(.primary)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Posts")
            .onAppear {
                viewModel.getPosts()
            }
        }
    }
}

struct PostDetailsView: View {
    let post: Post
    
    var body: some View {
        VStack {
            Text("Post Details")
                .font(.title)
                .foregroundColor(.primary)
                .padding()
            
            Text("ID: \(post.id)")
                .font(.subheadline)
                .foregroundColor(.black)
                .padding()
            
            Text("Title: \(post.title)")
                .foregroundColor(.primary)
                .padding()
            
            Text("Body: \(post.body)")
                .foregroundColor(.primary)
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


