class UserInfosController < ApplicationController
  before_action :authenticate_user!
  before_action :user

  def update
    return unless current_user == @user

    respond_to do |format|
      if @user.user_info.update(user_info_params)
        format.html { redirect_to user_path(@user), notice: 'Profile edited!' }
        format.turbo_stream { flash.now[:notice] = 'Profile edited!' }
      else
        format.html { redirect_to user_path(@user), status: :unprocessable_entity, alert: 'Profile was not edited!' }
        format.turbo_stream { flash.now[:alert] = 'Profile was not edited!' }
      end
    end
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_info_params
    params.require(:user_info).permit(:avatar, :background, :birthday, :school, :city, :workplace, :details)
  end
end
