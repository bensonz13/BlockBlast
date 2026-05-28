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
    @Published var playerName: String = ""
    @Published var nameEntered: Bool = false
    @Published var day = 0
    @Published var phase: GamePhase = .prologue
    @Published var selectedCharacter: CharacterType? = nil
    @Published var currentDialogue = ""
    @Published var choices: [String] = []
    @Published var outcome = ""
    @Published var gameOver = false

    @Published var sceneStep = 0
    @Published var sceneSteps: [String] = []
    @Published var sceneChoices: [[String]] = []
    private var lastChoiceIndex: Int? = nil

    struct CharacterInfo {
        let name: String
        let icon: String
        var affection: Int = 0
    }

    enum CharacterType: String, CaseIterable {
        case sakura, kenji, luna

        var name: String {
            switch self {
            case .sakura: return "Sakura"
            case .kenji:  return "Kenji"
            case .luna:   return "Luna"
            }
        }
    }

    enum GamePhase {
        case prologue, dayStart, characterSelect, scene, dayEnd, epilogue
    }

    var characterInfo: [CharacterType: CharacterInfo] = [:]
    let totalDays = 5

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
        playerName = ""
        nameEntered = false
        currentDialogue = "Welcome to Camp Starlight! What should we call you?"
        choices = []
        outcome = ""
        gameOver = false
        selectedCharacter = nil
        for key in characterInfo.keys {
            characterInfo[key]?.affection = 0
        }
    }

    func confirmName() {
        guard !playerName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        nameEntered = true
        advance()
    }

    func advance() {
        switch phase {
        case .prologue:
            if nameEntered {
                phase = .dayStart
                updateDayStart()
            }
        case .dayStart:
            phase = .characterSelect
        case .characterSelect:
            break
        case .scene:
            if sceneStep < sceneChoices.count && sceneChoices[sceneStep].isEmpty {
                sceneStep += 1
                if sceneStep < sceneSteps.count {
                    loadSceneStep()
                } else {
                    phase = .dayEnd
                    updateDayEnd()
                }
            }
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
        setupScene(for: type)
    }

    func makeSceneChoice(_ index: Int) {
        guard let selected = selectedCharacter else { return }
        lastChoiceIndex = index
        let step = sceneStep

        // Affection gains scale with day. Choice 0 = better response, choice 1 = lukewarm.
        let dayMultiplier = day  // 1–5
        let baseGains: [[Int]] = [[15, 5], [10, 5]]
        let scaleFactors: [Double] = [1.0, 1.3, 1.7, 2.0, 2.6]
        let scale = scaleFactors[min(dayMultiplier - 1, 4)]

        let gains = step == 0 ? baseGains[0] : baseGains[1]
        let gain = Int(Double(gains[min(index, gains.count - 1)]) * scale)
        characterInfo[selected]?.affection += gain

        // Branch reaction / closing lines
        if step == 0 && sceneSteps.count > 1 {
            sceneSteps[1] = reactionLine(for: selected, day: day, choice: index)
        } else if step == 2 && sceneSteps.count > 3 {
            sceneSteps[3] = closingLine(for: selected, day: day, choice: index)
        }

        sceneStep += 1
        if sceneStep < sceneSteps.count {
            loadSceneStep()
        } else {
            phase = .dayEnd
            updateDayEnd()
        }
    }

    // MARK: - Reaction Lines

    private func reactionLine(for character: CharacterType, day: Int, choice: Int) -> String {
        switch (character, day, choice) {
        case (.sakura, 1, 0): return "Sakura's eyes sparkle. \"You're a natural, \(playerName)! Let's finish the mural.\""
        case (.sakura, 1, 1): return "She smiles politely, but you sense a tiny disappointment."
        case (.sakura, 2, 0): return "\"A midnight stroll? That's so romantic, \(playerName)!\" She blushes."
        case (.sakura, 2, 1): return "She ties a bracelet around your wrist. \"Now we match.\""
        case (.sakura, 3, 0): return "She looks down, cheeks pink. \"I... really like spending time with you.\""
        case (.sakura, 3, 1): return "She laughs as you dance. \"You're full of surprises, \(playerName)!\""
        case (.sakura, 4, 0): return "\"You'd really write to me? That means so much.\""
        case (.sakura, 4, 1): return "\"A walk with you... everything feels right.\""
        case (.sakura, 5, 0): return "\"Letters? I'll write you every week, \(playerName).\""
        case (.sakura, 5, 1): return "\"Numbers are so... modern.\" She grins and types yours in."

        case (.kenji, 1, 0): return "Kenji high-fives you. \"You've got a cannon for an arm!\""
        case (.kenji, 1, 1): return "He waves from the court, but you can tell he wanted you in the game."
        case (.kenji, 2, 0): return "\"Adventure time!\" He pulls you into a canoe."
        case (.kenji, 2, 1): return "\"No fish, but the best company.\" He grins."
        case (.kenji, 3, 0): return "\"You're my favourite person here. Don't tell the others.\""
        case (.kenji, 3, 1): return "He gets chocolate on his nose; you wipe it off. He laughs."
        case (.kenji, 4, 0): return "\"You're fast!\" He lets you win, then sweeps you into a hug."
        case (.kenji, 4, 1): return "\"Sunrise is better with you.\" He says softly."
        case (.kenji, 5, 0): return "\"We'll meet again, I know it.\" His voice is steady."
        case (.kenji, 5, 1): return "\"Keep my bandana. It's for luck.\" He smiles."

        case (.luna, 1, 0): return "\"Nobody ever asks about my books. Thank you, \(playerName).\""
        case (.luna, 1, 1): return "She seems content just having you nearby, though you don't speak."
        case (.luna, 2, 0): return "\"Your voice is so soothing.\" She closes her eyes."
        case (.luna, 2, 1): return "\"You're so patient. I appreciate that.\""
        case (.luna, 3, 0): return "\"You really get me, \(playerName). It's rare.\""
        case (.luna, 3, 1): return "She points out constellations and leans against your shoulder."
        case (.luna, 4, 0): return "\"You inspired me to write this story.\" Her cheeks pink."
        case (.luna, 4, 1): return "She places a flower crown on your head. \"Now you're a true camper.\""
        case (.luna, 5, 0): return "\"I... I think I'm falling for you.\" It's barely a whisper."
        case (.luna, 5, 1): return "\"This book is my most precious thing. Now it's yours.\""
        default: return "..."
        }
    }

    // MARK: - Closing Lines

    private func closingLine(for character: CharacterType, day: Int, choice: Int) -> String {
        switch (character, day, choice) {
        case (.sakura, 1, 0): return "\"I can't wait for tomorrow, \(playerName).\" She waves goodbye."
        case (.sakura, 1, 1): return "She nods politely and returns to her painting."
        case (.sakura, 2, 0): return "\"I'll remember this night forever.\" She squeezes your hand."
        case (.sakura, 2, 1): return "\"You're a great friend, \(playerName).\" She smiles warmly."
        case (.sakura, 3, 0): return "You both sit in comfortable silence, the fire crackling between you."
        case (.sakura, 3, 1): return "\"This was the best evening ever.\" She sighs happily."
        case (.sakura, 4, 0): return "\"Write me soon, okay?\" She looks hopeful."
        case (.sakura, 4, 1): return "\"The woods seem magical with you.\""
        case (.sakura, 5, 0): return "She hugs you tight, not wanting to let go."
        case (.sakura, 5, 1): return "You both promise to text right after camp."

        case (.kenji, 1, 0): return "\"Same time tomorrow?\" He's already planning."
        case (.kenji, 1, 1): return "He nods and jogs back to the court."
        case (.kenji, 2, 0): return "\"Best canoe trip ever!\" He helps you out of the boat."
        case (.kenji, 2, 1): return "\"We'll catch one next time, I swear!\""
        case (.kenji, 3, 0): return "\"Just between us, you're the real MVP.\" He winks."
        case (.kenji, 3, 1): return "\"I'm gonna miss these campfires.\" He looks at you."
        case (.kenji, 4, 0): return "\"Nobody's ever beaten me before. I like it.\""
        case (.kenji, 4, 1): return "\"Let's do this again tomorrow?\""
        case (.kenji, 5, 0): return "\"Until we meet again.\" He gives you a firm handshake, then a hug."
        case (.kenji, 5, 1): return "\"Think of me when you wear it.\""

        case (.luna, 1, 0): return "\"See you tomorrow, \(playerName).\" She looks back once."
        case (.luna, 1, 1): return "She returns to her book, a small smile on her face."
        case (.luna, 2, 0): return "\"I could listen to you forever.\" She says dreamily."
        case (.luna, 2, 1): return "\"You make even dusty books fun.\""
        case (.luna, 3, 0): return "She feels understood, and it shows in her eyes."
        case (.luna, 3, 1): return "\"The stars are beautiful, but not as much as this moment.\""
        case (.luna, 4, 0): return "\"Read it when you miss me.\" She hands you the story."
        case (.luna, 4, 1): return "\"We make a good team, don't we?\""
        case (.luna, 5, 0): return "\"I'll never forget this summer.\" Tears well in her eyes."
        case (.luna, 5, 1): return "\"This book is a piece of my heart. Take care of it.\""
        default: return "The day winds down peacefully."
        }
    }

    // MARK: - Scene Setup

    private func setupScene(for type: CharacterType) {
        selectedCharacter = type
        sceneSteps = ["", "", "", ""]
        sceneChoices = [["", ""], [], ["", ""], []]

        switch (type, day) {
        case (.sakura, 1):
            sceneSteps[0] = "Sakura is painting the camp mural. She turns with a shy smile. \"Care to join me, \(playerName)?\""
            sceneChoices[0] = ["Help her paint.", "Just watch for now."]
            sceneSteps[2] = "\"We make a good team.\" She asks, \"Do you like art, \(playerName)?\""
            sceneChoices[2] = ["\"I love it!\"", "\"It's nice, I guess.\""]
        case (.sakura, 2):
            sceneSteps[0] = "\"Let's do something fun tonight, \(playerName).\" Sakura's eyes gleam."
            sceneChoices[0] = ["Suggest a midnight stroll.", "Make friendship bracelets."]
            sceneSteps[2] = "\"I'm having so much fun.\" She tilts her head. \"What's your favourite camp memory so far?\""
            sceneChoices[2] = ["\"Right now, with you.\"", "\"The campfire songs.\""]
        case (.sakura, 3):
            sceneSteps[0] = "The campfire crackles. Sakura sits closer. \"Are you enjoying camp, \(playerName)?\""
            sceneChoices[0] = ["Tell her she's the best part.", "Ask her to dance instead."]
            sceneSteps[2] = "\"You're always so kind.\" She looks down. \"Can I tell you a secret?\""
            sceneChoices[2] = ["\"Of course.\"", "\"Only if you want to.\""]
        case (.sakura, 4):
            sceneSteps[0] = "Sakura looks sad. \"Only two days left...\" She sighs."
            sceneChoices[0] = ["Promise to stay in touch.", "Take her on a nature walk to cheer her up."]
            sceneSteps[2] = "\"You really care, don't you?\" She asks, \"Would you visit me after camp?\""
            sceneChoices[2] = ["\"Absolutely.\"", "\"Maybe, if I can.\""]
        case (.sakura, 5):
            sceneSteps[0] = "Final day. Sakura's eyes glisten. \"I don't want to say goodbye, \(playerName).\""
            sceneChoices[0] = ["Promise to write letters.", "Exchange phone numbers."]
            sceneSteps[2] = "\"You've made this summer unforgettable.\" She whispers, \"Will you remember me?\""
            sceneChoices[2] = ["\"I'll never forget you.\"", "\"Of course, you're special.\""]

        case (.kenji, 1):
            sceneSteps[0] = "Kenji waves you over to the dodgeball court. \"Hey \(playerName), jump in!\""
            sceneChoices[0] = ["Join his team.", "Cheer from the sidelines."]
            sceneSteps[2] = "\"That was intense!\" He asks, \"Are you always this active?\""
            sceneChoices[2] = ["\"I love sports!\"", "\"Only when it's fun.\""]
        case (.kenji, 2):
            sceneSteps[0] = "Kenji is restless by the lake. \"Wanna do something crazy, \(playerName)?\""
            sceneChoices[0] = ["Grab a canoe!", "Teach me to fish."]
            sceneSteps[2] = "\"This is the best.\" He asks, \"What's your biggest dream?\""
            sceneChoices[2] = ["\"To travel the world.\"", "\"To have adventures like this.\""]
        case (.kenji, 3):
            sceneSteps[0] = "Kenji saves you a seat. \"You're my go-to person now.\""
            sceneChoices[0] = ["\"You're mine too.\"", "Let's make s'mores!"]
            sceneSteps[2] = "\"I like how honest you are.\" He asks, \"Ever had a camp crush?\""
            sceneChoices[2] = ["\"Maybe right now.\"", "\"Nah, just friends.\""]
        case (.kenji, 4):
            sceneSteps[0] = "\"One last challenge before camp ends?\" Kenji grins."
            sceneChoices[0] = ["Race him!", "Watch the sunrise instead."]
            sceneSteps[2] = "\"You're full of surprises.\" He asks, \"What'll you miss most?\""
            sceneChoices[2] = ["\"This, with you.\"", "\"The freedom.\""]
        case (.kenji, 5):
            sceneSteps[0] = "Kenji is quiet for once. \"It's really over, huh?\""
            sceneChoices[0] = ["Promise we'll meet again.", "Accept his lucky bandana."]
            sceneSteps[2] = "\"I'm glad I met you.\" He asks, \"Can I text you later?\""
            sceneChoices[2] = ["\"Definitely!\"", "\"If you want.\""]

        case (.luna, 1):
            sceneSteps[0] = "Luna glances up from her book. \"Oh, hi \(playerName). Want to sit?\""
            sceneChoices[0] = ["Ask about her book.", "Sit quietly beside her."]
            sceneSteps[2] = "\"This is nice.\" She asks, \"Do you read often?\""
            sceneChoices[2] = ["\"Yes, all the time.\"", "\"Not really, but I'm curious.\""]
        case (.luna, 2):
            sceneSteps[0] = "\"The garden is so peaceful.\" Luna pats the grass. \"Join me, \(playerName)?\""
            sceneChoices[0] = ["Listen to her poetry.", "Help her organize the library."]
            sceneSteps[2] = "\"You have a calming presence.\" She asks, \"What inspires you?\""
            sceneChoices[2] = ["\"People like you.\"", "\"Nature and art.\""]
        case (.luna, 3):
            sceneSteps[0] = "Luna seems lost in thought. \"Can I share something, \(playerName)?\""
            sceneChoices[0] = ["\"I'm all ears.\"", "Let's stargaze first."]
            sceneSteps[2] = "\"You make it easy to open up.\" She asks, \"Do you believe in fate?\""
            sceneChoices[2] = ["\"Maybe I do now.\"", "\"Not really.\""]
        case (.luna, 4):
            sceneSteps[0] = "\"I'm writing a story.\" Luna fidgets. \"You're in it, \(playerName).\""
            sceneChoices[0] = ["\"I'd love to read it.\"", "Let's make flower crowns instead."]
            sceneSteps[2] = "\"You're the first person I've shown.\" She asks, \"Do you think we'll stay friends?\""
            sceneChoices[2] = ["\"I hope more than friends.\"", "\"Friends for sure.\""]
        case (.luna, 5):
            sceneSteps[0] = "Luna's voice shakes. \"I have to tell you something, \(playerName)...\""
            sceneChoices[0] = ["Confess your feelings.", "Give her a meaningful gift."]
            sceneSteps[2] = "\"This is so hard.\" She asks, \"Do you feel the same?\""
            sceneChoices[2] = ["\"I've fallen for you too.\"", "\"I care about you deeply.\""]

        default: break
        }
        sceneStep = 0
        loadSceneStep()
    }

    private func loadSceneStep() {
        guard sceneStep < sceneSteps.count else { return }
        currentDialogue = sceneSteps[sceneStep]
        choices = sceneStep < sceneChoices.count ? sceneChoices[sceneStep] : []
    }

    // MARK: - Phase Updates

    private func updateDayStart() {
        let lines = [
            "The morning air is fresh with pine. Day \(day) begins.",
            "Another beautiful day at Camp Starlight. Who will you spend it with?",
            "Midway through camp — you feel like you belong here. Day \(day).",
            "The days are passing too fast. Who matters most to you?",
            "The final day. Make every moment count, \(playerName)."
        ]
        currentDialogue = lines[min(day - 1, lines.count - 1)]
        choices = []
    }

    private func updateDayEnd() {
        currentDialogue = "The sun sets over Camp Starlight. Today felt special."
        choices = []
    }

    // MARK: - Ending Generation

    private func generateEnding() {
        gameOver = true

        // Find highest-affection character
        let sorted = CharacterType.allCases
            .compactMap { type -> (CharacterType, Int)? in
                guard let info = characterInfo[type] else { return nil }
                return (type, info.affection)
            }
            .sorted { $0.1 > $1.1 }

        guard let (winner, winnerAff) = sorted.first else {
            outcome = "You kept to yourself this summer, \(playerName). Maybe next year you'll open up."
            return
        }

        let name = characterInfo[winner]!.name
        let secondAff = sorted.count > 1 ? sorted[1].1 : 0
        let gap = winnerAff - secondAff

        if winnerAff >= 160 {
            outcome = "\(name) is deeply in love with you, \(playerName). As you packed your bags on the last day, they took your hand and whispered that this summer changed everything. You leave camp together, hearts full. 💖"
        } else if winnerAff >= 110 {
            if gap < 20 {
                outcome = "Both \(name) and \(sorted[1].0 == winner ? "" : characterInfo[sorted[1].0]!.name) grew close to you this summer, \(playerName). Your heart felt torn — but \(name)'s warmth lingered longest. You exchange numbers and make a promise to meet again. 💕"
            } else {
                outcome = "\(name) really likes you, \(playerName). You exchange numbers and make plans to meet again. The summer isn't over — it's just beginning. 💕"
            }
        } else if winnerAff >= 60 {
            outcome = "\(name) had a wonderful time with you, \(playerName). You leave as good friends, and who knows — maybe something more is waiting on the other side of summer. 🌸"
        } else if winnerAff >= 25 {
            outcome = "You made a few nice memories with \(name), \(playerName). Camp flew by — try spending more time with people you care about next year. 🌿"
        } else {
            outcome = "You kept mostly to yourself this summer, \(playerName). The woods were peaceful, but lonely. Next year, take a chance. 🍂"
        }
    }
}
