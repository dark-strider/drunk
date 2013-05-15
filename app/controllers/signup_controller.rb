# encoding: utf-8
class SignupController < Devise::RegistrationsController
  def create
    super
    if resource.save
      resource.location = Location.new
      resource.like = Like.new
      resource.save

      # В случае если идет внешняя регистрация без почты,
      # переопределяем поведение функции, сразу добавляя сервис в аккаунт.
      if session[:service].present?
        Service.add(resource,
                    session[:service],
                    session[:uid],
                    params['user']['name'],
                    params['user']['email'],
                    session[:url])

        flash[:notice] = "Добро пожаловать! Вы зарегистрировались через 
                          #{session[:service].capitalize}. В настройках вы можете добавить 
                          информацию о себе. Также настоятельно РЕКОМЕНДУЕМ указать в 
                          настройках ваш НОВЫЙ ПАРОЛЬ, для возможности входа через нашу форму."
      end
    end
  end

  def edit
    profile_expansion
    super
  end

  def update
    coordinates = params[:user][:location_attributes][:coordinates].gsub('[','').gsub(']','').gsub(' ','')
    if coordinates != ''
      params[:user][:location_attributes][:coordinates] = coordinates.split(',').map{ |s| s.to_f }
    end

    # Переопределяем стандартное поведение функции, для пропуска текущего пароля.
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      # Изменил ли пароль после внешней регистрации.
      if !@user.my_password? && params[:user][:password].present?
        @user.set(:my_password, true)
      end
      # Входим пропуская валидацию текущего пароля.
      sign_in @user, bypass: true, event: :authentication
      set_flash_message :notice, :updated
      redirect_to user_path(current_user)
    else
      clean_up_passwords @user
      profile_expansion
      render 'edit'
    end
  end

  def profile_expansion
    @services = resource.services
    @marker = resource.to_gmaps4rails do |user, marker|
      marker.picture({ picture: '/assets/gmaps4rails/user.png', width: 32, height: 37 })
    end
  end
end