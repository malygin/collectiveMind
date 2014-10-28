module AdviceHelper
  #@todo move to decorator
  def advice_type_name(advice)
    str = 'К '
    str += 'несовершенству' if advice.discontent?
    str += 'нововведению' if advice.concept?
    str += ': '
    str
  end

  def advices_for_stage?(project, stage)
    (stage == 'concept/posts' && project.advices_concept) || (stage == 'discontent/posts' && project.advices_discontent)
  end
end
