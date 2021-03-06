# Cache of already requested string-geocoordinate pairs. Information gotten from
# Google Maps API via the geocode gem.
class SearchLocation < ApplicationRecord
  # Validations
  validates :query, presence: true, uniqueness: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  before_validation :normalize_query
  before_save :set_geoloc

  # Geocoding
  geocoded_by :query
  before_validation :geocode

  # Methods

  def self.normalize query
    query.strip.titleize
  end

  private

  def normalize_query
    self.query = SearchLocation.normalize(self.query) if self.query
  end

  def set_geoloc
    self.geoloc = Geolocation.new(self).to_s
  end
end
