# Time ressources an admin has to add new content to the site
class TimeAllocation < ApplicationRecord
  # Associations
  belongs_to :user, inverse_of: :time_allocations
end
