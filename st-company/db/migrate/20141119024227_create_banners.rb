class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :title
      t.string :requester
      t.belongs_to :banner_division
      t.belongs_to :banner_position
      t.datetime :start_date
      t.datetime :end_date
      t.string :target_link
      t.text :description
      t.boolean :service_confirm
      
      t.timestamps
    end
  end
end
