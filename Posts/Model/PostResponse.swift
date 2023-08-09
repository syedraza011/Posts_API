//
//  PostResponse.swift
//  Posts
//
//  Created by Syed Raza on 6/19/23.
//

import Foundation
struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
