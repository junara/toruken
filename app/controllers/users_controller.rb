class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show 
    @user = User.find(params[:id])
    temp = @user.pairuserofuser.photos.ids + @user.photos.ids
    @photos = Photo.where(id: temp).order(item_date: :desc) 

#       .paginate(:page => params[:page], :per_page => 5) #will_paginateを使用し、5投稿毎にページ訳
  end

  def edit
    @user = User.find(params[:id]) #モデルは大文字単数

  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Update success"
      redirect_to user_path(session[:user_id])
    else
      flash[:success] = "Update failed"
      render 'edit'
    end
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
    if params[:format]
      format = params[:format]
    else
      format = '体重'
    end
#    format ='体重'
    @user = User.find(params[:id])
    @photos = @user.photos.order(item_date: :desc)
    @photos_pair = @user.pairuserofuser.photos.order(item_date: :desc)
#       .paginate(:page => params[:page], :per_page => 5) #will_paginateを使用し、5投稿毎にページ訳
      # おためし
#    @chart_data = [['2014-04-01', 60], ['2014-04-02', 65], ['2014-04-03', 64]]
    @chart_data = @photos.where(item_name: format).order('item_date ASC').group(:item_date).average('item_value')
    @chart_data_pair = @photos_pair.where(item_name: format).order('item_date ASC').group(:item_date).average('item_value')

    #binding.pry

    
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,:pairuser_id)
  end
  
end
