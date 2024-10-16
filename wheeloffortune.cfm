<cfscript>
    // Start the session
    if (NOT StructKeyExists(session, "initialized")) {
        session.initialized = true;
        // Initialize the game
        session.phrases = [
            "ColdFusion Rocks",
            "Hello World",
            "Wheel of Fortune",
            "Programming is Fun",
            "OpenAI GPT Model",
            "Artificial Intelligence",
            "Stack Overflow",
            "Adobe ColdFusion",
            "Server Side Scripting",
            "Dynamic Web Applications"
        ];
        // Randomly select a phrase
        session.phrase = session.phrases[RandRange(1, ArrayLen(session.phrases))];
        session.guessedLetters = [];
        session.score = 0;
        session.gameOver = false;
        session.message = "";
    }

    // Function to display the phrase with guessed letters
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

    // Function to check if the user has won
    function checkWin() {
        for (var i = 1; i <= Len(session.phrase); i++) {
            var char = Mid(session.phrase, i, 1);
            if (REFind("[A-Za-z]", char) AND NOT ListFindNoCase(ArrayToList(session.guessedLetters), char)) {
                return false;
            }
        }
        return true;
    }

    // Handle form submissions
    if (StructKeyExists(form, "action")) {
        if (form.action == "guess" AND NOT session.gameOver) {
            var guessedLetter = UCase(form.letter);
            if (NOT ListFindNoCase(ArrayToList(session.guessedLetters), guessedLetter)) {
                ArrayAppend(session.guessedLetters, guessedLetter);
                if (FindNoCase(guessedLetter, session.phrase)) {
                    // Correct guess, add points
                    var occurrences = Len(session.phrase) - Len(ReplaceNoCase(session.phrase, guessedLetter, "", "ALL"));
                    var points = RandRange(100, 1000); // Random points between 100 and 1000
                    session.score += points * occurrences;
                    session.message = "Correct! The letter '" & guessedLetter & "' appears " & occurrences & " time(s). You earned " & (points * occurrences) & " points.";
                } else {
                    // Incorrect guess
                    session.message = "Sorry, the letter '" & guessedLetter & "' is not in the phrase.";
                }
            } else {
                session.message = "You have already guessed the letter '" & guessedLetter & "'. Try a different one.";
            }
        } else if (form.action == "restart") {
            StructClear(session);
            cflocation(url="wheeloffortune.cfm");
        }
    }

    // Check if the user has won
    if (checkWin() AND NOT session.gameOver) {
        session.gameOver = true;
        session.message = "Congratulations! You've guessed the phrase!";
    }

    // Prepare display variables
    displayPhrase = getDisplayPhrase();
    guessedLettersDisplay = ArrayToList(session.guessedLetters, ", ");
</cfscript>

<!DOCTYPE html>
<html>
<head>
    <title>ColdFusion Wheel of Fortune</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .phrase { font-size: 24px; letter-spacing: 2px; margin-bottom: 20px; }
        .message { color: green; margin-top: 20px; }
        .score { font-weight: bold; }
        .container { max-width: 600px; margin: 0 auto; text-align: center; }
        input[type="text"] { width: 50px; font-size: 18px; text-align: center; }
        input[type="submit"] { font-size: 16px; padding: 5px 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Wheel of Fortune</h1>
        <div class="phrase">
            #displayPhrase#
        </div>
        <p>Score: <span class="score">#session.score#</span></p>
        <p>Guessed Letters: #guessedLettersDisplay#</p>
        <cfif Len(session.message) GT 0>
            <p class="message">#session.message#</p>
        </cfif>
        <cfif NOT session.gameOver>
            <form method="post" action="wheeloffortune.cfm">
                <input type="hidden" name="action" value="guess">
                <label for="letter">Guess a letter:</label>
                <input type="text" name="letter" id="letter" maxlength="1" required pattern="[A-Za-z]">
                <input type="submit" value="Guess">
            </form>
        <cfelse>
            <form method="post" action="wheeloffortune.cfm">
                <input type="hidden" name="action" value="restart">
                <input type="submit" value="Play Again">
            </form>
        </cfif>
    </div>
</body>
</html>
