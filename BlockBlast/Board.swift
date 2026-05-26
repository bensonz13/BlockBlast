//
//  Board.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//


import Foundation

struct Board: Codable {
    static let rows = 8
    static let cols = 8
    private(set) var grid: [[Int]]

    init() {
        grid = Array(repeating: Array(repeating: 0, count: Self.cols), count: Self.rows)
    }

    func place(piece: Piece, at origin: (row: Int, col: Int)) -> (board: Board, linesCleared: Int)? {
        var newBoard = self
        // Check fit
        for (dr, dc) in piece.shape {
            let r = origin.row + dr
            let c = origin.col + dc
            guard r >= 0, r < Self.rows, c >= 0, c < Self.cols, newBoard.grid[r][c] == 0 else {
                return nil
            }
        }

        for (dr, dc) in piece.shape {
            newBoard.grid[origin.row + dr][origin.col + dc] = piece.colorIndex
        }

        var linesCleared = 0

        var rowsToClear = [Int]()
        for r in 0..<Self.rows {
            if newBoard.grid[r].allSatisfy({ $0 != 0 }) {
                rowsToClear.append(r)
            }
        }

        var colsToClear = [Int]()
        for c in 0..<Self.cols {
            let colFull = (0..<Self.rows).allSatisfy { newBoard.grid[$0][c] != 0 }
            if colFull { colsToClear.append(c) }
        }
        linesCleared = rowsToClear.count + colsToClear.count

        for r in rowsToClear {
            newBoard.grid[r] = Array(repeating: 0, count: Self.cols)
        }

        for c in colsToClear {
            for r in 0..<Self.rows {
                newBoard.grid[r][c] = 0
            }
        }
        return (newBoard, linesCleared)
    }

    func canPlaceAny(_ pieces: [Piece]) -> Bool {
        for piece in pieces {
            for r in 0..<Self.rows {
                for c in 0..<Self.cols {
                    if place(piece: piece, at: (r, c)) != nil {
                        return true
                    }
                }
            }
        }
        return false
    }

    var json: String {
        let data = try! JSONEncoder().encode(grid)
        return String(data: data, encoding: .utf8)!
    }

    static func from(json: String) -> Board {
        let data = json.data(using: .utf8)!
        let grid = try! JSONDecoder().decode([[Int]].self, from: data)
        var board = Board()
        board.grid = grid
        return board
    }
}
