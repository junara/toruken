class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
#    binding.pry
  #   @user = User.find(params[:id])
    
  # if User.exists?(id: @user.pairuser_id)
  #   @pairuser = User.find(@user.pairuser_id)
  #   temp = @pairuser.photos.ids + @user.photos.ids
  # else
  #   temp = @user.photos.ids
  # end
  #   @photos = Photo.where(id: temp).order(item_date: :desc, item_time: :desc)  

  @photos = userandpariuserphotos

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

    @user = User.find(params[:id])
    @photos = @user.photos.order(item_date: :desc)
    @photos_pair = pariuserphotos

    @chart_data = @photos.where(item_name: format).order('item_date ASC').group(:item_date).average('item_value')
    @chart_data_pair = @photos_pair.where(item_name: format).order('item_date ASC').group(:item_date).average('item_value')

  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,:pairuser_id)
  end
  
  def userandpariuserphotos
    @user = User.find(params[:id])
    if User.exists?(id: @user.pairuser_id)
      @pairuser = User.find(@user.pairuser_id)
      temp = @pairuser.photos.ids + @user.photos.ids
    else
      temp = @user.photos.ids
    end
      return Photo.where(id: temp).order(item_date: :desc, item_time: :desc)  
  end
  
  def pariuserphotos
    @user = User.find(params[:id])
    if User.exists?(id: @user.pairuser_id)
      @pairuser = User.find(@user.pairuser_id)
      temp = @pairuser.photos.ids
    end
      return Photo.where(id: temp).order(item_date: :desc, item_time: :desc)  
  end

  
end
