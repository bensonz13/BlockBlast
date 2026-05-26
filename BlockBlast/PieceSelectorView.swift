//
//  PieceSelectorView.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//

import SwiftUI

struct PieceSelectorView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.colorScheme) var colorScheme
    let cellSize: CGFloat = 28

    var body: some View {
        HStack(spacing: 24) {
            ForEach(viewModel.pieces) { piece in
                PieceView(piece: piece, cellSize: cellSize)
                    .opacity(viewModel.draggedPiece?.id == piece.id ? 0.3 : 1.0)
                    .scaleEffect(viewModel.draggedPiece?.id == piece.id ? 0.9 : 1.0)
                    .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .named("GameSpace"))
                            .onChanged { value in
                                if viewModel.draggedPiece == nil {
                                    viewModel.draggedPiece = piece
                                }
                                viewModel.dragLocation = value.location
                                viewModel.updateDrag()
                            }
                            .onEnded { _ in
                                viewModel.endDrag()
                            }
                    )
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: viewModel.draggedPiece?.id)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        )
        .padding(.horizontal, 20)
    }
}

struct PieceView: View {
    let piece: Piece
    let cellSize: CGFloat

    var body: some View {
        let rows = (piece.shape.map { $0.0 }.max() ?? 0) + 1
        let cols = (piece.shape.map { $0.1 }.max() ?? 0) + 1
        VStack(spacing: 0) {
            ForEach(0..<rows, id: \.self) { r in
                HStack(spacing: 0) {
                    ForEach(0..<cols, id: \.self) { c in
                        if piece.shape.contains(where: { $0 == (r,c) }) {
                            Rectangle()
                                .fill(pieceColor(piece.colorIndex))
                                .overlay(
                                    Rectangle()
                                        .strokeBorder(Color.white.opacity(0.6), lineWidth: 0.8)
                                )
                                .frame(width: cellSize, height: cellSize)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: cellSize, height: cellSize)
                        }
                    }
                }
            }
        }
    }

    func pieceColor(_ index: Int) -> Color {
        guard index > 0, index <= Theme.pieceColors.count else { return Theme.pieceColors[0] }
        return Theme.pieceColors[index - 1]
    }
}
