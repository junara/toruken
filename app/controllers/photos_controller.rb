class PhotosController < ApplicationController
  before_action :logged_in_user, only: [:create]
  before_action :set_photo , only: [:edit, :update, :destroy]
  include CarrierwaveBase64Uploader
  require 'httpclient'
  
  def create
    @photo = current_user.photos.build(photo_params)

    @endpoint_uri = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV["GOOGLE_API_KEY"]}"
    googlevisionlabel=gvrequest(params[:photo][:content])
    googlevisionlabeljp = EasyTranslate.translate(googlevisionlabel.join(", "), :from => :en, :to => :ja, :key => ENV["GOOGLE_API_KEY"])
    @photo[:content]= googlevisionlabeljp.gsub(/、/, ',')
    t = Time.mktime(params[:photo]["item_time(1i)"],params[:photo]["item_time(2i)"],params[:photo]["item_time(3i)"],params[:photo]["item_time(4i)"],params[:photo]["item_time(5i)"],params[:photo]["item_time(6i)"])
    thour = t.strftime("%H").to_i
    if googlevisionlabeljp.include?("食")
      if thour >= 4 && thour <= 10
        @photo[:item_name] = "朝食"
      elsif thour >= 11 && thour <= 14
        @photo[:item_name] = "昼食"
      elsif thour >= 16 && thour <= 24
        @photo[:item_name] = "夕食"
      else
        @photo[:item_name] = "食事のきろく"
      end
    end


    if @photo.save
      flash[:success] = "Photo created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end


  def destroy
    @photo.destroy
    redirect_to user_path(session[:user_id]), notice: '測定データを削除しました'
  end
  
  def edit
    @photo = Photo.find(params[:id])

    
  end
  
  def update
    if @photo.update(photo_params)
      # 保存に成功した場合はトップページへリダイレクト
      redirect_to user_path(session[:user_id]) , notice: '測定データを編集しました'
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  
  private
  def photo_params
    params.require(:photo)
    .permit(:content, :image, :image_cache, :remove_image, :item_name, :item_value, :item_date, :item_time)
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
      labelresult= Array.new
      result['labelAnnotations'].each do |elem|
        labelresult.push(elem['description'])
      end
      return labelresult

  end
end
