Novation = Backbone.Model.extend
  parse: (data)->
    return data

NovationCollection = Backbone.Collection.extend
  model: Novation,
  url: "/project/#{getProjectIdByUrl()}/novation/posts"

NovationView = Backbone.View.extend
  template: JST['templates/novation_view']
  render: ()->
    html = this.template(this.model.toJSON())
    newElement = $(html)
    this.$el.replaceWith(newElement);
    this.setElement(newElement);
    return this


NovationCollectionView = Backbone.View.extend
  el: '#tab_concept_novations',

  initialize: ()->
    this.collection.bind('add', this.renderNew, this);
    this.collection.bind('remove', this.removeOld, this);
    $('#sorter').on('click', 'span', this.sortByConcept)
  render: ()->
    this.collection.forEach(this.addOne, this)
    this.$container =  $('#tab_concept_novations').isotope
      itemSelector: '.novation-block',
      layoutMode: 'fitRows',
      getSortData:
        comment: '[data-comment] parseFloat',
        date: '[data-date] parseFloat'
    show_comments_hover()
    activate_perfect_scrollbar()
    post_colored_stripes()
    colors_discontents()
    return this

  addOne: (novation)->
    novationView = new NovationView({model: novation});
    this.$el.append(novationView.render().el);

  renderNew: (newModel)->
    this.$container.isotope('insert', new NovationView({ model:newModel }).render().el);

  removeOld: (model)->
    el = $('div[data-id="id-'+model.id+'"]')
    this.$container.isotope('remove', el);

  sortByConcept: ()->
    sortByValue = $(this).data('type')
    $('#tab_concept_novations').isotope
      sortBy: sortByValue,
      sortAscending: false


# only for novation url
if window.location.href.indexOf("novation/posts") > -1
  dc = new NovationCollection
  dc.fetch
    success: (col,res)->
      dv = new NovationCollectionView({collection: dc})
      dv.render()

