//
//  DatingSimViewModel.swift
//  BlockBlast
//
//  Created by Student on 5/26/26.
//
import SwiftUI
import Combine

@MainActor
class DatingSimViewModel: ObservableObject {
    @Published var day = 0
    @Published var phase: GamePhase = .prologue
    @Published var selectedCharacter: CharacterType? = nil
    @Published var currentDialogue = ""
    @Published var choices: [String] = []
    @Published var outcome = ""
    @Published var gameOver = false

    struct CharacterInfo {
        let name: String
        let icon: String
        var affection: Int = 0
        var eventsSeen: Set<String> = []
    }

    enum CharacterType: String, CaseIterable {
        case sakura, kenji, luna
    }

    enum GamePhase {
        case prologue, dayStart, characterSelect, scene, dayEnd, epilogue
    }

    var characterInfo: [CharacterType: CharacterInfo] = [:]
    var totalDays = 5

    init() {
        characterInfo = [
            .sakura: CharacterInfo(name: "Sakura", icon: "paintpalette.fill"),
            .kenji:  CharacterInfo(name: "Kenji",  icon: "sportscourt.fill"),
            .luna:   CharacterInfo(name: "Luna",   icon: "book.fill")
        ]
        startGame()
    }

    func startGame() {
        day = 1
        phase = .prologue
        currentDialogue = "Welcome to Camp Starlight! Over the next few days, you'll meet new friends and maybe even find love. Make the most of every moment."
        choices = ["Let's go!"]
        outcome = ""
        gameOver = false
        for key in characterInfo.keys {
            characterInfo[key]?.affection = 0
            characterInfo[key]?.eventsSeen = []
        }
    }

    func advance() {
        switch phase {
        case .prologue:
            phase = .dayStart
            updateDayStart()
        case .dayStart:
            phase = .characterSelect
            updateCharacterSelect()
        case .characterSelect:
            break
        case .scene:
            break
        case .dayEnd:
            day += 1
            if day > totalDays {
                phase = .epilogue
                generateEnding()
            } else {
                phase = .dayStart
                updateDayStart()
            }
        case .epilogue:
            startGame()
        }
    }

    func chooseCharacter(_ type: CharacterType) {
        selectedCharacter = type
        phase = .scene
        generateScene(for: type)
    }

