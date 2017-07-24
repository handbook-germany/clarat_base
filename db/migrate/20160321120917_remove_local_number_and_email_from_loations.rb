class RemoveLocalNumberAndEmailFromLoations < ActiveRecord::Migration[4.2]
  def change
    remove_column :locations, :email, :string
    remove_column :locations, :local_number, :string
    remove_column :locations, :area_code, :string
  end
end
