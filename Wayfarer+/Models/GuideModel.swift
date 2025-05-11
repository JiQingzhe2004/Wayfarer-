//
//  GuideModel.swift
//  Wayfarer+
//
//  Created by Trae AI on 2025/5/10.
//

import Foundation

// 攻略模型
struct Guide: Identifiable {
    var id: Int
    var title: String
    var content: String
    var city: String
    var attractions: [Attraction]
    var tags: [String]
    var usageCount: Int
    var author: Author
    var createdAt: Date
    
    // 用于预览的示例数据
    static let example = Guide(
        id: 1,
        title: "巴黎三日游攻略",
        content: "这是一份详细的巴黎三日游攻略，包含了卢浮宫、埃菲尔铁塔、凯旋门等著名景点的参观建议，以及当地美食推荐和交通指南。",
        city: "Paris",
        attractions: [
            Attraction(name: "卢浮宫", coordinates: Coordinates(lat: 48.8606, lng: 2.3376)),
            Attraction(name: "埃菲尔铁塔", coordinates: Coordinates(lat: 48.8584, lng: 2.2945)),
            Attraction(name: "凯旋门", coordinates: Coordinates(lat: 48.8738, lng: 2.2950))
        ],
        tags: ["美食", "文化"],
        usageCount: 1234,
        author: Author(id: 1, username: "旅行达人"),
        createdAt: Date()
    )
}

// 景点模型
struct Attraction {
    var name: String
    var coordinates: Coordinates
}

// 坐标模型
struct Coordinates {
    var lat: Double
    var lng: Double
}

// 作者模型
struct Author {
    var id: Int
    var username: String
}

// 用户攻略状态枚举
enum TravelStatus: String {
    case pending = "未开始"
    case ongoing = "进行中"
    case completed = "已完成"
}

// 用户攻略模型
struct UserGuide: Identifiable {
    var id: Int
    var guide: Guide
    var status: TravelStatus
    var createdAt: Date
    
    // 用于预览的示例数据
    static let examples = [
        UserGuide(
            id: 1,
            guide: Guide.example,
            status: .pending,
            createdAt: Date()
        ),
        UserGuide(
            id: 2,
            guide: Guide.example,
            status: .ongoing,
            createdAt: Date()
        ),
        UserGuide(
            id: 3,
            guide: Guide.example,
            status: .completed,
            createdAt: Date()
        )
    ]
}

// 用户模型
struct User {
    var id: Int
    var username: String
    var email: String
    var avatarUrl: String?
    var bio: String?
    var publishedGuides: Int
    var completedTravels: Int
}