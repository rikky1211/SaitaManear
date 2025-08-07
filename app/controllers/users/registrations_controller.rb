# registrations_controller.rb
# ユーザー登録やユーザー編集のフォーム

# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def build_resource(hash = {})
    hash[:uid] = User.create_unique_string
    super
  end

  def show
    @user = current_user
    @user_masked_email = current_user.email.sub(/^(.{3}).*(@.*)$/, '\1*****\2')
  end

  def update
    self.resource = current_user

    # 2. 更新処理を実行
    if update_resource(resource, account_update_params)
      flash[:notice] = "パスワード変更に成功しました。再度ログインしてください。"
      redirect_to new_user_session_path, status: :see_other
    else
      flash.now[:error] = "アカウント更新に失敗しました"
      clean_up_passwords resource
      render :edit, status: :unprocessable_entity
    end
  end

  protected

  # devise/ユーザ情報更新(edit/update)のページにて、userのアカウント名(name)を持って来れるように設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  def update_resource(resource, params)
    return super if params["password"].present?

    resource.update_without_password(params.except("current_password"))
  end
end


# -----------------------------------
# default
# -----------------------------------
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

# GET /resource/sign_up
# def new
#   super
# end

# POST /resource
# def create
#   super
# end

# GET /resource/edit
# def edit
#   super
# end

# PUT /resource
# def update
#   super
# end

# DELETE /resource
# def destroy
#   super
# end

# GET /resource/cancel
# Forces the session data which is usually expired after sign
# in to be expired now. This is useful if the user wants to
# cancel oauth signing in/up in the middle of the process,
# removing all OAuth session data.
# def cancel
#   super
# end

# protected

# If you have extra params to permit, append them to the sanitizer.
# def configure_sign_up_params
#   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
# end

# If you have extra params to permit, append them to the sanitizer.
# def configure_account_update_params
#   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
# end

# The path used after sign up.
# def after_sign_up_path_for(resource)
#   super(resource)
# end

# The path used after sign up for inactive accounts.
# def after_inactive_sign_up_path_for(resource)
#   super(resource)
# end
