# encoding: utf-8
class Stage < ActiveRecord::Base
  LIST = {:life_tape => {id:1, name: 'Сбор информации'},
         :discontent => {id:2, name: 'Анализ ситуации'},
         :concept => {id:3, name: 'Формулирование проблемы'},
         :plan => {id:4, name: 'Проекты'},
         :estimate => {id:5, name: 'Оценивание'}}.freeze

end