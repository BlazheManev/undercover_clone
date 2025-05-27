# 🕵️ Undercover Clone Game

A fun party game built with Flutter. Players must figure out who the undercover agents are based on word descriptions.

---

## 📲 How to Run the App

1. **Clone the repository**
   ```bash
   git clone https://github.com/BlazheManev/undercover_clone
   cd undercover_clone
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 📁 App Structure

```
lib/
├── main.dart
├── models/
│   └── player.dart                # Player model (name, role, isAlive)
├── components/
│   ├── custom_button.dart         # Custom styled button used throughout the app
│   └── player_avatar.dart         # Reusable avatar component for player initials
├── screens/
│   ├── setup/
│   │   ├── setup_screen.dart       # Initial game setup screen
│   │   └── player_name_dialog.dart# Dialog for entering player names
│   └── game/
│       ├── role_screen.dart        # Role reveal screen with countdown and audio
│       ├── game_round_screen.dart  # Main game logic: voting, round handling
│       └── game_result_screen.dart # Final result screen showing win state
```

---

## 🔊 Audio Feedback

The game uses sound effects at important stages like:
- 🎵 Start Voting
- 🎵 Eliminate
- 🎵 Reveal
- 🎵 Win Sounds for Civilians and Undercover

You can find them in:
```
assets/audio/
├── start_voting.mp3
├── eliminate.mp3
├── reveal.mp3
├── win_civilians.mp3
└── win_undercover.mp3
```

---

## 🖼️ Screenshots
TODO

---

## 📦 Features

- Add custom player names
- Roles assigned secretly (Civilians vs Undercover)
- Round-based gameplay
- Voting system with animations and sounds
- Game over logic and restart

---

## 🚀 Get Started & Enjoy!

Build, play, and find the undercover! 🕵️‍♂️

---
