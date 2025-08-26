class SuperAdmin::ServiceTagsController < SuperAdmin::BaseController
  def index
    @service_tags = ServiceTag.all
  end

  def new
    @season_tags = ServiceTag.new
  end

  def show
    @service_tag = ServiceTag.find(params[:id])
  end

  def edit
    @service_tag = ServiceTag.find(params[:id])
  end

  def update
    @service_tag = ServiceTag.find(params[:id])
    if @service_tag.update(spot_params)
      redirect_to service_tags_path(@service_tag), notice: "スポットを更新しました"
    else
      flash.now[:error] = "スポットを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private
  
  def service_tag_params
    params.require(:service_tag).permit(:name, :css_style)
  end

end
