class CreateBannerDivisions < ActiveRecord::Migration
  def change
    create_table :banner_divisions do |t|
      t.string :name, :null => true
      t.timestamps
    end
  end
end
