class SuperAdmin::CssStylesController < SuperAdmin::BaseController
  def index
    @css_styles = CssStyle.all
  end

  def create
    @css_style = CssStyle.new(css_style_params)

    if @css_style.save
      redirect_to super_admin_css_styles_path, notice: "サービスタグを追加しました"
    else
      flash.now[:error]
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @css_style = CssStyle.find(params[:id])
  end

  def update
    @css_style = CssStyle.find(params[:id])
    if @css_style.update(css_style_params)
      redirect_to super_admin_css_styles_path(@css_style), notice: "CSSスタイルを更新しました"
    else
      flash.now[:error] = "CSSスタイルを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @css_style = CssStyle.find(params[:id])
    @css_style.destroy!
    redirect_to super_admin_css_styles_path, notice: "CSSスタイルを削除しました"
  end

  private
  
  def css_style_params
    params.require(:css_style).permit(:style_name, :style_color, :style_daisyui,)
  end

end
