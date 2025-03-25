# 🎲 Number Guessing Game

A simple Bash-based number guessing game that interacts with a PostgreSQL database to track user statistics.

---

## 📌 Features
✔️ Stores user data and game history in a PostgreSQL database  
✔️ Differentiates between new and returning players  
✔️ Tracks total games played and best (lowest guess count) game  
✔️ Provides hints if the guess is too high or too low  

---

## 🛠️ Installation

### 1️⃣ Clone the repository
```sh
git clone https://github.com/NerdCod3r/number-guessing-game.git
cd number-guessing-game  
```
### 2️⃣ Setup PostgreSQL Database
```sh
CREATE DATABASE number_guess;

\c number_guess

CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE games (
  user_id INT REFERENCES users(user_id),
  score INT NOT NULL
);  
```
## 🚀 Usage  
### 1️⃣ Run the script
```sh
bash number_guess.sh
```
### 2️⃣ Enter a username:  
• If you're a **new user** , it will greet you and register your name.  
• If you're a returning user, it will display your past performance.  

### 3️⃣ Guess the number!  
• The script will generate a random number between **1** **and** **1000**.
• Enter a number and follow the hints until you guess correctly.  
### 4️⃣ Game completion!  
• The program will congratulate you and save your game result in the database.  

## 📜 Example Output
```sh
Enter your username:
SuperLongUsername_123

Welcome back, SuperLongUsername_123! You have played 5 games, and your best game took 3 guesses.

Guess the secret number between 1 and 1000:  
500  
It's lower than that, try again:  
250  
It's higher than that, try again:  
300  
It's lower than that, try again:  
275  
You guessed it in 4 tries. The secret number was 275. Nice job!  
```  
## ⚙️ Troubleshooting  
• If the script doesn't run, ensure it has executable permissions:
```sh
chmod +x number_guess.sh
```  
• Make sure PostgreSQL is running before executing the script.  
• Usernames must be **22 characters or fewer**.  
## 🎯 Future Improvements  
• Add a leaderboard system  
• Implement difficulty levels  
• Convert to a Python version with a GUI  
## 📜 License
This project is open-source and free to use.

