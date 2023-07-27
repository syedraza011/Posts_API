//
//  PostResponse.swift
//  Posts
//
//  Created by Syed Raza on 6/19/23.
//

import Foundation
struct Post: Decodable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
let mock = Post(userId: 1, id: 1,
                title: "ea molestias quasi exercitationem repellat qui ipsa sit aut",
                body: "et iusto sed quo iure\nvoluptatem occaecati omnis eligendi aut ad\nvoluptatem doloribus vel accusantium quis pariatur\nmolestiae porro eius odio et labore et velit aut"
    )

struct SectionData : Identifiable {
    let id = UUID ()
    let userID: String
    let posts: [Post]
}
