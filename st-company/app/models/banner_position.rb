class BannerPosition < ActiveRecord::Base
  has_many :banners

  validates :name, format: {with: /\A[a-zA-Z0-9]+\Z/, message: "영문숫자만 입력 가능 합니다 빈칸X" }




  def name_with_parentname
    "#{self.name}(페이지:#{BannerPosition.where("banner_positions.id = ?", self.parent_id).first.name})"
  end

  def parent_name
    BannerPosition.find(self.parent_id).name
  end
  
  def self.position_without_parent
    self.where("parent_id != 0")
  end

  def self.parent_position
    BannerPosition.where("parent_id = 0") 
  end

end
