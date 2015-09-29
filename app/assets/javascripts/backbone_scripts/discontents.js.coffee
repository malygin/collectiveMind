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
    this.$container = $('#tab_aspect_posts').shuffle
      itemSelector: '.md-post-block'
    colors_for_content()
    return this

  addOne: (discontent)->
    discontentView = new DiscontentView({model: discontent})
    this.$el.append(discontentView.render().el)

  loadByAspect: (evt)->
    evt.preventDefault()
    groupName = $(this).find('input:checked').parent().data('group')
    if groupName == '#'
      $('#tab_aspect_posts').shuffle 'shuffle', ($el, shuffle) ->
        $el.data('groups').toString().indexOf('aspect') == -1
    else
      $('#tab_aspect_posts').shuffle 'shuffle', groupName

  sortByAspect: ()->
    sortByValue = $(this).data('type')
    opts =
      reverse: true
      by: ($el) ->
        $el.data sortByValue
    $('#tab_aspect_posts').shuffle 'sort', opts

# only for discontents url
if isProcedurePage("discontent/posts")
  dc = new DiscontentCollection
  dc.fetch
    success: (col,res)->
      dv = new DiscontentCollectionView({collection: dc})
      dv.render()

