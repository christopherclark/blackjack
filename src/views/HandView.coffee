class window.HandView extends Backbone.View
  className: 'hand'

  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %></h2>'

  initialize: ->
    @collection.on 'add remove change', => @render()
    @render()
    @collection.on 'reveal', -> 
      $('.covered').removeClass 'covered'

  render: ->
    @$el.children().detach()
    @$el.html @template @collection
    @$el.append @collection.map (card) ->
      new CardView(model: card).$el
    @$('.score').text @collection.scores()[0]
