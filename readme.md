
http://apis.map.daum.net/

APP KEY 발급

앱만들기

test-map



1. rails 주소 등록
2. 설정->일반
3. 서버주소 등록
4. 플랫폼추가 -> 웹
5. 개발가이드 ->  자바스크립트 개발가이드
6. 지도 클릭
7. `$:~/workspace $ rails g controller home index new create`
8. sample->지도 생성하기 -> sample 코드 
9. javascript 복사
10. `app/views/index`에 복사

```js
<div id="map"></div>

<script>
    var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new daum.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };

    // 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
    var map = new daum.maps.Map(mapContainer, mapOption); 
</script>
```

* `html` 코드 읽는 순서는 위에서부터 아래로 로드 

11. javascript key 복사 

```erb
#id가 map인 style양식에 맞는 div를 만든다
<div id="map"  style="width:100%;height:350px;"></div>

#app key를 통해서 api를 호출
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=발급받은 키 입력"></script>

<script>
    #document는 지금 보고있는 페이지를 뜻함
    #.getElementById : 지금 보고 있는 페이지의 id값을 찾는다.그     안의 내용을 mapContainer로 받는다.
    var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        # 위도,경도를 center로 저장
        center: new daum.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };

    // 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
    var map = new daum.maps.Map(mapContainer, mapOption); 
</script>
```

12. Wizard를 이용하면 코드를 짜준다.
13. sample - 클릭한 위치에 마커 표시하기
14. `<div id="clickLatlng"></div> `추가하기 

```erb
<div id="map"  style="width:100%;height:350px;"></div>
<div id="clickLatlng"></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=30f5adca0315e21488c96562d6cf9450"></script>

<script>
    var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
        mapOption = { 
            center: new daum.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
            level: 3 // 지도의 확대 레벨
        };
   
    var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
    
    // 지도를 클릭한 위치에 표출할 마커입니다
    var marker = new daum.maps.Marker({ 
        // 지도 중심좌표에 마커를 생성합니다 
        position: map.getCenter() 
    }); 
    // 지도에 마커를 표시합니다
    marker.setMap(map);
    
    // 지도에 클릭 이벤트를 등록합니다
    // 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
    daum.maps.event.addListener(map, 'click', function(mouseEvent) {        
        
        // 클릭한 위도, 경도 정보를 가져옵니다 
        var latlng = mouseEvent.latLng; 
        
        // 마커 위치를 클릭한 위치로 옮깁니다
        marker.setPosition(latlng);
        
        var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
        message += '경도는 ' + latlng.getLng() + ' 입니다';
        
        var resultDiv = document.getElementById('clickLatlng'); 
        resultDiv.innerHTML = message;
        
    });
</script>
```

15. Docs
16. `new.html.erb` : model post

title :string

lat :integer

lng : integer

17.  addListener

```erb
 daum.maps.event.addListener(map, 'click', function(mouseEvent) {        
        
        // 클릭한 위도, 경도 정보를 가져옵니다 
        var latlng = mouseEvent.latLng; 
        
        // 마커 위치를 클릭한 위치로 옮깁니다
        marker.setPosition(latlng);
        
        var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
        message += '경도는 ' + latlng.getLng() + ' 입니다';
        
        var resultDiv = document.getElementById('clickLatlng'); 
        resultDiv.innerHTML = message;
        
    });
```

<문제>id 값이 lat인 친구한테 위에 값이 바뀌도록

* textarea는 `.innerHTML`
* input 은 `value`
  

<문제>create 버튼을 누르면 저장이 되도록

`routes.rb`/`controller` 수정

* form_for . strong parameter
* form_for를 이용하면 두번 감싸진다. `ex)post[title]`
* 따라서 controller에서 사용할 때, ` params[:post][:title]`

```ruby
    #Post.create(title: params[:post][:title],lat: params[:post][:lat],lng: params[:post][:lng])
    
    # post = Post.new
    # post.title = params[:post][:title]
    # post.lat = params[:post][:lat]
    # post.lng= params[:post][:lng]
    # post.save
  
# 앞에 post가 붙어있는 애들 중, title,lat,lng을 가져옴
  	# params.require(:post).permit(:title, :lat,:lng)
```

`new.html.erb`에 form_for로 저장할경우  아래와 같이 두번 감싸져있다.

<input id="title" type="text" name="post[title]">

<input id="lat" type="text" name="post[lat]">

<input id="lng" type="text" name="post[lng]">

### 프로젝트

다음맵 사용

* 여러개 마커 표시하기

- 다양한 이미지 마커 표시하기

- 마커에 인포윈도우 표시하기

- 닫기가 가능한 커스텀 오버레이

- 주소로 장소 표시하기 =>주소로 좌표를 얻어낼 수 있다 

  ```js
  geocoder.addressSearch('제주특별자치도 제주시 첨단로 242', function(result, status) {
  
      // 정상적으로 검색이 완료됐으면 
       if (status === daum.maps.services.Status.OK) {
  
          var coords = new daum.maps.LatLng(result[0].y, result[0].x);
  
          // 결과값으로 받은 위치를 마커로 표시합니다
          var marker = new daum.maps.Marker({
              map: map,
              position: coords
          });
       }
  ```

  

  

- DB에 저장된 지도 보여주기 

  `new.html.erb`

  ```erb
       mapOption = { 
              //center: new daum.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
  			//db에있는 좌표를 중심좌표로 
              center: new daum.maps.LatLng(<%=@p.lat.to_i%>,<%= @p.lng.to_i%>),
              level: 3 // 지도의 확대 레벨
          };
      
  ```

  

`home_controller.rb`

```ruby
  def new
    @p = Post.first
   @post = Post.new
  end
```

### summer note

`Gemfile`

```ruby
gem 'summernote-rails', '~> 0.8.10.0'
```

`application.scss`

```ruby
@import 'bootstrap';
@import 'summernote-bs4';
```

`app/assets/javascripts/application.js`

```ruby
//= require summernote/summernote-bs4.min
//= require summernote-init
```

`app/assets/javascripts/summernote-init. js`

```ruby
$(document).on('ready', function() {
  $('[data-provider="summernote"]').each(function() {
  $(this).summernote({
      height: 300
    });
  });
});
```

`views/movies/_form`

```erb
  <div class="form-group">
    <%= f.label :description %>
    <%= f.text_area :description,'data-provider': :summernote %>
  </div>
```

`app/assets/javascripts/summernote_init.js`

```js
$(document).on('ready', function() {
  $('[data-provider="summernote"]').each(function() {
  $(this).summernote({
      height: 300,
      callbacks: {
        onImageUpload: function(files) {
          return sendFile(files[0], $(this));
         }
      }
    });
  });
});
```



```ruby
$ rails g model images img_path
$ rails g uploader summernote
```

`image.rb`

```ruby
class Image < ApplicationRecord
    mount_uploader :image_path, SummernoteUploader
end

```

`config/routes.rb`

```ruby
  post '/uploads' => 'movies#upload_image'
```

`movie controller`

```ruby
 def upload_image
    @image = Image.create("insertImage",data.image_path.url)
    render json: @image
  end
```

`show.html.erb` :브라우저가 인식할 수 있는 포맷으로 바꿔준다. simple_format

### rails admin

`gem 'rails_admin'`

```ruby
aaaraming:~/watcha_app (master) $ rails g rails_admin:install
Running via Spring preloader in process 29955
           ?  Where do you want to mount rails_admin? Press <enter> for [admin] > ahctahw
       route  mount RailsAdmin::Engine => '/ahctahw', as: 'rails_admin'
      create  config/initializers/rails_admin.rb
```

