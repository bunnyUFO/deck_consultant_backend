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
    "card_counts_ids": {
      "SS": [
        "56a699e1-8827-44dd-87e5-cb1ea2f2a746",
        "8afd053f-bff6-47fa-9cf6-dfa830df0c75"
      ]
    },
    "quests_ids": {
      "SS": [
        "104decdb-6bf8-437b-ba8b-cd8f0aab58a2",
        "ffa22eab-3ba0-4e1e-a43b-3dc59ac877e4"
      ]
    },
    "updated_at": {
      "N": "1696942346.008867927"
    },
    "user_id": {
      "S": "1"
    },
    "reputation": {
      "N": "0"
    },
    "created_at": {
      "N": "1696942208.76828924"
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
`cards`: array of card count ids which are stored in another dynamo db table<br>
`quests`: array of quest ids which are stored in another dynamo db table<br>


Dynamoid automatically creates another table for card_counts because of has many association with custom field `CardCount`.<br>
This is not optimized, as everything could be stored in a single table and access data with less web calls.<br>
However, okay with it for now for ease of use. In a commercial product with lots of users may be worth doing single table design.

# Card Counts Table
Card Counts table is defined by [card counts dynamoid model](/layer/ruby/lib/card_count.rb)

```json
{
    "Item": {
        "card_name": {
            "S": "block"
        },
        "count": {
            "N": "5"
        },
        "created_at": {
            "N": "1696924655.247047191"
        },
        "id": {
            "S": "1c052be4-24c7-4ed0-8052-cb17af35ccc9"
        },
        "updated_at": {
            "N": "1696924655.247062968"
        }
    }
}
```

`id`: string and primary key to loo up card counts<br>
`card_name`: string name for the card<br>
`count`: number count of how many of that card in library<br>

# Quests Table
Card Counts table is defined by [card counts dynamoid model](/layer/ruby/lib/quest.rb)

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
      "N": "1696942425.946585043"
    },
    "created_at": {
      "N": "1696942345.984931951"
    },
    "id": {
      "S": "104decdb-6bf8-437b-ba8b-cd8f0aab58a2"
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
`random_seed`: used to calculate randomness when evaluating quest result<br>
