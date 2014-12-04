class BannerPositionsController < ApplicationController

  def index
    @positions = BannerPosition.all.paginate(page: params[:page], per_page: 10)
  end

  def new
    @banner_position = BannerPosition.new
    @parent_position = BannerPosition.parent_position
  end

  def create
    @banner_position = BannerPosition.new(banner_position_params)
    @parent_position = BannerPosition.parent_position

    respond_to do |format|
      if @banner_position.save
        format.html {
          flash[:notice] = '신청되었습니다.'
          redirect_to new_banner_position_path
        }
      else
        format.html { 
          flash[:notice] = '신청폼을 확인해주세요' 
          render :new
        }
      end
    end
  end

  def destroy
    @banner_position = BannerPosition.find(params[:id])
    @banner_position.destroy

    redirect_to banner_positions_path(:page => params[:page])
  end

  def edit
    @banner_position = BannerPosition.find(params[:id])
    @parent_position = BannerPosition.parent_position
  end

  def update
    @banner_position = BannerPosition.find(params[:id])
    @parent_position = BannerPosition.parent_position

    respond_to do |format|
      if @banner_position.update(banner_position_params)
        format.html {
          flash[:notice] = '수정되었습니다.'
          redirect_to edit_banner_position_path(@banner_position)
        }
      else
        format.html { 
          flash[:notice] = '신청폼을 확인해주세요' 
          redirect_to edit_banner_position_path(@banner_position)
        }
      end
    end
  end

  private
    def banner_position_params
      params.require(:banner_position).permit(:name, :parent_id)
    end
  
end
