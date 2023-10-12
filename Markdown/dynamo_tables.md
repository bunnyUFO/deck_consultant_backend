# Dynamoid Intro
This project uses [dynamoid](https://github.com/Dynamoid/dynamoid) gem which mimicks active record models (used in rails) with dyanmodb instead.<br>
Tables are automatically created when the first write operation happens, but can also be preemptively created.

Instead of Active Record models, dunamoid uses `Dynamoid::Document` module but for clarity will continue to call them models.<br>
The models and other shared code id defined in lambda layers under `layers/ruby/lib` for reusability.

`updated_at` and `created_at` are automatically generated fields with timestamps of creations and updates.

# Users Table
User table is defined by [user dynamoid model](/layer/ruby/lib/user.rb)

Dynamo data example
```json
{
  "Item": {
    "gold": {
      "N": "100"
    },
    "quests_ids": {
      "SS": [
        "013c3890-1ca0-45cd-8dee-df25a9cd0552",
        "d7ca10ad-6c61-446e-b23f-8a734cccc6c4"
      ]
    },
    "updated_at": {
      "N": "1697113769.427479331"
    },
    "user_id": {
      "S": "1"
    },
    "card_counts": {
      "M": {
        "slash": {
          "N": "5"
        },
        "block": {
          "N": "5"
        }
      }
    },
    "reputation": {
      "N": "0"
    },
    "created_at": {
      "N": "1697113593.470108537"
    },
    "username": {
      "S": "username"
    }
  }
}
```
`id`: is cognito sub attribute used as primary key (ther is no sorting key)<br>
`username`: username is cognito username attribute<br>
`gold`: number for users gold amount used to buy new booster-packs and quire cards<br>
`reputation`: number for users reputation acting like experience to manage difficulty in game<br>
`cards`: map where each key is string card name and value is number of cards owned in library of that name<br>+
`quests`: array of quest ids which are stored in another dynamo db table<br>


Dynamoid automatically creates another table for card_counts because of has many association with custom field `Quest`.<br>
This is not optimized, as everything could be stored in a single table and access data with less web calls.<br>
However, okay with it for now for ease of use. In a commercial product with lots of users may be worth doing single table design.<br>

# Quests Table
Card Counts table is defined by [quest dynamoid model](/layer/ruby/lib/quest.rb)

```json
{
  "Item": {
    "random_seed": {
      "N": "2"
    },
    "duration": {
      "N": "60"
    },
    "updated_at": {
      "N": "1697113818.894610561"
    },
    "deck": {
      "M": {
        "slash": {
          "N": "5"
        },
        "block": {
          "N": "5"
        }
      }
    },
    "created_at": {
      "N": "1697113769.401159216"
    },
    "id": {
      "S": "013c3890-1ca0-45cd-8dee-df25a9cd0552"
    },
    "complete": {
      "BOOL": true
    },
    "scenario_id": {
      "N": "2"
    }
  }
}
```
`id`: string and primary key to loo up card counts<br>
`scenario_id`: number used to look up quest data once in game<br>
`complete`: boolean representing if quest is complete whether it was success or failure<br>
`duration`: number duration in seconds from start of quest until finish, can be used to calculate time remaining<br>
`random_seed`: number used to calculate randomness when evaluating quest result<br>
`deck`: map to represent deck loaned to adventurer on quest where each key is string card name and value is number of cards<br>