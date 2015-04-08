Discontent = Backbone.Model.extend
  parse: (data)->
    return data

DiscontentCollection = Backbone.Collection.extend
  model: Discontent,
  url: "/project/4/discontent/posts"

DiscontentView = Backbone.View.extend
  template: JST['templates/discontent_view']

  render: ()->
    html = this.template(this.model.toJSON())
    newElement = $(html)
    this.$el.replaceWith(newElement);
    this.setElement(newElement);
    return this

DiscontentCollectionView = Backbone.View.extend
  id: 'tab_aspect_posts',
  className: 'row',

  initialize: ()->
    $('#filter li').on('click',this.loadByAspect, this)
    $('#tab_aspect_posts').isotope
      itemSelector: '.discontent-block',
      layoutMode: 'fitRows',
  render: ()->
    this.collection.forEach(this.addOne, this)
    return this
  addOne: (discontent)->
    discontentView = new DiscontentView({model: discontent});
    this.$el.append(discontentView.render().el);
  loadByAspect: ()->
    console.log view
    $('#tab_aspect_posts').isotope
      filter: $(this).data('aspect')



dc = new DiscontentCollection
dc.fetch
  success: (c,r)->
    dv = new DiscontentCollectionView({collection: dc})
    $('.stage-post-block').html(dv.render().el)
