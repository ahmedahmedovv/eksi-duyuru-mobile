//
//  Post.swift
//  EksiDuyuru
//

import Foundation

struct Post: Identifiable, Codable {
    let id: Int
    let title: String
    let content: String
    let author: String
    let commentCount: Int
    let createdAt: Date
    let url: String?
}

struct Comment: Identifiable, Codable {
    let id: Int
    let content: String
    let author: String
    let createdAt: Date
}
