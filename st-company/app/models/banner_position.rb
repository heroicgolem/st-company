class BannerPosition < ActiveRecord::Base
  has_many :banners

  def name_with_parentname
    "#{self.name}(페이지:#{BannerPosition.where("banner_positions.id = ?", self.parent_id).first.name})"
  end

  def parent_name
    BannerPosition.find(self.parent_id).name
  end
  
end
