Discontent = Backbone.Model.extend
  parse: (data)->
    return data

DiscontentCollection = Backbone.Collection.extend
  model: Discontent,
  url: "/project/#{getProjectIdByUrl()}/discontent/posts"

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
    $('#sorter').unbind('click').on('click', 'span', this.sortByAspect)
  render: ()->
    this.collection.forEach(this.addOne, this)
    this.$container =  $('#tab_aspect_posts').isotope
      itemSelector: '.discontent-block',
      layoutMode: 'fitRows',
      getSortData:
        comment: '[data-comment] parseFloat',
        date: '[data-date] parseFloat'
    show_comments_hover()
    activate_perfect_scrollbar()
    post_colored_stripes()
    return this
  addOne: (discontent)->
    discontentView = new DiscontentView({model: discontent});
    this.$el.append(discontentView.render().el);
  renderNew: (newModel)->
    this.$container.isotope('insert', new DiscontentView({ model:newModel }).render().el);
  removeOld: (model)->
    # console.log this.$container
    el = $('div[data-id="id-'+model.id+'"]')
    this.$container.isotope('remove', el);
  loadByAspect: (evt)->
    evt.preventDefault();
    dc.fetch
      data: $.param({aspect: $(this).data('aspect')})
  sortByAspect: (evt)->
    evt.preventDefault();
    sortByValue = $(this).data('type')
    $('#tab_aspect_posts').isotope
      sortBy: sortByValue

# only for discontents url
if window.location.href.indexOf("discontent/posts") > -1
  dc = new DiscontentCollection
  dc.fetch
    success: (col,res)->
      dv = new DiscontentCollectionView({collection: dc})
      dv.render()

