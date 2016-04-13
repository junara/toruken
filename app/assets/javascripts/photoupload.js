
function photoup(){
	//ファイル読み込み
	var obj1 = document.getElementById("myfile");
	var dataURL = obj1.addEventListener("change",resize,false);
	uploadphoto(dataURL);
	var maxWidth = 300; 
    var maxHeight = 300;
    

        
  //blob形式をフォームとして/photosへ変換しcarrierwaveを動かす
  function uploadphoto (dataURL){
  	  var file= dataURLtoBlob(dataURL);
  	  var fn = obj1.getAttribute('alt')
  	  var fd = new FormData();
  	  fd.append('photo[image]',file);

	  $.ajax({
	        type: 'POST',
	        url: '/photos',
	        data: fd,
	        processData: false,
	        contentType: false,
			}); 
    //dataURL形式をblob形式に変換
	function dataURLtoBlob(dataURL) {
	    // Decode the dataURL
	    var binary = atob(dataURL.split(',')[1]);
	    // Create 8-bit unsigned array
	    var array = [];
	    for(var i = 0; i < binary.length; i++) {
	        array.push(binary.charCodeAt(i));
			}
	    // Return our Blob object
		return new Blob([new Uint8Array(array)], {type: 'image/png'});
	} 
}
}

        
  

