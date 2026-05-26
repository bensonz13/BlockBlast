//
//  Piece.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//


import Foundation

struct Piece: Identifiable {
    let id = UUID()
    let shape: [(Int, Int)]
    let colorIndex: Int

    static let allTypes: [Piece] = [
        Piece(shape: [(0,0)], colorIndex: 1),
        Piece(shape: [(0,0),(0,1)], colorIndex: 2),
        Piece(shape: [(0,0),(1,0)], colorIndex: 2),
        Piece(shape: [(0,0),(0,1),(0,2)], colorIndex: 3),
        Piece(shape: [(0,0),(1,0),(2,0)], colorIndex: 3),
        Piece(shape: [(0,0),(0,1),(1,0),(1,1)], colorIndex: 4),
        Piece(shape: [(0,0),(1,0),(1,1)], colorIndex: 5),
        Piece(shape: [(0,1),(1,1),(1,0)], colorIndex: 5),
        Piece(shape: [(0,0),(0,1),(1,0)], colorIndex: 5),
        Piece(shape: [(0,0),(0,1),(1,1)], colorIndex: 5),
        Piece(shape: [(0,0),(0,1),(0,2),(1,1)], colorIndex: 1),
        Piece(shape: [(0,1),(0,2),(1,0),(1,1)], colorIndex: 2),
        Piece(shape: [(0,0),(0,1),(1,1),(1,2)], colorIndex: 2),
        Piece(shape: [(0,0),(0,1),(0,2),(0,3)], colorIndex: 3),
        Piece(shape: [(0,0),(1,0),(2,0),(3,0)], colorIndex: 3),
        Piece(shape: [(0,0),(1,0),(2,0),(2,1)], colorIndex: 4),
        Piece(shape: [(0,1),(1,1),(2,1),(2,0)], colorIndex: 4),
        Piece(shape: [(0,0),(0,1),(0,2),(1,0),(1,1),(1,2),(2,0),(2,1),(2,2)], colorIndex: 5)
    ]

    var typeIndex: Int {
        Self.allTypes.firstIndex(where: { $0.shape.elementsEqual(shape, by: ==) && $0.colorIndex == colorIndex }) ?? 0
    }

    static func piece(from index: Int) -> Piece {
        let type = allTypes[index]
        return Piece(shape: type.shape, colorIndex: type.colorIndex)
    }
}

extension Piece: Codable {
    enum CodingKeys: String, CodingKey {
        case shape, colorIndex
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        colorIndex = try container.decode(Int.self, forKey: .colorIndex)
        let shapeArray = try container.decode([[Int]].self, forKey: .shape)
        shape = shapeArray.map { ($0[0], $0[1]) }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(colorIndex, forKey: .colorIndex)
        let shapeArray = shape.map { [$0.0, $0.1] }
        try container.encode(shapeArray, forKey: .shape)
    }
}