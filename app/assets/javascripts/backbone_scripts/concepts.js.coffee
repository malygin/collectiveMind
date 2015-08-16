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
    this.$container =  $('#tab_dispost_concepts').isotope
      itemSelector: '.md-post-block',
      layoutMode: 'fitRows',
      getSortData:
        comment: '[data-comment] parseFloat',
        date: '[data-date] parseFloat'

    return this

  addOne: (concept)->
    conceptView = new ConceptView({model: concept})
    this.$el.append(conceptView.render().el)

  loadByDiscontent: (evt)->
    evt.preventDefault()
    filterValue = $(this).data('discontent')
    $('#tab_dispost_concepts').isotope
      filter: filterValue

  sortByDiscontent: ()->
    sortByValue = $(this).data('type')
    $('#tab_dispost_concepts').isotope
      sortBy: sortByValue,
      sortAscending: false

# only for concept url
if isProcedurePage("concept/posts")
  dc = new ConceptCollection
  dc.fetch
    success: (col,res)->
      dv = new ConceptCollectionView({collection: dc})
      dv.render()