    func makeSceneChoice(_ index: Int) {
        guard let selected = selectedCharacter else { return }
        switch (selected, day, index) {
        case (.sakura, 1, 0):
            characterInfo[.sakura]?.affection += 15
            currentDialogue = "Sakura's eyes light up. \"You're a natural! Let's finish this mural together.\""
            characterInfo[.sakura]?.eventsSeen.insert("d1paint")
        case (.sakura, 1, 1):
            characterInfo[.sakura]?.affection += 5
            currentDialogue = "She smiles politely but seems a bit disappointed you didn't join in."
            characterInfo[.sakura]?.eventsSeen.insert("d1watch")
        case (.kenji, 1, 0):
            characterInfo[.kenji]?.affection += 15
            currentDialogue = "Kenji gives you a high-five. \"You've got a great arm!\""
            characterInfo[.kenji]?.eventsSeen.insert("d1play")
        case (.kenji, 1, 1):
            characterInfo[.kenji]?.affection += 5
            currentDialogue = "He waves from the court, but you can tell he wanted you on his team."
            characterInfo[.kenji]?.eventsSeen.insert("d1cheer")
        case (.luna, 1, 0):
            characterInfo[.luna]?.affection += 15
            currentDialogue = "Luna blushes. \"Nobody ever wants to hear about my books. Thank you.\""
            characterInfo[.luna]?.eventsSeen.insert("d1share")
        case (.luna, 1, 1):
            characterInfo[.luna]?.affection += 5
            currentDialogue = "She seems content just having you nearby, though you don't talk much."
            characterInfo[.luna]?.eventsSeen.insert("d1quiet")

        case (.sakura, 2, 0):
            characterInfo[.sakura]?.affection += 20
            currentDialogue = "Sakura giggles. \"A midnight stroll? That's so romantic.\" You talk under the stars."
            characterInfo[.sakura]?.eventsSeen.insert("d2stroll")
        case (.sakura, 2, 1):
            characterInfo[.sakura]?.affection += 10
            currentDialogue = "You make friendship bracelets. She ties one around your wrist. \"Now we match.\""
            characterInfo[.sakura]?.eventsSeen.insert("d2bracelet")
        case (.kenji, 2, 0):
            characterInfo[.kenji]?.affection += 20
            currentDialogue = "He pulls you into a canoe. \"Adventure time!\" You explore the lake until sunset."
            characterInfo[.kenji]?.eventsSeen.insert("d2canoe")
        case (.kenji, 2, 1):
            characterInfo[.kenji]?.affection += 10
            currentDialogue = "Kenji teaches you to fish. You don't catch anything, but you both laugh a lot."
            characterInfo[.kenji]?.eventsSeen.insert("d2fish")
        case (.luna, 2, 0):
            characterInfo[.luna]?.affection += 20
            currentDialogue = "Luna reads you poetry in the garden. Her voice is soft and enchanting."
            characterInfo[.luna]?.eventsSeen.insert("d2poetry")
        case (.luna, 2, 1):
            characterInfo[.luna]?.affection += 10
            currentDialogue = "You help her organize the camp library. She's impressed by your patience."
            characterInfo[.luna]?.eventsSeen.insert("d2library")

        case (.sakura, 3, 0):
            characterInfo[.sakura]?.affection += 25
            currentDialogue = "Sakura confesses she's been looking forward to seeing you each day."
            characterInfo[.sakura]?.eventsSeen.insert("d3confess")
        case (.sakura, 3, 1):
            characterInfo[.sakura]?.affection += 12
            currentDialogue = "You dance together at the campfire. Sparks fly – literally and figuratively."
            characterInfo[.sakura]?.eventsSeen.insert("d3dance")
        case (.kenji, 3, 0):
            characterInfo[.kenji]?.affection += 25
            currentDialogue = "Kenji admits you're his favorite camp buddy. \"Don't tell the others.\""
            characterInfo[.kenji]?.eventsSeen.insert("d3buddy")
        case (.kenji, 3, 1):
            characterInfo[.kenji]?.affection += 12
            currentDialogue = "You share a s'more by the fire. He gets chocolate on his nose; you wipe it off."
            characterInfo[.kenji]?.eventsSeen.insert("d3smores")
        case (.luna, 3, 0):
            characterInfo[.luna]?.affection += 25
            currentDialogue = "Luna says she's never met someone who understands her like you do."
            characterInfo[.luna]?.eventsSeen.insert("d3understand")
        case (.luna, 3, 1):
            characterInfo[.luna]?.affection += 12
            currentDialogue = "You stargaze together. She points out constellations and leans against your shoulder."
            characterInfo[.luna]?.eventsSeen.insert("d3stars")

        case (.sakura, 4, 0):
            characterInfo[.sakura]?.affection += 30
            currentDialogue = "Sakura gives you a painting of the two of you. \"So you never forget camp.\""
            characterInfo[.sakura]?.eventsSeen.insert("d4painting")
        case (.sakura, 4, 1):
            characterInfo[.sakura]?.affection += 15
            currentDialogue = "You walk through the woods, holding hands. It feels natural."
            characterInfo[.sakura]?.eventsSeen.insert("d4walk")
        case (.kenji, 4, 0):
            characterInfo[.kenji]?.affection += 30
            currentDialogue = "Kenji challenges you to a final race. He lets you win, then sweeps you into a hug."
            characterInfo[.kenji]?.eventsSeen.insert("d4race")
        case (.kenji, 4, 1):
            characterInfo[.kenji]?.affection += 15
            currentDialogue = "You both sneak out to watch the sunrise. He says it's better with you."
            characterInfo[.kenji]?.eventsSeen.insert("d4sunrise")
        case (.luna, 4, 0):
            characterInfo[.luna]?.affection += 30
            currentDialogue = "Luna writes a short story where the hero is clearly based on you. \"You inspired me.\""
            characterInfo[.luna]?.eventsSeen.insert("d4story")
        case (.luna, 4, 1):
            characterInfo[.luna]?.affection += 15
            currentDialogue = "You craft flower crowns. She places one on your head. \"Now you're a true camper.\""
            characterInfo[.luna]?.eventsSeen.insert("d4crown")

        case (.sakura, 5, 0):
            characterInfo[.sakura]?.affection += 40
            currentDialogue = "Sakura tearfully asks if you'll write to her after camp. You promise you will."
            characterInfo[.sakura]?.eventsSeen.insert("d5promise")
        case (.sakura, 5, 1):
            characterInfo[.sakura]?.affection += 20
            currentDialogue = "You exchange phone numbers. She gives you a lingering hug."
            characterInfo[.sakura]?.eventsSeen.insert("d5numbers")
        case (.kenji, 5, 0):
            characterInfo[.kenji]?.affection += 40
            currentDialogue = "Kenji says camp won't be the same without you. \"We'll meet again, I know it.\""
            characterInfo[.kenji]?.eventsSeen.insert("d5meetagain")
        case (.kenji, 5, 1):
            characterInfo[.kenji]?.affection += 20
            currentDialogue = "He gives you his lucky bandana. \"Keep it. For luck.\""
            characterInfo[.kenji]?.eventsSeen.insert("d5bandana")
        case (.luna, 5, 0):
            characterInfo[.luna]?.affection += 40
            currentDialogue = "Luna whispers that she thinks she's falling for you. Her cheeks are bright red."
            characterInfo[.luna]?.eventsSeen.insert("d5falling")
        case (.luna, 5, 1):
            characterInfo[.luna]?.affection += 20
            currentDialogue = "She gifts you her favorite book with a heartfelt note inside."
            characterInfo[.luna]?.eventsSeen.insert("d5book")

        default:
            break
        }
        phase = .dayEnd
        updateDayEnd()
    }

