class BannersController < ApplicationController

  def index

    @position = BannerPosition.position_without_parent.order('parent_id', 'id')

    search_title = params[:search_title]+"%" if params[:search_title]
    search_requester = params[:search_requester]+"%" if params[:search_requester]

    @banners = Banner.all
    @banners = @banners.where("banners.title like ?", search_title) if params[:search_title]
    @banners = @banners.where("banners.requester like ?", search_requester) if params[:search_requester]
    @banners = @banners.where("banners.banner_position_id = ?", params[:search_banner_position_id]) if params[:search_banner_position_id]
    @banners = @banners.paginate(page: params[:page], per_page: 10)
  
    @search_title = params[:search_title]
    @search_requester = params[:search_requester]
    @search_banner_position_id = params[:search_banner_position_id]

    
  end

  def show

  end

  def new
    @banner = Banner.new
    @position = BannerPosition.position_without_parent.order('parent_id', 'id')
  end

  def create
    @banner = Banner.new(banner_params)
    @position = BannerPosition.where("banner_positions.parent_id != 0").order('parent_id', 'id')

    respond_to do |format|
      if @banner.save
        format.html {
          flash[:notice] = '신청되었습니다.'
          redirect_to new_banner_path
        }
      else
        format.html { 
          flash[:notice] = '신청폼을 확인해주세요' 
          render :new, :position => @position
        }
      end
    end 
  end

  def edit
    @banner = Banner.find(params[:id])
    @position = BannerPosition.position_without_parent.order('parent_id', 'id')

  end
  
  def update
    @banner = Banner.find(params[:id])  
  
    respond_to do |format|
      if @banner.update(banner_params)
        format.html {
          flash[:notice] = '수정되었습니다.'
          redirect_to edit_banner_path(@banner)
        }
      else
        format.html { 
          flash[:notice] = '신청폼을 확인해주세요' 
          redirect_to edit_banner_path(@babber)
        }
      end
    end 
  end

  def destroy
    @banner = Banner.find(params[:id])
    @banner.destroy

    redirect_to banners_path(:page => params[:page])

  end


  def service_confirm_update
    banner = Banner.find(params[:id])

    if banner.service_confirm? 
      banner.update_attributes(:se_idde_confirm => false)
    else
      banner.update_attributes(:service_confirm => true)
    end

    redirect_to banners_path(:page => params[:page])
  end

  def daily_board

    if params[:date].blank? 
      @date = DateTime.now.strftime("%Y-%m-%d")
    else 
      @date = params[:date]
    end 

#활성화 배너 찾기
    banners = Banner.where(:service_confirm => true).where("? between banners.start_date and banners.end_date", @date).joins(:banner_position)

# DB Banner position 에 따라 변수명 생성 및 값 지정
# 변수명 예) @Main_Top_banners
    banner_position = BannerPosition.position_without_parent 
    banner_position.each do |p|
      instance_variable_set("@#{p.parent_name}_#{p.name}s", banners.where(banner_positions: {id: "#{p.id}"}))
    end
 
  end


  def active

    @active_banners = [] 

    if params[:start_date].blank? 
      @start_date = DateTime.now.strftime("%Y-%m-%d")
      @end_date = (Date.today+6.days).strftime('%Y-%m-%d')
    else 
      @start_date = params[:start_date] 
      @end_date = (params[:start_date].to_date+6.days).strftime('%Y-%m-%d')
    end 


#활성화 배너 찾기
    banners = Banner.where(:service_confirm => true).where("banners.start_date <= ? and banners.end_date >= ?", @end_date, @start_date).joins(:banner_position)

# DB Banner position 에 따라 변수명 생성 및 값 지정
# 변수명 예) @Main_Top_banners
    banner_position = BannerPosition.position_without_parent 

    banner_position.each do |p|
      instance_variable_set("@#{p.parent_name}_#{p.name}s", banners.where(banner_positions: {id: "#{p.id}"}))

      banners.where(banner_positions: {id: "#{p.id}"}).blank? ? @active_banners.push(["#{p.parent_name}_#{p.name}s", nil]) : @active_banners.push(["#{p.parent_name}_#{p.name}s", instance_variable_get("@#{p.parent_name}_#{p.name}s")])
      
    end
    
  end


  private
    def banner_params
      params.require(:banner).permit(:title, :requester, :banner_division_id, :banner_position_id, :start_date, :end_date, :target_link, :description)
    end

end
