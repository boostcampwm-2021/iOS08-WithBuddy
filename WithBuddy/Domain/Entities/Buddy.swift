//
//  Buddy.swift
//  WithBuddy
//
//  Created by 이나정 on 2021/11/02.
//

import Foundation

class Buddy: NSObject, NSCoding {
    
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
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.face, forKey: "face")
    }
    
    required init?(coder: NSCoder) {
        self.id = coder.decodeObject(forKey: "id") as? UUID ?? UUID()
        self.name = coder.decodeObject(forKey: "name") as? String ?? ""
        self.face = coder.decodeObject(forKey: "face") as? String ?? ""
    }
    
}

extension Buddy: Comparable {
    
    static func < (lhs: Buddy, rhs: Buddy) -> Bool {
        return lhs.name < rhs.name
    }
    
}
