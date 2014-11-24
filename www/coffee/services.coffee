angular.module("starter.services", [])
  .factory "Friends", ->
    friends = [
      {
        id: 0
        name: "This is awesome"
      }
      {
        id: 1
        name: "G.I. Joe"
      }
      {
        id: 2
        name: "Miss Frizzle"
      }
      {
        id: 3
        name: "Ash Ketchum"
      }
    ]

    all: ->
      friends

    get: (friendId) ->
      friends[friendId]
