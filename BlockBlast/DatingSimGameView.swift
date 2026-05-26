//
//  DatingSimGameView.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//

import SwiftUI
import Combine

struct DatingSimGameView: View {
    @StateObject private var vm = DatingSimViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Theme.backgroundGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Camp Starlight")
                    .font(.largeTitle.bold())
                    .foregroundColor(Theme.textPrimary)

                if vm.phase == .prologue || vm.phase == .dayEnd || vm.phase == .dayStart {
                    dialogueBox
                } else if vm.phase == .characterSelect {
                    characterSelectView
                } else if vm.phase == .scene {
                    sceneView
                } else if vm.phase == .epilogue {
                    epilogueView
                }

                Spacer()

                if !vm.gameOver, vm.phase == .prologue || vm.phase == .dayEnd || vm.phase == .dayStart {
                    Button("Continue") {
                        withAnimation { vm.advance() }
                    }
                    .font(.headline)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(Theme.ticTacToeButton))
                    .foregroundColor(Theme.textPrimary)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Dating Sim")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
            }
        }
    }

    var dialogueBox: some View {
        VStack(spacing: 16) {
            if vm.phase == .dayStart {
                Text("Day \(vm.day)")
                    .font(.title2)
                    .foregroundColor(Theme.textSecondary)
            }
            Text(vm.currentDialogue)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(Theme.textPrimary)
                .padding()
        }
    }

    var characterSelectView: some View {
        VStack(spacing: 16) {
            Text(vm.currentDialogue)
                .font(.title3)
                .foregroundColor(Theme.textPrimary)
            ForEach(DatingSimViewModel.CharacterType.allCases, id: \.self) { type in
                let info = vm.characterInfo[type]!
                Button {
                    withAnimation { vm.chooseCharacter(type) }
                } label: {
                    HStack {
                        Image(systemName: info.icon)
                            .font(.title2)
                        VStack(alignment: .leading) {
                            Text(info.name)
                                .font(.headline)
                            Text("Affection: \(info.affection)")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Theme.ticTacToeButton))
                    .foregroundColor(Theme.textPrimary)
                }
            }
        }
    }

    var sceneView: some View {
        VStack(spacing: 16) {
            Text(vm.currentDialogue)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(Theme.textPrimary)
                .padding()
            ForEach(Array(vm.choices.enumerated()), id: \.offset) { index, choice in
                Button(choice) {
                    withAnimation { vm.makeSceneChoice(index) }
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Theme.ticTacToeButton))
                .foregroundColor(Theme.textPrimary)
            }
        }
    }

    var epilogueView: some View {
        VStack(spacing: 20) {
            Text("The End")
                .font(.largeTitle.bold())
                .foregroundColor(Theme.textPrimary)
            Text(vm.outcome)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(Theme.textPrimary)
            ForEach(DatingSimViewModel.CharacterType.allCases, id: \.self) { type in
                let info = vm.characterInfo[type]!
                HStack {
                    Image(systemName: info.icon)
                    Text("\(info.name): \(info.affection) affection")
                }
                .foregroundColor(Theme.textSecondary)
            }
            Button("Play Again") {
                withAnimation { vm.startGame() }
            }
            .font(.headline)
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(Capsule().fill(Theme.ticTacToeButton))
            .foregroundColor(Theme.textPrimary)
        }
    }
}
