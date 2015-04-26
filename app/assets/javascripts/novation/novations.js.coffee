Concept = Backbone.Model.extend
  parse: (data)->
    return data

ConceptCollection = Backbone.Collection.extend
  model: Concept,
  url: "/project/#{getProjectIdByUrl()}/concept/posts"

ConceptView = Backbone.View.extend
  template: JST['templates/concept_view']
  render: ()->
    html = this.template(this.model.toJSON())
    newElement = $(html)
    this.$el.replaceWith(newElement);
    this.setElement(newElement);
    return this


ConceptCollectionView = Backbone.View.extend
  el: '#tab_dispost_concepts',

  initialize: ()->
    this.collection.bind('add', this.renderNew, this);
    this.collection.bind('remove', this.removeOld, this);
    $('#filter').on('click', '.checkox_item', this.loadByDiscontent)
    $('#sorter').on('click', 'span', this.sortByDiscontent)
  render: ()->
    this.collection.forEach(this.addOne, this)
    this.$container =  $('#tab_dispost_concepts').isotope
      itemSelector: '.concept-block',
      layoutMode: 'fitRows',
      getSortData:
        comment: '[data-comment] parseFloat',
        date: '[data-date] parseFloat'
    show_comments_hover()
    activate_perfect_scrollbar()
    post_colored_stripes()
    colors_discontents()
    return this
  addOne: (concept)->
    conceptView = new ConceptView({model: concept});
    this.$el.append(conceptView.render().el);
  renderNew: (newModel)->
    this.$container.isotope('insert', new ConceptView({ model:newModel }).render().el);
    $('#tab_dispost_concepts').isotope('updateSortData').isotope()
    show_comments_hover()
    activate_perfect_scrollbar()
    colors_discontents()
    colors_discontents()
  removeOld: (model)->
    # console.log this.$container
    el = $('div[data-id="id-'+model.id+'"]')
    this.$container.isotope('remove', el);
    $('#tab_dispost_concepts').isotope('updateSortData').isotope()
  loadByDiscontent: (evt)->
    #    evt.preventDefault();
    #    filterValue = $(this).data('discontent')
    #    $('#tab_dispost_concepts').isotope
    #      filter: filterValue

    dc.fetch
      data: $.param({discontent: $(this).data('discontent')})
  sortByDiscontent: ()->
    #    evt.preventDefault();
    sortByValue = $(this).data('type')
    $('#tab_dispost_concepts').isotope
      sortBy: sortByValue,
      sortAscending: false


# only for concept url
if window.location.href.indexOf("novation/posts") > -1
  dc = new ConceptCollection
  dc.fetch
    success: (col,res)->
      dv = new ConceptCollectionView({collection: dc})
      dv.render()

