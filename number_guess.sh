#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

secret_number=$(($RANDOM % 1000 + 1))

echo -e "Enter your username:"
read username

CHECK_USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$username'")

if [[ -z $CHECK_USER_ID ]]
then
    echo -e "Welcome, $username! It looks like this is your first time here."
else
    games_played=$($PSQL "SELECT COUNT(score) FROM games WHERE user_id=$CHECK_USER_ID")
    best_game=$($PSQL "SELECT MIN(score) FROM games WHERE user_id=$CHECK_USER_ID")

   echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
fi

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
      number_of_guesses=$(( number_of_guesses + 1 ))
done

echo -e "You guessed it in $number_of_guesses tries. The secret number was $secret_number. Nice job!"
