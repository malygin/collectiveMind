$.ajaxSetup
  cache: false

Concept = Backbone.Model.extend
  parse: (data)->
    return data

ConceptCollection = Backbone.Collection.extend
  model: Concept,
  url: "/project/#{getProjectIdByUrl()}/concept/posts"

ConceptView = Backbone.View.extend
  template: JST['templates/post']
  render: ()->
    html = this.template(this.model.toJSON())
    newElement = $(html)
    this.setElement(newElement)
    return this

ConceptCollectionView = Backbone.View.extend
  el: '#tab_dispost_concepts',

  initialize: ()->
    $('#filter').on('click', '.checkox_item', this.loadByDiscontent)
    $('#sorter').on('click', 'span', this.sortByDiscontent)

  render: ()->
    this.collection.forEach(this.addOne, this)
    this.$container = $('#tab_dispost_concepts').shuffle
      itemSelector: '.md-post-block'
    colors_for_content()
    return this

  addOne: (concept)->
    conceptView = new ConceptView({model: concept})
    this.$el.append(conceptView.render().el)

  loadByDiscontent: (evt)->
    evt.preventDefault()
    groupName = $(this).data('group')
    $('#tab_dispost_concepts').shuffle 'shuffle', groupName

  sortByDiscontent: ()->
    sortByValue = $(this).data('type')
    opts =
      reverse: true
      by: ($el) ->
        $el.data sortByValue
    $('#tab_dispost_concepts').shuffle 'sort', opts

# only for concept url
if isProcedurePage("concept/posts")
  dc = new ConceptCollection
  dc.fetch
    success: (col,res)->
      dv = new ConceptCollectionView({collection: dc})
      dv.render()

