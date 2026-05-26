//
//  BoardView.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//

import SwiftUI

struct BoardView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geo in
            let cellSize = min(geo.size.width / CGFloat(Board.cols),
                               geo.size.height / CGFloat(Board.rows))
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.boardBackground)
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)

                VStack(spacing: 0) {
                    ForEach(0..<Board.rows, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<Board.cols, id: \.self) { col in
                                Rectangle()
                                    .fill(cellColor(for: viewModel.board.grid[row][col]))
                                    .overlay(
                                        Rectangle()
                                            .strokeBorder(Theme.boardGridLine, lineWidth: 0.5)
                                    )
                                    .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))

                if let piece = viewModel.draggedPiece, let origin = viewModel.previewOrigin {
                    let isValid = viewModel.validDrop
                    ForEach(0..<piece.shape.count, id: \.self) { i in
                        let (dr, dc) = piece.shape[i]
                        let r = origin.row + dr
                        let c = origin.col + dc
                        if r >= 0, r < Board.rows, c >= 0, c < Board.cols {
                            Rectangle()
                                .fill(cellColor(for: piece.colorIndex).opacity(0.7))
                                .overlay(
                                    Rectangle()
                                        .strokeBorder(isValid ? Color.green : Color.red, lineWidth: 2.5)
                                )
                                .frame(width: cellSize, height: cellSize)
                                .position(x: CGFloat(c) * cellSize + cellSize/2,
                                          y: CGFloat(r) * cellSize + cellSize/2)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.boardFrame = geo.frame(in: .named("GameSpace"))
            }
            .onChange(of: geo.frame(in: .named("GameSpace"))) { newFrame in
                viewModel.boardFrame = newFrame
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    func cellColor(for index: Int) -> Color {
        guard index > 0, index <= Theme.boardCellColors.count else { return Theme.boardCellEmpty }
        return Theme.boardCellColors[index - 1]
    }
}
