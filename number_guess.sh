#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --no-align -t -c"
NUMBER_TO_GUESS=$(($RANDOM%1001))
# echo "$NUMBER_TO_GUESS"

echo -e "Enter your username:"
read USERNAME

# if the username is less or more than 22 characters
if [[ ! $USERNAME =~ [A-Za-z0-9]{22}$ ]]
then
    echo -e "usernames should be 22 characters."
else
  # the username is 22 characters
  CHECK_USER=$($PSQL "SELECT * FROM users WHERE username='$USERNAME'")
  # if user does not exist
  if [[ -z $CHECK_USER ]]
  then
      # insert the user
      INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
      if [[ $INSERT_USER_RESULT == 'INSERT 0 1' ]]
      then
          echo -e "Welcome $USERNAME! It looks like this is your first time here."
      fi
  # if the user exists
  else
      # print some info to the user
      echo "$CHECK_USER" | while IFS="|" read USER_ID USERNAME GAMES_PLAYED BEST_SCORE
      do
        echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_SCORE guesses."
      done
  fi
  # continue
  # change the number of games played by the user
  UPDATE_RESULT=$($PSQL "UPDATE users SET total_games_played= total_games_played + 1 WHERE username='$USERNAME'")
  
  # start the game
  GUESSES=0
  GUESSED_NUMBER=0
  while [[ $GUESSED_NUMBER != $NUMBER_TO_GUESS ]]
  do
      echo -e "Guess the secret number between 1 and 1000:"
      read GUESSED_NUMBER
      (( $GUESSES = $GUESSES + 1 ))
      echo "Guess #$GUESSES"
  done
fi