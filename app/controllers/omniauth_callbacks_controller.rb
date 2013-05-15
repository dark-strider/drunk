# encoding: utf-8
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env['omniauth.auth']
    if auth
      # Разносим параметры хеша по нашим переменным.
        auth.provider ? provider = auth.provider : provider = ''
        auth.uid ? uid = auth.uid : uid = ''
        auth.info.email ? email = auth.info.email : email = ''
        auth.info.name ? name = auth.info.name : name = ''
      
      if auth.provider == 'facebook'
        auth.info.description ? about = auth.info.description : about = ''
        auth.info.urls.Facebook ? url = auth.info.urls.Facebook : url = ''
        auth.extra.raw_info.birthday ? birthday = auth.extra.raw_info.birthday : birthday = ''
        
        if auth.extra.raw_info.gender # male/female
          auth.extra.raw_info.gender == 'female' ? gender = 'Женский' : gender = 'Мужской'
        else
          gender = 'Мужской'
        end 
      
      elsif auth.provider == 'twitter'
        auth.info.description ? about = auth.info.description : about = ''
        auth.info.urls.Twitter ? url = auth.info.urls.Twitter : url = ''
        gender = 'Мужской'
      
      elsif auth.provider == 'vkontakte'
        auth.info.urls.Vkontakte ? url = auth.info.urls.Vkontakte : url = ''
        auth.extra.raw_info.bdate ? birthday = auth.extra.raw_info.bdate : birthday = ''
        
        if auth.extra.raw_info.sex # 2/1
          auth.extra.raw_info.sex == 1 ? gender = 'Женский' : gender = 'Мужской'
        else
          gender = 'Мужской'
        end
      else
        flash[:alert] = "Пожалуйста воспользуйтесь другим сервисом."
        return
      end

      if uid.present? && provider.present?
        # Проверка нет ли уже пользователя, используещего эту пару provider-uid.
        pair = Service.find_by(provider: provider, uid: uid)
        
        # Нельзя войти дважды, также нельзя зарегистрироваться если ты уже вошел.
        if !user_signed_in?
          # Если пользователь не вошел.
          if pair
            # Если пара есть, то входим пользователем, у которого эта пара.
            signing(auth.provider, pair.user, "Вы вошли через #{provider.capitalize}.")
          else
            # Если нет, поверяем не зарегистрирован ли уже пользователь с таким мылом.
            existing_user = User.find_by(email: email)
            
            if existing_user
              # Если такое мыло уже есть в базе, добавляем этот сервис в существующий аккаунт.
              Service.add(existing_user, provider, uid, name, email, url)
              signing(auth.provider, existing_user, "Вы вошли через #{provider.capitalize}. 
                                                     А также добавили этот сервис в свой 
                                                     существующий аккаунт.")
            else
              # Если нет ни пары ни мыла, то создаем нового пользователя, и добавляем ему этот сервис.
              user = User.new(email: email,
                              by_oauth: true,
                              my_password: false,
                              name: name,
                              birthday: birthday,
                              gender: gender,
                              about: about,
                              password: Devise.friendly_token[0,20])
              if user.save
                user.location = Location.new
                user.like = Like.new
                user.save
                
                # Добавляем пользователю аутентификационный сервис.
                Service.add(user, provider, uid, name, email, url)
                signing(auth.provider, user, "Добро пожаловать! Вы зарегистрировались через 
                                              #{provider.capitalize}. В настройках вы можете 
                                              добавить информацию о себе.
                                              Также настоятельно РЕКОМЕНДУЕМ указать
                                              в настройках ваш НОВЫЙ ПАРОЛЬ, для возможности входа
                                              через нашу форму.")
              else
                flash[:alert] = "В целях обеспечения безопасности данных #{provider.capitalize} не 
                                 предоставляет нам ваш адрес эл.почты (e-mail). 
                                 Пожалуйста введите его самостоятельно. 
                                 Если же вы уже регистрировались здесь, то войдите другим способом 
                                 и самостоятельно добавте сервис #{provider.capitalize} в ваш аккаунт."
                session[:service] = provider
                session[:uid] = uid
                session[:url] = url
                session["devise.user_attributes"] = user.attributes
                redirect_to new_user_registration_url
              end
            end
          end
        else
          # Если пользователь уже вошел, проверяем подключил ли он уже этот сервис.
          if pair
            # Если да, то ничего не делаем.
            flash[:alert] = "#{auth.provider.capitalize} ранее уже был добавлен в ваш аккаунт."
            redirect_to user_path(current_user)
          else
            # Если нет, то добавляем.
            Service.add(current_user, provider, uid, name, email, url)
            flash[:notice] = "#{auth.provider.capitalize} успешно добавлен в ваш аккаунт."
            redirect_to user_path(current_user)
          end  
        end  
      else
        flash[:alert] = "#{auth.provider.capitalize} вернул неверные пользовательские данные."
        redirect_to new_user_session_path
      end
    else
      flash[:alert] = "При входе через #{auth.provider.capitalize} произошла ошибка. Попробуйте еще раз."
      redirect_to new_user_session_path
    end
  end

  alias_method :twitter, :all
  alias_method :facebook, :all
  alias_method :vkontakte, :all

  private

  def signing(service, user, message)
    flash[:notice] = message
    session[:service] = service
    sign_in_and_redirect user, event: :authentication
  end
end