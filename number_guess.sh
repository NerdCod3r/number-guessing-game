#!/bin/bash

# Database command shortcut
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Ask for username
echo -e "\nEnter your username:"
read USERNAME

# Check if user exists
USER_INFO=$($PSQL "SELECT user_id, username FROM users WHERE username='$USERNAME'")

if [[ -z $USER_INFO ]]
then
  # New user
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  
  # Insert user into database
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  
  # Get new user ID
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
  # Existing user
  IFS="|" read USER_ID USERNAME <<< "$USER_INFO"

  # Get game history
  USER_STATS=$($PSQL "SELECT COUNT(user_id) AS games_played, COALESCE(MIN(score), 0) AS best_game FROM games WHERE user_id=$USER_ID")

  # Read stats into variables
  IFS="|" read GAMES_PLAYED BEST_GAME <<< "$USER_STATS"

  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Generate random number (1-1000)
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
GUESSES=0
USER_GUESS=-1

echo -e "\nGuess the secret number between 1 and 1000:"

# Game loop
while [[ $USER_GUESS -ne $SECRET_NUMBER ]]
do
  read USER_GUESS

  # Check if input is a valid number
  if ! [[ "$USER_GUESS" =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    continue
  fi

  ((GUESSES++))

  if [[ $USER_GUESS -lt $SECRET_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  elif [[ $USER_GUESS -gt $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  fi
done

# Game won
echo -e "\nYou guessed it in $GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

# Save game result
SAVE_RESULT=$($PSQL "INSERT INTO games(user_id, score) VALUES($USER_ID, $GUESSES)")

