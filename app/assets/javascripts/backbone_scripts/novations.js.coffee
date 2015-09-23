$.ajaxSetup
  cache: false

Novation = Backbone.Model.extend
  parse: (data)->
    return data

NovationCollection = Backbone.Collection.extend
  model: Novation,
  url: "/project/#{getProjectIdByUrl()}/novation/posts"

NovationView = Backbone.View.extend
  template: JST['templates/post']
  render: ()->
    html = this.template(this.model.toJSON())
    newElement = $(html)
    this.setElement(newElement)
    return this

NovationCollectionView = Backbone.View.extend
  el: '#tab_concept_novations',

  initialize: ()->
    $('#sorter').on('click', 'span', this.sortByConcept)

  render: ()->
    this.collection.forEach(this.addOne, this)
    this.$container = $('#tab_concept_novations').shuffle
      itemSelector: '.md-post-block'
    return this

  addOne: (novation)->
    novationView = new NovationView({model: novation})
    this.$el.append(novationView.render().el)

  sortByConcept: ()->
    sortByValue = $(this).data('type')
    opts =
      reverse: true
      by: ($el) ->
        $el.data sortByValue
    $('#tab_concept_novations').shuffle 'sort', opts

# only for novation url
if isProcedurePage("novation/posts")
  dc = new NovationCollection
  dc.fetch
    success: (col,res)->
      dv = new NovationCollectionView({collection: dc})
      dv.render()

