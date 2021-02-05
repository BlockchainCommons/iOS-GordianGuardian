//
//  ModelObject.swift
//  Gordian Guardian
//
//  Created by Wolf McNally on 12/15/20.
//

import SwiftUI
import LifeHash
import URKit

struct ModelSubtype: Identifiable, Hashable {
    var id: String
    var icon: AnyView
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: ModelSubtype, rhs: ModelSubtype) -> Bool {
        lhs.id == rhs.id
    }
}

protocol ModelObject: Fingerprintable, Identifiable, ObservableObject, Equatable {
    var modelObjectType: ModelObjectType { get }
    var name: String { get set }
    var ur: UR { get }
    var id: UUID { get }
    var subtypes: [ModelSubtype] { get }
    var instanceDetail: String? { get }
}

extension ModelObject {
    var subtypes: [ModelSubtype] { [] }
    var instanceDetail: String? { nil }
}