#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess -t --no-align -c"
secret_number=$((RANDOM % 1001))
# echo "$secret_number"

echo -e "Enter your username:"
read username

# if the username is less or more than 22 characters
if [[ ! $username =~ [A-Za-z0-9]{22}$ ]]
then
    echo -e "usernames should be 22 characters."
else
  # the username is 22 characters
  CHECK_USER=$($PSQL "SELECT * FROM users WHERE username='$username'")
  # if user does not exist
  if [[ -z $CHECK_USER ]]
  then
      # insert the user
      INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$username')")
      if [[ $INSERT_USER_RESULT == 'INSERT 0 1' ]]
      then
          echo -e "Welcome, $username! It looks like this is your first time here."
      fi
  # if the user exists
  else
      # print some info to the user
      echo "$CHECK_USER" | while IFS="|" read USER_ID username games_played best_game
      do
        echo -e "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
      done
  fi
  # continue
  # change the number of games played by the user
  UPDATE_RESULT=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE username='$username'")
  
  # start the game
  number_of_guesses=0
  GUESSED_NUMBER=-90
  while [[ $GUESSED_NUMBER != $secret_number ]]
  do
      echo -e "Guess the secret number between 1 and 1000:"
      read GUESSED_NUMBER

      # if the input is not an integer
      if [[ ! $GUESSED_NUMBER =~ ^[0-9]+$ ]]
      then
          echo -e "That is not an integer, guess again:"
      else
          # lower guess
          if [[ $GUESSED_NUMBER -lt $secret_number ]]
          then
              echo -e "It's higher than that, guess again:"
          elif [[ $GUESSED_NUMBER -gt $secret_number ]]
          then
              echo -e "It's lower than that, guess again:"
          fi
      fi
      number_of_guesses=$(( $number_of_guesses + 1 ))
  done
  # successful guess

  # update the best game column
  USER_CURRENT_BEST_SCORE=$($PSQL "SELECT best_game FROM users WHERE username='$username'")
  if [[ $USER_CURRENT_BEST_SCORE -gt $number_of_guesses ]]
  then
        UPDATE_RESULT=$($PSQL "UPDATE users SET best_game = $number_of_guesses")
  fi
  # update the games_played column.
  USER_GAMES_UPDATE=$($PSQL "UPDATE users SET games_played = games_played + 1")

  echo -e "You guessed it in $number_of_guesses tries. The secret number was $secret_number. Nice job!"
 
fi