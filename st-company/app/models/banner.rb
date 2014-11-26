class Banner < ActiveRecord::Base
  belongs_to :banner_position
  belongs_to :banner_division


  validates :title, :requester, :banner_division_id, :banner_position_id, :start_date, :end_date, presence: true 
  
  
end
