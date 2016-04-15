class PhotosController < ApplicationController
  before_action :logged_in_user, only: [:create]
  before_action :set_photo , only: [:edit, :update, :destroy]
  include CarrierwaveBase64Uploader
  
  def create
    @photo = current_user.photos.build(photo_params)
    # binding.pry
    if @photo.save
      flash[:success] = "Photo created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end


  def destroy
    @photo.destroy
    redirect_to root_path, notice: '測定データを削除しました'
  end
  
  def edit
    @photo = Photo.find(params[:id])

    
  end
  
  def update
    if @photo.update(photo_params)
      # 保存に成功した場合はトップページへリダイレクト
      #binding.pry
      redirect_to user_path(session[:user_id]) , notice: '測定データを編集しました'
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  
  private
  def photo_params
    params.require(:photo)
    .permit(:content, :image, :image_cache, :remove_image, :item_name, :item_value, :item_date)
  end
  
  def set_photo
    @photo = Photo.find(params[:id])
  end


end
