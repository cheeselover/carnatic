angular.module("carnatic.services", [])

.factory "Korvais", ->
  korvais = [
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
    korvais

  get: (korvaiId) ->
    korvais[korvaiId]
