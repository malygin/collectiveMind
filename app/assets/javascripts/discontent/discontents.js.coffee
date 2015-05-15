$.ajaxSetup
  cache: false

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
    # @todo click заменен на change, т.к. при click почему то два раза вызывается loadByAspect
    # $('#filter').on('click', 'li', this.loadByAspect)
    $('#filter').on('change', this.loadByAspect)

    $('#sorter').on('click', 'span', this.sortByAspect)
  render: ()->
    this.collection.forEach(this.addOne, this)
    this.$container =  $('#tab_aspect_posts').isotope
      itemSelector: '.discontent-block',
      layoutMode: 'fitRows',
      getSortData:
        comment: '[data-comment] parseFloat',
        date: '[data-date] parseFloat'

    #    reload_isotope()
    #    this.reloadIsotope
    #    $('#tab_aspect_posts').isotope('reloadItems').isotope()
    #    this.$container.isotope('updateSortData').isotope();
    #    this.$container.isotope().isotope('layout');
    #    this.$container.isotope('reloadItems')
    #    this.$container.isotope( 'updateSortData', this.collection )
    #    $('#tab_aspect_posts').isotope().isotope('reloadItems')


#    show_comments_hover()
#    activate_perfect_scrollbar()
#    colors_discontents()
#    post_colored_stripes()
    return this

  addOne: (discontent)->
    discontentView = new DiscontentView({model: discontent});
    this.$el.append(discontentView.render().el);

  renderNew: (newModel)->
    this.$container.isotope('insert', new DiscontentView({ model:newModel }).render().el);

  removeOld: (model)->
    el = $('div[data-id="id-'+model.id+'"]')
    this.$container.isotope('remove', el);

  loadByAspect: (evt)->
    #    return false
    #    evt.preventDefault();
    #    evt.stopPropagation()
    #    evt.stopImmediatePropagation()
    #    filterValue = $(this).data('aspect')
    #    $('#tab_aspect_posts').isotope
    #      filter: filterValue
    dc.fetch
      # data: $.param({aspect: $(this).data('aspect')})
      data: $.param({aspect: $(this).find('input:checked').parent().data('aspect')})
      success: (col,res)->
        $('#count_discontents').html('(' + dc.length + ')')
        $('#tab_aspect_posts').isotope('updateSortData').isotope()
        show_comments_hover()
        activate_perfect_scrollbar()
        colors_discontents()
        post_colored_stripes()

  sortByAspect: ()->
    sortByValue = $(this).data('type')
    $('#tab_aspect_posts').isotope
      sortBy: sortByValue,
      sortAscending: false

# only for discontents url
if window.location.href.indexOf("discontent/posts") > -1
  dc = new DiscontentCollection
  dc.fetch
    success: (col,res)->
      dv = new DiscontentCollectionView({collection: dc})
      dv.render()

