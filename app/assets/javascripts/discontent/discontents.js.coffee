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
    this.collection.bind('add', this.renderNew, this);
    this.collection.bind('remove', this.removeOld, this);
    $('#filter').on('click', 'li', this.loadByAspect)


  render: ()->
    this.collection.forEach(this.addOne, this)
    return this
  addOne: (discontent)->
    discontentView = new DiscontentView({model: discontent});
    this.$el.append(discontentView.render().el);

  renderNew: (newModel)->
#    console.log 'new'
    new DiscontentView({ model:newModel }).render();
    return this

  removeOld: (model)->
    el = $('div[data-id="id-'+model.id+'"]')
    this.$container.isotope('remove', el).isotope('layout');

  loadByAspect: ()->
    dc.fetch
      data: $.param({aspect: $(this).data('aspect')})
      success: (col,res)->

#        $('#tab_aspect_posts').isotope
#          filter: $(this).data('aspect')



dc = new DiscontentCollection
dc.fetch
  success: (col,res)->
    dv = new DiscontentCollectionView({collection: dc})
    $('.stage-post-block').html(dv.render().el)
    dv.$container =  $('#tab_aspect_posts').isotope
      itemSelector: '.discontent-block',
      layoutMode: 'fitRows'
