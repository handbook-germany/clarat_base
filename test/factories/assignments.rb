require 'ffaker'

FactoryBot.define do
  factory :assignment do
    message { FFaker::Lorem.sentence }
    creator { User.first }
    creator_team { UserTeam.first }
    receiver { User.last }
    receiver_team { UserTeam.first }
    # translations are the first model for the assignments,
    # so we use them for tests
    assignable { FactoryBot.create :offer_translation }
    assignable_type 'OfferTranslation'

    trait :with_field do
      assignable_field_type 'id' # every model has an ID field
    end

    trait :with_parent do
      parent { FactoryBot.create :assignment }
    end
  end
end
