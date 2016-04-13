class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show 
    @user = User.find(params[:id])
    @photos = @user.photos.order(item_date: :desc)
#       .paginate(:page => params[:page], :per_page => 5) #will_paginateを使用し、5投稿毎にページ訳
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def graph 
    @user = User.find(params[:id])
    @photos = @user.photos.order(item_date: :desc)
#       .paginate(:page => params[:page], :per_page => 5) #will_paginateを使用し、5投稿毎にページ訳
      # おためし
#    @chart_data = [['2014-04-01', 60], ['2014-04-02', 65], ['2014-04-03', 64]]
    @chart_data = @photos.where(item_name: '体重').order('item_date ASC').group(:item_date).average('item_value')
    #binding.pry
    
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
  
end
