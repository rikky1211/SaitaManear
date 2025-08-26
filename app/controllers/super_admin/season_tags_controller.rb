class SuperAdmin::SeasonTagsController < SuperAdmin::BaseController
  def index
    @season_tags = SeasonTag.all
  end

  def create
    @season_tag = SeasonTag.new(season_tag_params)

    if @season_tag.save
      redirect_to super_admin_season_tags_path, notice: "サービスタグを追加しました"
    else
      flash.now[:error]
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @season_tag = SeasonTag.find(params[:id])
  end

  def update
    @season_tag = SeasonTag.find(params[:id])
    if @season_tag.update(season_tag_params)
      redirect_to super_admin_season_tags_path(@season_tag), notice: "スポットを更新しました"
    else
      flash.now[:error] = "スポットを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @season_tag = SeasonTag.find(params[:id])
    @season_tag.destroy!
    redirect_to super_admin_season_tags_path, notice: "スポットを削除しました"
  end

  private
  
  def season_tag_params
    params.require(:season_tag).permit(:season, :css_style_id)
  end

end
