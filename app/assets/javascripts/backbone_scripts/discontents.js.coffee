$.ajaxSetup
  cache: false

Discontent = Backbone.Model.extend
  parse: (data)->
    return data

DiscontentCollection = Backbone.Collection.extend
  model: Discontent,
  url: "/project/#{getProjectIdByUrl()}/discontent/posts"

DiscontentView = Backbone.View.extend
  template: JST['templates/post']
  render: ()->
    html = this.template(this.model.toJSON())
    newElement = $(html)
    this.setElement(newElement)
    return this

DiscontentCollectionView = Backbone.View.extend
  el: '#tab_aspect_posts',

  initialize: ()->
    $('#filter').on('change', this.loadByAspect)
    $('#sorter').on('click', 'span', this.sortByAspect)

  render: ()->
    this.collection.forEach(this.addOne, this)
    this.$container =  $('#tab_aspect_posts').isotope
      itemSelector: '.md-post-block',
      layoutMode: 'fitRows',
      getSortData:
        comment: '[data-comment] parseFloat',
        date: '[data-date] parseFloat'

    return this

  addOne: (discontent)->
    discontentView = new DiscontentView({model: discontent})
    this.$el.append(discontentView.render().el)

  loadByAspect: (evt)->
    evt.preventDefault()
    filterValue =  $(this).find('input:checked').parent().data('aspect')
    filterValue = ':not([class*="aspect"])' if filterValue == '#'
    $('#tab_aspect_posts').isotope
      filter: filterValue

  sortByAspect: ()->
    sortByValue = $(this).data('type')
    $('#tab_aspect_posts').isotope
      sortBy: sortByValue,
      sortAscending: false

# only for discontents url
if isProcedurePage("discontent/posts")
  dc = new DiscontentCollection
  dc.fetch
    data: $.param({last_time_visit: $('#sorter').data('visit')})
    success: (col,res)->
      dv = new DiscontentCollectionView({collection: dc})
      dv.render()

