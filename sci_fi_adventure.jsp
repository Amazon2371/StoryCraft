<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Science Fiction Adventure</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f8ff;
            color: #333;
            text-align: center;
        }
        #story {
            margin: 20px;
            padding: 20px;
            background-color: #e6e6fa;
            border-radius: 10px;
        }
        h1 {
            color: #4b0082;
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px;
            background-color: #4b0082;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }
        .button:hover {
            background-color: #7b68ee;
        }
        .hidden {
            display: none;
        }
        form {
            margin-top: 20px;
        }
        #topLeftButton {
            position: absolute;
            top: 10px;
            left: 10px;
            background-color: #4b0082;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            padding: 10px 20px;
            text-decoration: none;
        }
        #topLeftButton:hover {
            background-color: #7b68ee;
        }
         #exitButton {
            position: fixed;
            bottom: 10px;
            right: 10px;
            background-color: #4b0082;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            padding: 10px 20px;
            text-decoration: none;
        }
        #exitButton:hover {
            background-color: #7b68ee;
        }
    </style>
</head>
<body>
    <a id="topLeftButton" href="save_load.jsp">Save/Load</a>
    <h1>Welcome to Sci-Fi Adventure</h1>
    <p>You find yourself on the Planet of Lemuria, a place where science is so advanced.</p>
    <p>Choose your path wisely...</p>
    <div id="story"></div>
    <button id="startButton" class="button" onclick="startAdventure()">Start Adventure</button>
    <button id="retryButton" class="button hidden" onclick="location.reload()">Try Again</button>
    <button id="exitButton" class="button" onclick="goBack()">Exit</button>
    <script>
    var attributes = {
        patriot: 0,
        exploration: 0,
        peaceful: 0
    };
    var totalChoices = {
        patriot: 0,
        exploration: 0,
        peaceful: 0
    };
    var missionNumber = 1;
    var chapter2MissionNumber = 1;
    var chapter2Missions = 5;
    var gameOver = false;
    var gameState = '';

    var missions = [
        {
            description: "You find yourself on the Planet of Lemuria in the Lamar System. You bought yourself equipment and supplies. You are a Lemurian citizen. Then you board your ship. Where will you go?    (1-Planet Heinessen 2-Planet Odin 3-Stay on Lemuria)",
            effects: [2, 2, 0]
        },
        {
            description: "You've heard news that war will break out between the Lemurian Galactic Empire and the Galactic Tempest Federation. Will you (1-Enlist 2-Don't Enlist 3-Protest for peace)?",
            effects: [1, 2, 3]
        },
        {
            description: "You saw the daughter of the Emperor of the Lemurian Empire has been kidnapped. Will you (1-Rescue 2-Look the other way 3-Call the Police)?",
            effects: [1, 0, 3]
        },
        {
            description: "A mysterious portal holds secrets and it seems to lead to another universe. You find yourself in a world called Eldoria. Will you (1-Explore by yourself 2-Don't Explore 3-Ask for Help from the Locals)?",
            effects: [2, 0, 3]
        },
        {
            description: "There is a war between the forces of Lemuria and the forces of the Tempest Federation. Will you (1-Join the battle 2-Let it settle by itself 3-Negotiate for Peace)?",
            effects: [1, 0, 3]
        },
        {
            description: "A stranger offers you a chance to join a secret mission. Will you (1-Join 2-Refuse 3-Ask for more information)?",
            effects: [2, 0, 2]
        },
        {
            description: "You discover an ancient artifact. Will you (1-Keep it 2-Sell it 3-Donate it to a museum)?",
            effects: [2, 2, 3]
        },
        {
            description: "You encounter a wounded alien. Will you (1-Help 2-Ignore 3-Take it to authorities)?",
            effects: [3, 0, 3]
        },
        {
            description: "A portal to another universe appears. Will you (1-Enter 2-Avoid 3-Investigate further)?",
            effects: [2, 0, 2]
        }
    ];

    var chapter2MissionsList = [
        {
            description: "Chapter 2 - Mission 1: The Lemurian government offers you a chance to join a covert ops mission. What will you do? (1-Join the mission 2-Refuse 3-Request more details)",
            effects: [1, 2, 3]
        },
        {
            description: "Chapter 2 - Mission 2: An alien species seeks help to protect their world from an asteroid. How will you respond? (1-Help them 2-Ignore 3-Alert Lemurian authorities)",
            effects: [3, 0, 1]
        },
        {
            description: "Chapter 2 - Mission 3: You find an ancient map leading to a hidden treasure. What's your choice? (1-Search for the treasure 2-Leave it alone 3-Share the map with the government)",
            effects: [2, 0, 1]
        },
        {
            description: "Chapter 2 - Mission 4: Your ship's AI suggests a shortcut through a dangerous nebula. What will you choose? (1-Take the shortcut 2-Avoid the nebula 3-Consult with experts first)",
            effects: [2, 0, 3]
        },
        {
            description: "Chapter 2 - Mission 5: You meet a rebel group planning to overthrow the Tempest Federation. What do you do? (1-Join them 2-Stay neutral 3-Try to negotiate peace)",
            effects: [1, 0, 3]
        }
    ];

    function startAdventure() {
        document.getElementById('startButton').classList.add('hidden');
        if (sessionStorage.getItem('game_state')) {
            loadGameState(sessionStorage.getItem('game_state'));
        } else {
            showMission(missionNumber);
        }
    }

    function showMission(missionNumber) {
        var storyDiv = document.getElementById('story');
        storyDiv.innerHTML = '';
        var mission = missions[missionNumber - 1];

        var p = document.createElement('p');
        p.textContent = mission.description;
        storyDiv.appendChild(p);

        for (var i = 1; i <= 3; i++) {
            var button = document.createElement('button');
            button.textContent = i;
            button.className = 'button';
            button.onclick = (function(choice) {
                return function() {
                    selectChoice(choice);
                };
            })(i);
            storyDiv.appendChild(button);
        }
    }

    function selectChoice(choice) {
        handleMissionChoice(choice);
    }

    function handleMissionChoice(choice) {
        var storyDiv = document.getElementById('story');
        var currentMission = missions[missionNumber - 1];

        if (!handleMission(currentMission, choice, storyDiv)) {
            gameOver = true;
            document.getElementById('retryButton').classList.remove('hidden');
            return false;
        }

        saveGameState();

        missionNumber++;
        if (missionNumber <= missions.length && !gameOver) {
            showMission(missionNumber);
        } else if (!gameOver) {
            promptChapter2(storyDiv);
        }

        return false;
    }

    function handleMission(mission, choice, storyDiv) {
        if (choice < 1 || choice > 3) {
            var invalidChoice = document.createElement('p');
            invalidChoice.textContent = 'Invalid Choice';
            storyDiv.appendChild(invalidChoice);
            return false;
        }

        var effect = mission.effects[choice - 1];
        updateScore(effect);
        displayTotalChoices(storyDiv);
        return true;
    }

    function updateScore(effect) {
        if (effect === 1) {
            attributes.patriot += 1;
            totalChoices.patriot += 1;
        } else if (effect === 2) {
            attributes.exploration += 1;
            totalChoices.exploration += 1;
        } else if (effect === 3) {
            attributes.peaceful += 1;
            totalChoices.peaceful += 1;
        }
    }

    function displayTotalChoices(storyDiv) {
        var totalChoicesText = "Total Choices: Patriot: " + totalChoices.patriot + ", Exploration: " + totalChoices.exploration + ", Peaceful: " + totalChoices.peaceful;
        var highestAttribute = Math.max(attributes.patriot, attributes.exploration, attributes.peaceful);
        var title = '';

        if (highestAttribute === attributes.patriot) {
            title = 'Medal of Valor';
        } else if (highestAttribute === attributes.exploration) {
            title = 'Galactic Explorer';
        } else if (highestAttribute === attributes.peaceful) {
            title = 'Peacekeeper';
        }

        var choices = document.createElement('p');
        choices.innerHTML = totalChoicesText;
        storyDiv.appendChild(choices);

        var titleText = document.createElement('p');
        titleText.innerHTML = "Title: " + title;
        storyDiv.appendChild(titleText);
    }

    function promptChapter2(storyDiv) {
        var p = document.createElement('p');
        p.innerHTML = 'You have completed Chapter 1. Do you want to continue to Chapter 2?';
        storyDiv.appendChild(p);

        var yesButton = document.createElement('button');
        yesButton.className = 'button';
        yesButton.textContent = 'Yes';
        yesButton.onclick = startChapter2;
        storyDiv.appendChild(yesButton);

        var noButton = document.createElement('button');
        noButton.className = 'button';
        noButton.textContent = 'No';
        noButton.onclick = function() {
            location.reload();
        };
        storyDiv.appendChild(noButton);
    }

    function startChapter2() {
        var storyDiv = document.getElementById('story');
        storyDiv.innerHTML = '';
        var highestAttribute = Math.max(attributes.patriot, attributes.exploration, attributes.peaceful);
        var message = '';

        if (highestAttribute === attributes.patriot) {
            message = 'You have earned the Medal of Valor!';
        } else if (highestAttribute === attributes.exploration) {
            message = 'You have become a Galactic Explorer!';
        } else if (highestAttribute === attributes.peaceful) {
            message = 'You have been awarded the Peacekeeper title!';
        }

        var messageP = document.createElement('p');
        messageP.textContent = message;
        storyDiv.appendChild(messageP);

        showChapter2Mission(chapter2MissionNumber);
    }

    function showChapter2Mission(missionNumber) {
        var storyDiv = document.getElementById('story');
        storyDiv.innerHTML = '';
        var mission = chapter2MissionsList[missionNumber - 1];

        var p = document.createElement('p');
        p.textContent = mission.description;
        storyDiv.appendChild(p);

        for (var i = 1; i <= 3; i++) {
            var button = document.createElement('button');
            button.textContent = i;
            button.className = 'button';
            button.onclick = (function(choice) {
                return function() {
                    selectChapter2Choice(choice);
                };
            })(i);
            storyDiv.appendChild(button);
        }
    }

    function selectChapter2Choice(choice) {
        handleChapter2Choice(choice);
    }

    function handleChapter2Choice(choice) {
        var storyDiv = document.getElementById('story');
        var currentMission = chapter2MissionsList[chapter2MissionNumber - 1];

        if (!handleMission(currentMission, choice, storyDiv)) {
            gameOver = true;
            document.getElementById('retryButton').classList.remove('hidden');
            return false;
        }

        saveGameState();

        chapter2MissionNumber++;
        if (chapter2MissionNumber <= chapter2Missions && !gameOver) {
            showChapter2Mission(chapter2MissionNumber);
        } else {
            var completedMessage = document.createElement('p');
            completedMessage.textContent = 'Chapter 2 completed!';
            storyDiv.appendChild(completedMessage);
            document.getElementById('retryButton').classList.remove('hidden');
        }

        return false;
    }
    
    function saveGameState() {
        var gameStateObj = {
            attributes: attributes,
            totalChoices: totalChoices,
            missionNumber: missionNumber,
            chapter2MissionNumber: chapter2MissionNumber,
            gameOver: gameOver
        };
        gameState = JSON.stringify(gameStateObj);
        sessionStorage.setItem('game_state', gameState);
    }

    function loadGameState(gameState) {
        var gameStateObj = JSON.parse(gameState);
        attributes = gameStateObj.attributes;
        totalChoices = gameStateObj.totalChoices;
        missionNumber = gameStateObj.missionNumber;
        chapter2MissionNumber = gameStateObj.chapter2MissionNumber;
        gameOver = gameStateObj.gameOver;

        if (missionNumber <= missions.length && !gameOver) {
            showMission(missionNumber);
        } else if (!gameOver) {
            promptChapter2(document.getElementById('story'));
        } else {
            document.getElementById('retryButton').classList.remove('hidden');
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        if (sessionStorage.getItem('game_state')) {
            loadGameState(sessionStorage.getItem('game_state'));
        }
    });
    
    function goBack() {
        window.location.href = 'menu.jsp';
    }
</script>
</body>
</html>
