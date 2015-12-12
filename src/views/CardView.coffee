class window.CardView extends Backbone.View
  className: 'card'

  template: _.template '
    <div class="front" style="background-image:url(img/cards/<%= rankName %>-<%= suitName %>.png) "></div>
    <div class="back"></div>'

  initialize: -> @render()

  render: ->
    value = @model.get('value')
    if value == 1
      value = "ace" 
    suit = @model.get('suitName')


    @$el.children().detach()
    @$el.html @template @model.attributes


    @$el.addClass 'covered' unless @model.get 'revealed'

