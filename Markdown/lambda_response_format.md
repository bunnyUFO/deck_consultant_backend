# Lambda JSON Payload
When invoking lambdas user data will be returned in simpler JSON like this:

```json
{
  "user_id": "1",
  "username": "username",
  "gold": 100,
  "reputation": 0,
  "cards": {
    "block": 5,
    "slash": 5
  },
  "quests": {
    "pending": [{ 
      "id": "ffa22eab-3ba0-4e1e-a43b-3dc59ac877e4", 
      "scenario_id": 2, 
      "complete": false, 
      "random_seed": 2, 
      "duration": 60, 
      "remaining": 30
    }], 
    "complete": [{
      "id": "104decdb-6bf8-437b-ba8b-cd8f0aab58a2", 
      "scenario_id": 2, 
      "complete": true, 
      "random_seed": 2, 
      "duration": 60, 
      "remaining": 0
    }]
  }
}
```
user data is at the top level

`gold`: is currency used in game<br>
`reputation`: is used as player level and difficulty scaling to enable harder quests and better loot<br>

`cards`: each key inside is a card name and the values are the count in player library

`Pending quests`: are ones where user has not yet received a reward/punishment.<br>
`Completed quests`: are the inverse where user has received reward/punishment.<br>
`random_seed`: is used to calculate randomness in game, and allow for consistent quest replay logs.<br>
`scenario_id`: is used to look up the quest data from game assets<br>
`remaining`: is a calculated field from quest created date, time now, and duration. When duration reaches 0 and player is<br>
in game rewards/punishments are distributed<br>