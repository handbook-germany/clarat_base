class CreateCategoriesSectionFilters < ActiveRecord::Migration[4.2]
  def change
    create_table :categories_section_filters do |t|
      t.integer :category_id
      t.integer :section_filter_id

      t.timestamps null: false
    end
  end
end
