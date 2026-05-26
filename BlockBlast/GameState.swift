//
//  GameState.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//


import Foundation
import SwiftData

@Model
final class GameState {
    var id: UUID
    var boardData: String
    var piecesData: String
    var score: Int
    var date: Date

    init(boardData: String, piecesData: String, score: Int) {
        self.id = UUID()
        self.boardData = boardData
        self.piecesData = piecesData
        self.score = score
        self.date = Date()
    }
}
