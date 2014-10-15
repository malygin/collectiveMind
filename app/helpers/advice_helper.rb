module AdviceHelper
  #@todo move to decorator
  def advice_type_name(advice)
    str = 'К '
    str += 'несовершенству' if advice.discontent?
    str += 'нововведению' if advice.concept?
    str += ': '
    str
  end
end
