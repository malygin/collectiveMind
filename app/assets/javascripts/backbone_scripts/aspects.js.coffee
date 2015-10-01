$.ajaxSetup
  cache: false

Aspect = Backbone.Model.extend
  parse: (data)->
    return data

AspectCollection = Backbone.Collection.extend
  model: Aspect,
  url: "/project/#{getProjectIdByUrl()}/aspect/posts"

AspectView = Backbone.View.extend
  template: JST['templates/post']
  render: ()->
    html = this.template(this.model.toJSON())
    newElement = $(html)
    this.setElement(newElement)
    return this

MainAspectCollectionView = Backbone.View.extend
  el: '#tab_main_aspects',

  render: ()->
    this.collection.where({ type_aspects: 'main_aspects' }).forEach(this.addOne, this)
    return this

  addOne: (aspect)->
    aspectView = new AspectView({model: aspect})
    this.$el.append(aspectView.render().el)

OtherAspectCollectionView = Backbone.View.extend
  el: '#tab_other_aspects',

  initialize: ()->
    $('#sorter').on('click', 'span', this.sortByAspect)

  render: ()->
    this.collection.where({ type_aspects: 'other_aspects' }).forEach(this.addOne, this)
    this.$container = $('#tab_other_aspects').shuffle
      itemSelector: '.md-post-block',
    return this

  addOne: (aspect)->
    aspectView = new AspectView({model: aspect})
    this.$el.append(aspectView.render().el)

  sortByAspect: ()->
    sortByValue = $(this).data('type')
    opts =
      reverse: true
      by: ($el) ->
        $el.data sortByValue
    $('#tab_other_aspects').shuffle 'sort', opts

# only for aspect url
if isProcedurePage("aspect/posts")
  dc = new AspectCollection
  dc.fetch
    success: (col,res)->
      dv = new MainAspectCollectionView({collection: dc})
      dv.render()
      dvv = new OtherAspectCollectionView({collection: dc})
      dvv.render()
