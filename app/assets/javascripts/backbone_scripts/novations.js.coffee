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
    this.$container =  $('#tab_concept_novations').isotope
      itemSelector: '.post-block',
      layoutMode: 'fitRows',
      getSortData:
        comment: '[data-comment] parseFloat',
        date: '[data-date] parseFloat'

    return this

  addOne: (novation)->
    novationView = new NovationView({model: novation})
    this.$el.append(novationView.render().el)

  sortByConcept: ()->
    sortByValue = $(this).data('type')
    $('#tab_concept_novations').isotope
      sortBy: sortByValue,
      sortAscending: false

# only for novation url
if isProcedurePage("novation/posts")
  dc = new NovationCollection
  dc.fetch
    data: $.param({last_time_visit: $('#sorter').data('visit')})
    success: (col,res)->
      dv = new NovationCollectionView({collection: dc})
      dv.render()

