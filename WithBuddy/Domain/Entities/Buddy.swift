//
//  Buddy.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/02.
//

import Foundation

struct Buddy: Hashable, Codable {
    
    var id: UUID
    var name: String
    var face: String
    var check: Bool?
    
    init(id: UUID, name: String, face: String, check: Bool? = nil) {
        self.id = id
        self.name = name
        self.face = face
        self.check = check
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case face
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.face, forKey: .face)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.face = try container.decode(String.self, forKey: .face)
    }
    
}

extension Buddy: Comparable {
    
    static func < (lhs: Buddy, rhs: Buddy) -> Bool {
        return lhs.name < rhs.name
    }
    
}
