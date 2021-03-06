class Offer
  module Search
    extend ActiveSupport::Concern

    included do
      def self.per_env_index
        if Rails.env.development?
          "Offer_development_#{ENV['USER']}"
        else
          "Offer_#{Rails.env}"
        end
      end

      def self.personal_index_name locale
        "#{per_env_index}_personal_#{locale}"
      end

      def self.remote_index_name locale
        "#{per_env_index}_remote_#{locale}"
      end

      def personal_indexable?
        visible_in_frontend? && personal?
      end

      def remote_indexable?
        visible_in_frontend? && !personal?
      end

      def personal?
        encounter == 'personal'
      end

      # Offer's location's geo coordinates for indexing
      def _geoloc
        {
          'lat' => location.try(:latitude) || '0.0',
          'lng' => location.try(:longitude) || '0.0'
        }
      end

      # lang attribute for translate markup
      def lang locale
        if translations.find_by(locale: locale).try(:automated?)
          "#{locale}-x-mtfrom-de"
        else
          locale.to_s
        end
      end

      # additional searchable string made from keywords
      def tag_names locale = :en
        tags.pluck("name_#{locale}").uniq.join(', ')
      end

      # additional searchable string made from keywords
      def tag_keywords locale = :en
        tags.map do |t|
          t.try("keywords_#{locale}")
        end.reject(&:blank?).uniq.join(', ')
      end

      # concatenated organization name for search index
      def organization_names
        organizations.pluck(:name).join(', ')
      end

      def definitions_string locale = :de
        if locale == :de
          definitions.pluck(:explanation).join(', ')
        end
      end

      # concatenated stamp-texts for search index
      def stamps_string locale
        target_audience_filters_offers
          .pluck("stamp_#{locale.nil? ? :de : locale}".to_sym).join(', ')
      end

      def singular_stamp locale
        target_audience_filters_offers
          .first.send("stamp_#{locale.nil? ? :de : locale}")
      end

      def location_visible
        location ? location.visible : false
      end

      # filter indexing methods
      %w[target_audience language].each do |filter|
        define_method "_#{filter}_filters" do
          send("#{filter}_filters").pluck(:identifier).uniq
        end
      end

      def _age_filters
        target_audience_filters_offers.map do |tafo|
          (tafo.age_from..tafo.age_to).to_a
        end.flatten.sort.uniq
      end

      def _exclusive_gender_filters
        target_audience_filters_offers.pluck(:gender_first_part_of_stamp).uniq
      end

      def _next_steps locale
        string = next_steps_for_locale(locale)
        string.empty? ? send("old_next_steps_#{locale}") : string
      end
    end
  end
end
