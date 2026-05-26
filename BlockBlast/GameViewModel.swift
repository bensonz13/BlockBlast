//
//  GameViewModel.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//
import SwiftUI
import SwiftData
import Combine

@MainActor
class GameViewModel: ObservableObject {
    @Published var board: Board
    @Published var pieces: [Piece] = []
    @Published var score: Int = 0
    @Published var gameOver = false
    @Published var draggedPiece: Piece? = nil
    @Published var dragLocation: CGPoint = .zero
    @Published var previewOrigin: (row: Int, col: Int)? = nil
    @Published var validDrop = false
    @Published var boardFrame: CGRect = .zero
    @Published var streak: Int = 1
    @Published var highScore: Int = 0

    var modelContext: ModelContext
    private var savedGame: GameState?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        highScore = UserDefaults.standard.integer(forKey: "blockBlastHighScore")
        let fetch = FetchDescriptor<GameState>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        if let existing = try? modelContext.fetch(fetch).first {
            self.savedGame = existing
            self.board = Board.from(json: existing.boardData)
            let indices: [Int] = (try? JSONDecoder().decode([Int].self, from: existing.piecesData.data(using: .utf8)!)) ?? []
            self.pieces = indices.map { Piece.piece(from: $0) }
            self.score = existing.score
            self.streak = 1
        } else {
            self.board = Board()
            self.score = 0
            self.pieces = Self.randomPieces(count: 3)
            self.streak = 1
            saveState()
        }
        if !board.canPlaceAny(pieces) {
            gameOver = true
        }
    }

    func saveState() {
        let boardJSON = board.json
        let pieceIndices = pieces.map { $0.typeIndex }
        let piecesJSON = String(data: try! JSONEncoder().encode(pieceIndices), encoding: .utf8)!
        if let saved = savedGame {
            saved.boardData = boardJSON
            saved.piecesData = piecesJSON
            saved.score = score
            saved.date = Date()
        } else {
            let newState = GameState(boardData: boardJSON, piecesData: piecesJSON, score: score)
            modelContext.insert(newState)
            savedGame = newState
        }
        try? modelContext.save()
    }

    func updateDrag() {
        guard let piece = draggedPiece, boardFrame != .zero else {
            previewOrigin = nil
            validDrop = false
            return
        }
        let cellWidth = boardFrame.width / CGFloat(Board.cols)
        let cellHeight = boardFrame.height / CGFloat(Board.rows)
        let localX = dragLocation.x - boardFrame.minX
        let localY = dragLocation.y - boardFrame.minY
        let col = Int(localX / cellWidth)
        let row = Int(localY / cellHeight)
        guard let minRow = piece.shape.map({ $0.0 }).min(),
              let minCol = piece.shape.map({ $0.1 }).min() else { return }
        let originRow = row - minRow
        let originCol = col - minCol
        previewOrigin = (originRow, originCol)
        validDrop = board.place(piece: piece, at: (originRow, originCol)) != nil
    }

    func endDrag() {
        guard let piece = draggedPiece, let origin = previewOrigin, validDrop else {
            draggedPiece = nil
            previewOrigin = nil
            validDrop = false
            return
        }
        if let (newBoard, linesCleared) = board.place(piece: piece, at: origin) {
            board = newBoard
            if linesCleared > 0 {
                let comboMultiplier = min(linesCleared, 4)
                score += linesCleared * comboMultiplier * 10 * streak
                streak = min(streak + 1, 5)
            } else {
                streak = 1
            }
            if score > highScore {
                highScore = score
                UserDefaults.standard.set(highScore, forKey: "blockBlastHighScore")
            }
            pieces.removeAll { $0.id == piece.id }
        }
        draggedPiece = nil
        previewOrigin = nil
        validDrop = false
        if pieces.isEmpty {
            pieces = Self.randomPieces(count: 3)
        }
        if !board.canPlaceAny(pieces) {
            gameOver = true
        }
        saveState()
    }

    func resetGame() {
        board = Board()
        score = 0
        gameOver = false
        pieces = Self.randomPieces(count: 3)
        draggedPiece = nil
        streak = 1
        if !board.canPlaceAny(pieces) {
            gameOver = true
        }
        saveState()
    }

    static func randomPieces(count: Int) -> [Piece] {
        (0..<count).map { _ in
            let type = Piece.allTypes.randomElement()!
            return Piece(shape: type.shape, colorIndex: type.colorIndex)
        }
    }
}
