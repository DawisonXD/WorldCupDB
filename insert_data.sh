#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")


cat "games.csv" | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

if [[  $YEAR != year ]]
then
#get unique team_id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

if [[ -z $WINNER_ID ]]
then 
#add to table
INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
if [[ $INSERT_WINNER_RESULT = "INSERT 0 1"  ]]
then
echo $WINNER inserted into teams table
fi
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
fi

OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")"
if [[ -z $OPPONENT_ID ]]
then 
#add to table
INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
if [[ $INSERT_OPPONENT_RESULT = "INSERT 0 1" ]]
then
echo $OPPONENT inserted into teams table
fi
OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")"
fi
fi
done

cat "games.csv" | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

if [[ $YEAR != year ]]
then
#get winner_id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
#if not found
#insert major
INSERT_WINNER_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
if [[ $INSERT_WINNER_RESULT = "INSERT 0 1" ]]
then
echo $WINNER VS $OPPONENT inserted into games table
fi

fi
done
