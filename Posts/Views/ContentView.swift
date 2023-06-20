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
                                        Text("Post ID: \(post.id)")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                        Text(post.title)
                                            .foregroundColor(.primary)
                                        Text(post.body)
                                            .foregroundColor(.primary)
                                    }
                                   
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(20)
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


