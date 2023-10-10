# Dynamoid Intro
This project uses [dynamoid](https://github.com/Dynamoid/dynamoid) gem which mimicks active record models (used in rails) with dyanmodb instead.<br>
Tables are automatically created when the first write operation happens, but can also be preemptively created.

Instead of Active Record models, dunamoid uses `Dynamoid::Document` module but for clarity will continue to call them models.<br>
The models and other shared code id defined in lambda layers under `layers/ruby/lib` for reusability.

`updated_at` and `created_at` are automatically generated fields with timestamps of creations and updates.


# Lambda JSON Payload
When invoking lambdas user data will be returned in a simpler JSON like this:
```json
{
  "user_id": "1",
  "username": "username",
  "gold": 100,
  "reputation": 0,
  "cards": {
    "block": 5,
    "slash": 5
  }
}
```

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
        "1c052be4-24c7-4ed0-8052-cb17af35ccc9",
        "984aced5-c296-42a3-a0ab-2bc310f021d4"
      ]
    },
    "updated_at": {
      "N": "1696924655.274203842"
    },
    "id": {
      "S": "1"
    },
    "reputation": {
      "N": "0"
    },
    "created_at": {
      "N": "1696924655.186389408"
    },
    "username": {
      "S": "username"
    }
  }
}
```
`id`: is cognito sub attribute used as primary key (ther is no sorting key)<br>
`username`: username is cognito username attribute<br>
`gold`: is the users gold amount used to buy new booster-packs and quire cards<br>
`reputation`: is the users gold amount used to buy new booster-packs and quire cards<br>
`cards`: array of card count ids which are stored in another dynamo db table<br> 

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
`count`: integer count of how many of that card in library<br>

