//
//  SinglePostCell.swift
//  Posts
//
//  Created by Syed Raza on 6/19/23.
//

import SwiftUI

struct SinglePostCell: View {
    let post: Post
    var body: some View {
        VStack {
            Text("Single Post")
                .font(.title)
                .foregroundColor(.primary)
                .padding()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("postID: \(post.id)")
                    .font(.headline)
                    .foregroundColor(.black)
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
            .background(Color.gray)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding()
            
            Spacer()
        }
     
    }

    
}
struct SinglePostCell_Previews: PreviewProvider {
    static var previews: some View {
        let mockPost = Post(userId: 1, id: 1,
                        title: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
                        body: "et iusto sed quo iure\nvoluptatem occaecati omnis eligendi aut ad\nvoluptatem doloribus vel accusantium quis pariatur\nmolestiae porro eius odio et labore et velit aut"
            )
       return  SinglePostCell(post : mockPost)
    }
}
