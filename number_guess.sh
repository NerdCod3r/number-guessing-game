#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

secret_number=$((RANDOM % 1000 + 1))

GAME_SPLASH(){
    echo -e "Enter your username:"
    read username

    # get user id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$username'")

    # if it's a new user
    if [[ -z $USER_ID ]]
    then
        # add user
         # insert the user
        INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$username')")
        if [[ $INSERT_USER_RESULT == 'INSERT 0 1' ]]
        then
            echo -e "Welcome, $username! It looks like this is your first time here."
            # initialize games_played and best_game
            games_played=0
            best_game=0
        fi
    # it is an already existing user
    else
        # get all the info using the USER_ID
INFO=$($PSQL "SELECT COUNT(user_id) AS games_played, COALESCE(MIN(score), 0) AS best_game, user_id, username FROM users LEFT JOIN games USING(user_id) WHERE user_id=$USER_ID GROUP BY user_id")

# check if user has any games played
if [[ -z $INFO ]]
then
    games_played=0
    best_game=0
    echo -e "\nWelcome back, $USERNAME! You have played $games_played games, and your best game took $best_game guesses."
else
    while IFS="|" read GAMES_PLAYED BEST_GAME USER_ID USERNAME
    do
        games_played=$GAMES_PLAYED
        best_game=$BEST_GAME
        echo -e "\nWelcome back, $USERNAME! You have played $games_played games, and your best game took $best_game guesses."
    done < <(echo "$INFO")
fi

    fi

    echo -e "Guess the secret number between 1 and 1000:"
    read g
}
GAME_SPLASH