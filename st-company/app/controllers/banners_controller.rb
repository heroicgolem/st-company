class BannersController < ApplicationController

  def index
    @banners = Banner.all.paginate(page: params[:page], per_page: 5)
  end

  def show

  end

  def new
    @banner = Banner.new
    @position = BannerPosition.where("banner_positions.parent_id != 0") 
  end

  def create
    @banner = Banner.new(banner_params)


#    page = BannerPosition.find(@banner[:position]).parent_id.to_s
#    @banner.update_attribute(:page, page)

  
    respond_to do |format|
      if @banner.save
        format.html { redirect_to new_banner_path, notice: '신청되었습니다.' }
      else
        format.html { render :new, notice: '신청 폼을 확인해주세요.' }
      end
    end 
  end

  def update

  end


  def service_confirm_update
    banner = Banner.find(params[:id])

    if banner.service_confirm? 
      banner.update_attributes(:service_confirm => false)
    else
      banner.update_attributes(:service_confirm => true)
    end

    redirect_to banners_path
  end

  def calendar
    
  end

  private
    def banner_params
      params.require(:banner).permit(:title, :requester, :banner_division_id, :banner_position_id, :start_date, :end_date, :target_link, :description)
    end

end
