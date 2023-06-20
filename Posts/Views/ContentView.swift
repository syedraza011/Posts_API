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
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(post.id)")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Text(post.title)
                                .foregroundColor(.primary)
                            Text(post.body)
                                .foregroundColor(.primary)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//struct ContentView: View {
//    @StateObject var viewModel = PostViewModel()
//    var body: some View {
////        NavigationView {
////            VStack {
//                List (viewModel.posts){ post in
////                    VStack(alignment: .leading, spacing: 4) {
////                        HStack {
//                            Text("\(post.id)")
//                                .font(.subheadline)
//                                .foregroundColor(.black )
//                            Text(post.title)
//                                .foregroundColor(.primary)
//                            Text(post.body)
//                                .foregroundColor(.primary)
//                        }
//                    }
////                    .padding()
//                }
////            }
////        }
////    }
////}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
