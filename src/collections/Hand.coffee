class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop())

  stand: ->
    console.log('stand', @)
    @trigger('stand')
    

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + card.get 'value'
  , 0

  maxScore: -> @minScore() + 10 * @hasAce()

  bestScore: ->
    Math.max.apply(null, [@minScore(), @maxScore()].map (item)-> 
      if 21 - item < 0 then 0 
      else item
    )

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @maxScore(), @bestScore()]

  reveal: ->
    @trigger('reveal')

  #money:
    
    

