//
//  ContentView.swift
//  PostsDemo
//
//  Created by Syed Raza on 6/22/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PostsViewModel()
    var body: some View {
        NavigationStack {
            
            switch viewModel.state {
            case .initial:
                Text("Displaying the posts")
            case .loading:
                Text("Loading...")
            case .loaded:
                loadPosts()
            case .error:
                Text("Sorry! something went wrong..")
            }
        }
        .font(.body).bold()
    }
    
    private func loadPosts() -> some View {
        VStack {
            List(viewModel.sectionPosts) { section in
                
                Section(header: Text("user \(section.userId)")) {
                    ForEach(section.posts) { post in
                        
                        postCell(post)
                        
                    }
                }
            }
            .navigationTitle("Posts")
            .background(.black)
            .foregroundColor(.green)
        }
        
    }
    
    private func postCell(_ post: Post) -> some View {
        VStack {
            Text(post.title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

