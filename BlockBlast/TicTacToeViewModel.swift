//
//  TicTacToeViewModel.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//

import SwiftUI
import Combine

@MainActor
class TicTacToeViewModel: ObservableObject {
    @Published var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @Published var currentPlayer = "X"
    @Published var winner: String? = nil
    @Published var gameOver = false

    func makeMove(row: Int, col: Int) {
        guard board[row][col].isEmpty, !gameOver else { return }
        board[row][col] = currentPlayer
        if checkWin(player: currentPlayer) {
            winner = currentPlayer
            gameOver = true
        } else if board.allSatisfy({ row in row.allSatisfy { !$0.isEmpty } }) {
            winner = "Tie"
            gameOver = true
        } else {
            currentPlayer = currentPlayer == "X" ? "O" : "X"
        }
    }

    private func checkWin(player: String) -> Bool {
        for i in 0..<3 {
            if board[i][0] == player, board[i][1] == player, board[i][2] == player { return true }
            if board[0][i] == player, board[1][i] == player, board[2][i] == player { return true }
        }
        if board[0][0] == player, board[1][1] == player, board[2][2] == player { return true }
        if board[0][2] == player, board[1][1] == player, board[2][0] == player { return true }
        return false
    }

    func resetGame() {
        board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        currentPlayer = "X"
        winner = nil
        gameOver = false
    }
}
