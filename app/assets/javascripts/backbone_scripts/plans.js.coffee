$.ajaxSetup
  cache: false

Plan = Backbone.Model.extend
  parse: (data)->
    return data

PlanCollection = Backbone.Collection.extend
  model: Plan,
  url: "/project/#{getProjectIdByUrl()}/plan/posts"

PlanView = Backbone.View.extend
  template: JST['templates/post']
  render: ()->
    html = this.template(this.model.toJSON())
    newElement = $(html)
    this.setElement(newElement)
    return this

PlanCollectionView = Backbone.View.extend
  el: '#tab_novation_plans',

  initialize: ()->
    $('#sorter').on('click', 'span', this.sortByPlan)

  render: ()->
    this.collection.forEach(this.addOne, this)
    this.$container = $('#tab_novation_plans').shuffle
      itemSelector: '.md-post-block'
    return this

  addOne: (plan)->
    planView = new PlanView({model: plan})
    this.$el.append(planView.render().el)

  sortByPlan: ()->
    sortByValue = $(this).data('type')
    opts =
      reverse: true
      by: ($el) ->
        $el.data sortByValue
    $('#tab_novation_plans').shuffle 'sort', opts

# only for plan url
if isProcedurePage("plan/posts")
  dc = new PlanCollection
  dc.fetch
    success: (col,res)->
      dv = new PlanCollectionView({collection: dc})
      dv.render()
