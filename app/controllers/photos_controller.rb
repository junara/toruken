class PhotosController < ApplicationController
  before_action :logged_in_user, only: [:create]
  before_action :set_photo , only: [:edit, :update, :destroy]
  include CarrierwaveBase64Uploader
  require 'httpclient'
  
  def create
#    gbapi="AIzaSyDPrOSfTi0GqbeDzMHQGv-A0c2cwnuuMo4"
    gbapi="AIzaSyDPrOSfTi0GqbeDzMHQGv-A0c2cwnuuMo4"
#    @endpoint_uri = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['SERVER_KEY']}"
    @endpoint_uri = "https://vision.googleapis.com/v1/images:annotate?key=#{gbapi}"

    @photo = current_user.photos.build(photo_params)
    @photo[:content]= EasyTranslate.translate(gvrequest(params[:photo][:content]), :from => :en, :to => :ja, :key => gbapi)
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

  def gvrequest(base64data)
    http_client = HTTPClient.new
    content = base64data
    response = http_client.post_content(@endpoint_uri, request_json(content), 'Content-Type' => 'application/json')
    result_parse(response)
    
  end

  def request_json(content)
    {
      requests: [{
        image: {
          content: content
        },
        features: [{
          type: "LABEL_DETECTION",
          maxResults: 10
        }]
      }]
    }.to_json
  end

  def result_parse(response)
    result = JSON.parse(response)['responses'].first
      label = result['labelAnnotations'].first
      result = label['description']
    result
  end
end
