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
        VStack (){
            Text("\(post.userId)")
                .font(.headline)
                .foregroundColor(.blue)
                .fontWeight(.bold)
            Text("\(post.id)")
                .font(.headline)
                .foregroundColor(.blue)
                .fontWeight(.bold)
            Text(post.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text(post.body)
                .font(.subheadline)
                .foregroundColor(.secondary)
         
   
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
