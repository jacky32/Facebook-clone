class UsersController < ApplicationController
  def show
    user
    friends
    friends_count
  end

  def set_profile
    user
    friends
    friends_count
    @change = params[:change]
    respond_to do |format|
      format.turbo_stream do
        render 'users/set_profile'
      end
    end
  end

  def get_profile
    user
    friends
    friends_count
    @change = params[:change]
    render formats: :turbo_stream, template: 'users/set_profile'
  end

  def set_friends
    user
    @selected_friends = case params[:selected]
                        when 'all' then friends
                        when 'mutual' then current_user.mutual_friends(@user)
                        end
    respond_to do |format|
      format.turbo_stream do
        render 'users/set_friends'
      end
    end
  end

  def get_friends
    friends
    @selected_friends = @friends
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
