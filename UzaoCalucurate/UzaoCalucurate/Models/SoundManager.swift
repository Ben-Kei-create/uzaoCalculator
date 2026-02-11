//
//  SoundManager.swift
//  UzaoCalculator
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()

    private var players: [String: AVAudioPlayer] = [:]

    private init() {
        prepareSound(named: "click", ext: "mp3")
        prepareSound(named: "enter", ext: "mp3")
        prepareSound(named: "clear", ext: "mp3")
    }

    private func prepareSound(named name: String, ext: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            players[name] = player
        } catch {}
    }

    /// Play a sound by name. No-ops silently if the file is missing.
    func play(_ name: String) {
        guard let player = players[name] else { return }
        player.currentTime = 0
        player.play()
    }

    /// Convenience: pick the right sound for a calculator key.
    func playForKey(_ key: String) {
        switch key {
        case "=":
            play("enter")
        case "C":
            play("clear")
        default:
            play("click")
        }
    }
}
