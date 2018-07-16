로그인 구현

Get your API key at: https://code.google.com/apis/console/  

- Installation

    gem 'omniauth-google-oauth2'

1. 사용자 인증정보
2. oauth 클라이언트 id 만들기
3. 사용자 인증정보
4. 웹애플리케이션 선택
5. 생성
6. social
7. google+ api
8. 사용설정
9. 다운로드(json download)
10. figaro 설치

gem figaro

bundle install

figaro install

1. Devise

config/initializers/devise.rb

      # ==> OmniAuth
      # Add a new OmniAuth provider. Check the wiki for more information on setting
      # up on your models and hooks.
      # config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'
      config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], 
      config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], 
      {
        scope: 'email',
        prompt: 'select_account'
      }

config/application.yml : 복사 

    development:
    	GOOGLE_CLIENT_ID:
    	GOOGLE_CLIENT_SECRET:

db/migrate/devise_create_user.rb

     $ rails g migration add_columns_to_users

1. user 테이블에 column을 추가할 경우

    class AddColumnsToUsers < ActiveRecord::Migration[5.0]
      def change
        # add_column :DB명, :컬럼명, :타입
        add_column :users, :provider,		     :string
        add_column :users, :name,                 :string
        add_column :users, :uid,                  :string
      end
    end
    

rake db:migrate

app/models/user.rb: :omniauthable 추가

      devise :database_authenticatable, :registerable, 
             :recoverable, :rememberable, :trackable, :validatable,
             :omniauthable, omniauth_providers: [:google_oauth2]



routes.rb

      devise_for :users , controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

        ## 추가 부분
          t.integer   :gubun      # 사용자 구분코드
                                  # 관리자 :0, 사업자 :1, 일반사용자 :2
          t.string    :nickname
          t.string    :gender     
          t.integer   :age
          t.string    :phone
          t.string    :address

"/users/auth/google_oauth2"

- controller 만들기

$ rails g devise:controllers users

controllers/users

- registrations_controller: 회원가입. custom할때 이 controller를 수정한다.
- password_controller: devise자체에서 제공하는 password 리셋해주는것.
- omniauth_callbacks_controller:

    class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
      def google_oauth2
          # You need to implement the method below in your model (e.g. app/models/user.rb)
          @user = User.from_omniauth(request.env['omniauth.auth'])
    
          if @user.persisted?
          # record가 있으면 true. 이미 있는 record거나 삭제되지 않았다면 true. 아닐경우 false=> 있으면 true/ 없으면 false
            flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
            sign_in_and_redirect @user, event: :authentication
          else
            session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
            redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
          end
      end
    end

user.rb

    class User < ApplicationRecord
      # Include default devise modules. Others available are:
      # :confirmable, :lockable, :timeoutable and :omniauthable
      devise :database_authenticatable, :registerable, 
             :recoverable, :rememberable, :trackable, :validatable,
             :omniauthable, omniauth_providers: [:google_oauth2]
             
      has_many    :likes       
      has_many    :movies, through: :likes
      has_many    :comments
      
      
      def self.from_omniauth(access_token)
        data = access_token.info
        user = User.where(email: data['email']).first
    
        # Uncomment the section below if you want users to be created if they don't exist
        # unless user
        #     user = User.create(name: data['name'],
        #        email: data['email'],
        #        password: Devise.friendly_token[0,20]
        #     )
        # end
        user
      end
      
    end

카카오 로그인

https://developers.kakao.com/apps/212046/settings/user

1. 사용자 불가 상태일경우 사용자 관리 on으로 누르기 
2. 설정 
3. 일반 플랫폼 추가 -> 웹 -> 사이트 도메인 추가
4. routes.rb: 

      devise_scope :user do
        get '/users/auth/kakao', to: 'users/omniauth_callbacks#kakao'
        get '/users/auth/kakao/callback', to: 'users/omniauth_callbacks#kakao_auth'
      end

1. 플랫폼 -> Redirect Path에 

/users/auth/kakao/callback추가. 

1. 개발가이드->REST API 도구
2. REST API 키 복사
3. application.yml

    development:
        GOOGLE_CLIENT_ID: 
        GOOGLE_CLIENT_SECRET: 
        KAKAO_REST_API_KEY:  

1. rails g devise:views
2. views/devise/session/new.html.erb
3. REST API 개발가이드 -> 사용자관리-> 로그인
4. omniauth_callbakc_controller

    def kakao
        redirect_to 'http://kauth.kakao.com/oauth/authorize?client_id={app_key}&redirect_uri={redirect_uri}&response_type=code HTTP/1.1'
      end

1. devise/sessions/new.html.erb

    <%= link_to 'Sign_In_With_Kakao',users_auth_kakao_path %><br/>

1. omniauth_callback_controller

      def kakao
        redirect_to "https://kauth.kakao.com/oauth/authorize?client_id=#{ENV['KAKAO_REST_API_KEY']}&redirect_uri=https://rails-tutorial-aaaraming.c9users.io/users/auth/kakao/callback&response_type=code"
      end
      
      def kakao_auth
        code = params[:code]
        base_url = "https://kauth.kakao.com/oauth/token"
        base_response = RestClient.post(base_url,{grant_type: 'authorization_code',
                                                  client_id: ENV['KAKAO_REST_API_KEY'],
                                                  redirect_uri: 'https://rails-tutorial-aaaraming.c9users.io/users/auth/kakao/callback',
                                                  code: code})
                                       
        #JSON으로 날라온것을 해시로          
        res = JSON.parse(base_response)
        access_token = res["access_token"]
        info_url = "https://kapi.kakao.com/v2/user/me"
        info_response = RestClient.get(info_url, 
                                        Authorization: "Bearer #{access_token}")
                                        
        puts info_response
        
      end

Gemfile

    gem 'rest-client'

1. REST API 도구 -> 사용자 정보요청



다음주

git branch

git branch 후 merge까지 
