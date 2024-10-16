
# ColdFusion Wheel of Fortune Game

Welcome to the **ColdFusion Wheel of Fortune**! This project is an interactive, session-based game where users guess letters to uncover a hidden phrase, earning points along the way.

---

## Features

- **Random Phrase Selection**: Each game starts with a randomly selected phrase from a predefined list.
- **Session State Management**: Game state is stored using ColdFusion sessions to track progress.
- **Scoring System**: Players earn points based on correct letter guesses.
- **Real-time Phrase Display**: The phrase updates dynamically, revealing correctly guessed letters.
- **Game Over Detection**: The game detects when all letters are guessed, offering a restart option.

---

## Prerequisites

To run the project, you need:
- Adobe ColdFusion or an open-source alternative like **Lucee**.
- A ColdFusion-compatible web server.

---

## Installation

1. Clone the repository or copy the provided code:

   ```bash
   git clone <repository_url>
   ```

2. Place the code inside your web server’s root directory.
3. Save the file as `wheeloffortune.cfm`.

---

## Code Overview

### Session Initialization

The session is initialized with:

- A list of phrases
- A randomly selected phrase
- Empty guessed letters
- Score initialized to 0
- Game state tracking

```cfml
if (NOT StructKeyExists(session, "initialized")) {
    session.initialized = true;
    session.phrases = [
        "ColdFusion Rocks", "Hello World", 
        "Wheel of Fortune", "Programming is Fun",
        "OpenAI GPT Model", "Artificial Intelligence",
        "Stack Overflow", "Adobe ColdFusion",
        "Server Side Scripting", "Dynamic Web Applications"
    ];
    session.phrase = session.phrases[RandRange(1, ArrayLen(session.phrases))];
    session.guessedLetters = [];
    session.score = 0;
    session.gameOver = false;
    session.message = "";
}
```

### Phrase Display Logic

A function to show the phrase with guessed letters and underscores for unguessed ones:

```cfml
function getDisplayPhrase() {
    var displayPhrase = "";
    for (var i = 1; i <= Len(session.phrase); i++) {
        var char = Mid(session.phrase, i, 1);
        if (REFind("[A-Za-z]", char)) {
            if (ListFindNoCase(ArrayToList(session.guessedLetters), char)) {
                displayPhrase &= char & " ";
            } else {
                displayPhrase &= "_ ";
            }
        } else {
            displayPhrase &= char & " ";
        }
    }
    return displayPhrase;
}
```

### Scoring System and Game Logic

Players earn random points for correct guesses:

```cfml
if (form.action == "guess" AND NOT session.gameOver) {
    var guessedLetter = UCase(form.letter);
    if (NOT ListFindNoCase(ArrayToList(session.guessedLetters), guessedLetter)) {
        ArrayAppend(session.guessedLetters, guessedLetter);
        if (FindNoCase(guessedLetter, session.phrase)) {
            var occurrences = Len(session.phrase) - Len(ReplaceNoCase(session.phrase, guessedLetter, "", "ALL"));
            var points = RandRange(100, 1000);
            session.score += points * occurrences;
            session.message = "Correct! The letter '" & guessedLetter & "' appears " & occurrences & 
                              " time(s). You earned " & (points * occurrences) & " points.";
        } else {
            session.message = "Sorry, the letter '" & guessedLetter & "' is not in the phrase.";
        }
    } else {
        session.message = "You've already guessed '" & guessedLetter & "'. Try a different one.";
    }
}
```

---

## How to Play

1. Start the ColdFusion server.
2. Navigate to:

   ```
   http://<your-server>/wheeloffortune.cfm
   ```

3. Guess letters using the input form.
4. Earn points for correct guesses and uncover the phrase.
5. Once all letters are guessed, the game will declare you the winner!

---

## Restarting the Game

Click the **Play Again** button to restart the game:

```cfml
<form method="post" action="wheeloffortune.cfm">
    <input type="hidden" name="action" value="restart">
    <input type="submit" value="Play Again">
</form>
```

---

## UI and Styles

The UI features a clean layout with CSS styling for better user experience:

```html
<style>
    body { font-family: Arial, sans-serif; }
    .phrase { font-size: 24px; letter-spacing: 2px; margin-bottom: 20px; }
    .message { color: green; margin-top: 20px; }
    .score { font-weight: bold; }
    .container { max-width: 600px; margin: 0 auto; text-align: center; }
</style>
```

---

## Contribution

Feel free to fork this project and submit pull requests. Contributions are welcome!

---

## License

This project is licensed under the MIT License.

---

Enjoy playing **ColdFusion Wheel of Fortune**!
