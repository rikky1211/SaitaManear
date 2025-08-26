class SuperAdmin::ServiceTagsController < SuperAdmin::BaseController
  def index
    @service_tags = ServiceTag.all
  end

  def create
    @service_tag = ServiceTag.new(service_tag_params)

    if @service_tag.save
      redirect_to super_admin_service_tags_path, notice: "サービスタグを追加しました"
    else
      flash.now[:error]
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @service_tag = ServiceTag.find(params[:id])
  end

  def update
    @service_tag = ServiceTag.find(params[:id])
    if @service_tag.update(service_tag_params)
      redirect_to super_admin_service_tags_path(@service_tag), notice: "スポットを更新しました"
    else
      flash.now[:error] = "スポットを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @service_tag = ServiceTag.find(params[:id])
    @service_tag.destroy!
    redirect_to super_admin_service_tags_path, notice: "スポットを削除しました"
  end

  private

  def service_tag_params
    params.require(:service_tag).permit(:name, :css_style_id)
  end
end
