class UsersController < ApplicationController
  before_action :user, except: :get_friends
  before_action :friends, only: %i[show set_profile get_profile]
  before_action :friends_count, only: %i[show set_profile get_profile]

  def show; end

  def set_profile
    @change = params[:change]
    respond_to do |format|
      format.turbo_stream do
        render 'users/set_profile'
      end
    end
  end

  def get_profile
    @change = params[:change]
    render formats: :turbo_stream, template: 'users/set_profile'
  end

  def set_friends
    @selected_friends = case params[:selected]
                        when 'all' then friends
                        when 'mutual' then current_user.mutual_friends(user: @user)
                        end
    respond_to do |format|
      format.turbo_stream do
        render 'users/set_friends'
      end
    end
  end

  def get_friends
    @selected_friends = friends
    render formats: :turbo_stream, template: 'users/set_friends'
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def friends
    @friends ||= user.friends
  end

  def friends_count
    @friends_count ||= friends.count
  end
end
