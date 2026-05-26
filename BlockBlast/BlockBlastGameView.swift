//
//  BlockBlastGameView.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//

import SwiftUI
import SwiftData

struct BlockBlastGameView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel: GameViewModel

    init() {
        _viewModel = StateObject(wrappedValue: GameViewModel(modelContext: ModelContext(sharedModelContainer)))
    }

    var body: some View {
        ZStack {
            Theme.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("High Score: \(viewModel.highScore)")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Text("Score: \(viewModel.score)")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                Spacer()

                BoardView(viewModel: viewModel)
                    .frame(maxWidth: 380)
                    .padding(.horizontal, 20)
                    .shadow(color: .black.opacity(0.15), radius: 16, y: 8)

                Spacer()

                PieceSelectorView(viewModel: viewModel)
                    .padding(.bottom, 14)

                if viewModel.gameOver {
                    Button {
                        withAnimation { viewModel.resetGame() }
                    } label: {
                        Text("Play Again")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Theme.ticTacToeButton))
                            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                    }
                    .padding(.bottom, 20)
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .coordinateSpace(name: "GameSpace")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Block Blast")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
        }
    }
}

private var sharedModelContainer: ModelContainer = {
    let schema = Schema([GameState.self])
    let config = ModelConfiguration(isStoredInMemoryOnly: false)
    return try! ModelContainer(for: schema, configurations: config)
}()
