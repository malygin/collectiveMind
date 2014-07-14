# encoding: utf-8
class AddAwardsData < ActiveRecord::Migration
  def up
    Award.create! name: '1 лайк модератора', url: '1like', position: 1
    Award.create! name: '3 лайка модератора', url: '3likes', position: 2
    Award.create! name: '5 лайков модератора', url: '5likes', position: 3
    Award.create! name: '15 лайков модератора', url: '15likes', position: 4
    Award.create! name: '50 лайков модератора', url: '50likes', position: 5
    Award.create! name: 'Первое несовершенство в аспекте', url: '1stimperfection', position: 6
    Award.create! name: '1 несовершенство в аспекте', url: '1imperfection', position: 7
    Award.create! name: '3 несовершенства в аспекте', url: '3imperfection', position: 8
    Award.create! name: '5 несовершенств в аспекте', url: '5imperfection', position: 9
    Award.create! name: '15 и более несовершенств в аспекте', url: '15imperfection', position: 10
    Award.create! name: '50 процентов и более несовершенств одного автора в одном аспекте', url: '50imperfection', position: 11
    Award.create! name: 'Первое нововведение в аспекте', url: '1stinnovation', position: 12
    Award.create! name: '1 нововведение в аспекте', url: '1innovation', position: 13
    Award.create! name: '3 нововведение в аспекте', url: '3innovation', position: 14
    Award.create! name: '5 нововведение в аспекте', url: '5innovation', position: 15
    Award.create! name: '15 и более нововведений в аспекте', url: '15innovation', position: 16
    Award.create! name: '50 процентов и более нововведений одного автора в одном аспекте', url: '50innovation', position: 17
    Award.create! name: 'За проект', url: 'project', position: 18
    Award.create! name: '100 очков рейтинга', url: '100points', position: 19
    Award.create! name: '500 очков рейтинга', url: '500points', position: 20
    Award.create! name: '1000 очков рейтинга', url: '1000points', position: 21
    Award.create! name: '3000 рейтинга и более', url: '3000points', position: 22
  end

  def down
    Award.destroy_all
  end
end
