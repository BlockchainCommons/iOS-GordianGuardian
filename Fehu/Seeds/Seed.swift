//
//  Seed.swift
//  Fehu
//
//  Created by Wolf McNally on 12/9/20.
//

import Foundation
import LifeHash
import SwiftUI
import URKit

final class Seed: Identifiable, ObservableObject, ModelObject {
    let id: UUID
    @Published var name: String { didSet { save() } }
    let data: Data
    @Published var note: String { didSet { save() } }

    static var modelObjectType: ModelObjectType { return .seed }

    init(id: UUID, name: String, data: Data, note: String = "") {
        self.id = id
        self.name = name
        self.data = data
        self.note = note
    }

    convenience init(name: String = "Untitled", data: Data, note: String = "") {
        self.init(id: UUID(), name: name, data: data, note: note)
    }

    convenience init() {
        self.init(data: SecureRandomNumberGenerator.shared.data(count: 16))
    }
}

extension Seed {
    var hex: String {
        data.hex
    }

    var ur: UR {
        var a: [(CBOR, CBOR)] = [
            (1, CBOR.byteString(data.bytes))
        ]

        if !name.isEmpty {
            a.append((3, CBOR.utf8String(name)))
        }

        if !note.isEmpty {
            a.append((4, CBOR.utf8String(note)))
        }

        let cbor = CBOR.orderedMap(a)

        return try! UR(type: "crypto-seed", cbor: cbor)
    }

    var urString: String {
        UREncoder.encode(ur)
    }
}

extension Seed: Saveable {
    static var saveType: String = "seed"
}

extension Seed: Codable {
    private enum CodingKeys: CodingKey {
        case id
        case name
        case data
        case note
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(data, forKey: .data)
        try container.encode(note, forKey: .note)
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let data = try container.decode(Data.self, forKey: .data)
        let note = try container.decodeIfPresent(String.self, forKey: .note) ?? ""
        self.init(id: id, name: name, data: data, note: note)
    }
}

extension Seed: Fingerprintable {
    var fingerprintData: Data { data }
}

extension Seed: Equatable {
    static func == (lhs: Seed, rhs: Seed) -> Bool {
        lhs.id == rhs.id
    }
}

extension Seed: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Seed: CustomStringConvertible {
    var description: String {
        "Seed(data: \(data.hex) name: \"\(name)\", note: \"\(note)\""
    }
}

import WolfLorem

extension Lorem {
    static func seed(count: Int = 16) -> Seed {
        Seed(name: Lorem.shortTitle(), data: Lorem.data(count))
    }

    static func seeds(_ count: Int) -> [Seed] {
        (0..<count).map { _ in seed() }
    }
}