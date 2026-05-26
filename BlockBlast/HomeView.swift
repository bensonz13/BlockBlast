//
//  HomeView.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.backgroundGradient(for: colorScheme)
                    .ignoresSafeArea()

                VStack(spacing: 28) {
                    Text("Game Box")
                        .font(.system(size: 44, weight: .heavy, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)
                        .shadow(color: .primary.opacity(0.1), radius: 4, y: 1)
                        .padding(.top, 20)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                        NavigationLink(destination: BlockBlastGameView()) {
                            GameCard(
                                icon: "square.grid.3x3.fill",
                                title: "Block Blast",
                                subtitle: "Drag & clear lines",
                                startColor: Theme.cardBlueStart,
                                endColor: Theme.cardBlueEnd
                            )
                        }
                        .buttonStyle(ScaleButtonStyle())

                        NavigationLink(destination: TicTacToeGameView()) {
                            GameCard(
                                icon: "xmark",
                                title: "Tic Tac Toe",
                                subtitle: "Classic 3×3",
                                startColor: Theme.cardPinkStart,
                                endColor: Theme.cardPinkEnd
                            )
                        }
                        .buttonStyle(ScaleButtonStyle())

                        NavigationLink(destination: DatingSimGameView()) {
                            GameCard(
                                icon: "heart.fill",
                                title: "Dating Sim",
                                subtitle: "Choose your crush",
                                startColor: Color(UIColor { trait in
                                    trait.userInterfaceStyle == .dark
                                    ? UIColor(red: 0.45, green: 0.20, blue: 0.45, alpha: 1)
                                    : UIColor(red: 0.70, green: 0.35, blue: 0.65, alpha: 1)
                                }),
                                endColor: Color(UIColor { trait in
                                    trait.userInterfaceStyle == .dark
                                    ? UIColor(red: 0.55, green: 0.30, blue: 0.55, alpha: 1)
                                    : UIColor(red: 0.80, green: 0.50, blue: 0.75, alpha: 1)
                                })
                            )
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                }
            }
        }
    }
}

struct GameCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let startColor: Color
    let endColor: Color

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 38, weight: .medium))
                .foregroundColor(Theme.whiteFixed)
            Text(title)
                .font(.title3.bold())
                .foregroundColor(Theme.whiteFixed)
            Text(subtitle)
                .font(.caption)
                .foregroundColor(Theme.whiteFixed.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(color: startColor.opacity(0.3), radius: 12, y: 6)
        )
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
