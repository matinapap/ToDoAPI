# spec/factories/items.rb
FactoryBot.define do
    factory :item do
      name { Faker::Movies::StarWars.character } # Corrected Faker module
      done { false }
      association :todo
    end
  end
  