    private func updateDayStart() {
        currentDialogue = "Day \(day) at Camp Starlight. Who would you like to spend time with?"
        choices = CharacterType.allCases.map { type in
            let info = characterInfo[type]!
            return "\(info.name) (\(info.icon))"
        }
    }

    private func updateCharacterSelect() {}

    private func generateScene(for type: CharacterType) {
        selectedCharacter = type
        switch (type, day) {
        case (.sakura, 1):
            currentDialogue = "Sakura is painting the camp mural. She turns to you with a shy smile."
            choices = ["Help her paint.", "Watch her work."]
        case (.sakura, 2):
            currentDialogue = "\"Let's do something fun tonight,\" Sakura says with a wink."
            choices = ["Suggest a midnight stroll.", "Make friendship bracelets."]
        case (.sakura, 3):
            currentDialogue = "The campfire is crackling. Sakura sits next to you, closer than before."
            choices = ["Tell her you enjoy her company.", "Ask her to dance."]
        case (.sakura, 4):
            currentDialogue = "Sakura looks a little sad. \"The camp is almost over...\""
            choices = ["Reassure her you'll stay in touch.", "Take her on a nature walk."]
        case (.sakura, 5):
            currentDialogue = "It's the last day. Sakura's eyes are glistening."
            choices = ["Promise to write letters.", "Exchange numbers."]
        case (.kenji, 1):
            currentDialogue = "Kenji is organizing a dodgeball game. He spots you and grins."
            choices = ["Join his team.", "Cheer from the sidelines."]
        case (.kenji, 2):
            currentDialogue = "Kenji is at the lake, looking restless."
            choices = ["Suggest a canoe ride.", "Learn to fish with him."]
        case (.kenji, 3):
            currentDialogue = "Kenji saves you a seat by the campfire."
            choices = ["Tell him he's your favorite person here.", "Make s'mores together."]
        case (.kenji, 4):
            currentDialogue = "Kenji seems competitive today. \"One last challenge before we leave?\""
            choices = ["Race him.", "Watch the sunrise together."]
        case (.kenji, 5):
            currentDialogue = "Kenji's usual energy is subdued. He's quiet."
            choices = ["Promise to meet again.", "Accept a keepsake."]
        case (.luna, 1):
            currentDialogue = "Luna is reading under a tree. She glances up and adjusts her glasses."
            choices = ["Ask about her book.", "Sit with her silently."]
        case (.luna, 2):
            currentDialogue = "\"The garden here is lovely,\" Luna muses. \"Care to join me?\""
            choices = ["Listen to her poetry.", "Help in the library."]
        case (.luna, 3):
            currentDialogue = "Luna seems lost in thought. She smiles when you approach."
            choices = ["Tell her you understand her.", "Go stargazing."]
        case (.luna, 4):
            currentDialogue = "Luna is writing furiously in a notebook."
            choices = ["Ask to read her story.", "Make flower crowns."]
        case (.luna, 5):
            currentDialogue = "Luna's voice trembles. \"I don't want to say goodbye.\""
            choices = ["Confess your feelings.", "Give her a meaningful gift."]
        default:
            break
        }
    }

    private func updateDayEnd() {
        currentDialogue = "The day ends. You feel closer to the people around you."
        choices = ["Next day"]
    }

    private func generateEnding() {
        gameOver = true
        let highest = characterInfo.max(by: { $0.value.affection < $1.value.affection })
        guard let (type, info) = highest else {
            outcome = "You made no connections. Maybe next summer."
            return
        }
        if info.affection >= 100 {
            outcome = "\(info.name) is deeply in love with you. You leave camp as a couple. 💖"
        } else if info.affection >= 60 {
            outcome = "\(info.name) really likes you. You exchange contacts and promise to meet again."
        } else if info.affection >= 30 {
            outcome = "\(info.name) enjoyed your company but nothing more. Still, you made a friend."
        } else {
            outcome = "You didn't spend enough time with anyone. Maybe try again?"
        }
    }
}
