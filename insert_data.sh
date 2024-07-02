#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
    then
    #get winning team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    #if not found
    if [[ -z $TEAM_ID ]]
      then
      #insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
        then
        echo Inserted $WINNER into teams table
      fi
      #get new team_id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi

    #get opponent team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    #if not found
    if [[ -z $TEAM_ID ]]
      then
      #insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
        then
        echo Inserted $OPPONENT into teams table
      fi
      #get new team_id
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi

    #insert game
      #get winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      #get opponent_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      #insert details
      INSERT_GAME_DETAILS=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
  fi
done