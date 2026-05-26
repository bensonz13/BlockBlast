//
//  TicTacToeGameView.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//

import SwiftUI

struct TicTacToeGameView: View {
    @StateObject private var viewModel = TicTacToeViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @State private var animateWinner = false

    var body: some View {
        ZStack {
            Theme.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Tic Tac Toe")
                    .font(.largeTitle.bold())
                    .foregroundColor(Theme.textPrimary)
                    .shadow(color: .primary.opacity(0.1), radius: 2, y: 1)

                if let winner = viewModel.winner {
                    Text(winner == "Tie" ? "It's a Tie!" : "\(winner) Wins!")
                        .font(.system(.title, design: .rounded).bold())
                        .foregroundColor(Theme.textPrimary)
                        .scaleEffect(animateWinner ? 1.1 : 1.0)
                        .onAppear { withAnimation(.easeInOut(duration: 0.6).repeatForever()) { animateWinner = true } }
                        .onDisappear { animateWinner = false }
                } else {
                    Text("\(viewModel.currentPlayer)'s Turn")
                        .font(.title2)
                        .foregroundColor(Theme.textSecondary)
                }

                VStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: 6) {
                            ForEach(0..<3, id: \.self) { col in
                                Button {
                                    withAnimation { viewModel.makeMove(row: row, col: col) }
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Theme.ticTacToeButton)
                                            .shadow(color: .black.opacity(0.1), radius: 3, y: 1)
                                        if viewModel.board[row][col] != "" {
                                            Text(viewModel.board[row][col])
                                                .font(.system(size: 48, weight: .heavy, design: .rounded))
                                                .foregroundColor(viewModel.board[row][col] == "X" ? Theme.ticTacToeX : Theme.ticTacToeO)
                                                .transition(.scale.combined(with: .opacity))
                                        }
                                    }
                                }
                                .disabled(viewModel.gameOver || !viewModel.board[row][col].isEmpty)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                Button {
                    withAnimation { viewModel.resetGame() }
                } label: {
                    Text("Restart")
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Theme.ticTacToeButton))
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                }
                .padding(.top, 10)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Tic Tac Toe")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
            }
        }
    }
}
