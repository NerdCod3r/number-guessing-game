#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --no-align -t -c"
NUMBER_TO_GUESS=$(($RANDOM%5))
# echo "$NUMBER_TO_GUESS"

echo -e "Enter your username:"
read username

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
  GUESSED_NUMBER=-90
  while [[ $GUESSED_NUMBER != $NUMBER_TO_GUESS ]]
  do
      echo -e "Guess the secret number between 1 and 5:"
      read GUESSED_NUMBER

      # if the input is not an integer
      if [[ ! $GUESSED_NUMBER =~ ^[0-9]+$ ]]
      then
          echo -e "That is not an integer, guess again:"
      else
          # lower guess
          if [[ $GUESSED_NUMBER -lt $NUMBER_TO_GUESS ]]
          then
              echo -e "It's higher than that, guess again:"
          elif [[ $GUESSED_NUMBER -gt $NUMBER_TO_GUESS ]]
          then
              echo -e "It's lower than that, guess again:"
          fi
      fi
      GUESSES=$(( $GUESSES + 1 ))
  done
  # successful guess
  echo -e "You guessed it in $GUESSES tries. The secret number was $NUMBER_TO_GUESS. Nice job!"

  # update the user row in the database.
 
fi