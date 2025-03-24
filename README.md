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


