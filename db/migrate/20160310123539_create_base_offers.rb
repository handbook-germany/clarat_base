class CreateBaseOffers < ActiveRecord::Migration[4.2]
  def change
    create_table :base_offers do |t|
      t.string :name
    end

    add_column :offers, :base_offer_id, :integer
    add_index :offers, :base_offer_id
  end
end
