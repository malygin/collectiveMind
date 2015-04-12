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
  el: '#tab_aspect_posts',

  initialize: ()->
    this.collection.bind('add', this.renderNew, this);
    this.collection.bind('remove', this.removeOld, this);
    $('#filter').unbind('click').on('click', 'li', this.loadByAspect)
  render: ()->
    this.collection.forEach(this.addOne, this)
    this.$container =  $('#tab_aspect_posts').isotope
      itemSelector: '.discontent-block',
      layoutMode: 'fitRows'
    return this
  addOne: (discontent)->
    discontentView = new DiscontentView({model: discontent});
    this.$el.append(discontentView.render().el);
  renderNew: (newModel)->
    this.$container.isotope('insert', new DiscontentView({ model:newModel }).render().el);
  removeOld: (model)->
    console.log this.$container
    el = $('div[data-id="id-'+model.id+'"]')
    this.$container.isotope('remove', el);
  loadByAspect: (evt)->
    evt.preventDefault();
    console.log this
    dc.fetch
      data: $.param({aspect: $(this).data('aspect')})



dc = new DiscontentCollection
dc.fetch
  success: (col,res)->
    dv = new DiscontentCollectionView({collection: dc})
    dv.render()

