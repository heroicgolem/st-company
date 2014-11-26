class CreateBannerPositions < ActiveRecord::Migration
  def change
    create_table :banner_positions do |t|
      t.integer :parent_id, :null => false
      t.string :name, :null => true
      t.timestamps
    end
  end
end
