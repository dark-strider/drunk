$(document).on('click', '.social_share', function(){
  Share.go(this);
});

Share = {
  /**
   * Показать пользователю дилог шаринга в сооветствии с опциями
   * Метод для использования в inline-js в ссылках
   * При блокировке всплывающего окна подставит нужный адрес и позволит браузеру перейти по нему
   *
   * @example <a href="" onclick="return share.go(this)">like+</a>
   * @param Object _element - элемент DOM, для которого
   * @param Object _options - опции, все необязательны
   */
  go: function(_element, _options) {
    var
      self = Share,
      options = $.extend(
        {
          type:      'vkontakte',         // тип соцсети
          url:       location.href,       // какую ссылку шарим
          count_url: location.href,       // для какой ссылки крутим счётчик
          title:     document.title,      // заголовок шаринга
          image:     'http://static8.depositphotos.com/1035986/840/v/950/depositphotos_8406007-Beer-Mugs-drink-alcohol-pub-party.jpg',                  // картинка шаринга
          text:      'Some sample text.', // текст шаринга
        },
        $(_element).data(), // Если параметры заданы в data, то читаем их
        _options            // Параметры из вызова метода имеют наивысший приоритет
      );

    if (self.popup(link = self[options.type](options)) === null) {
      // Если не удалось открыть попап
      if ( $(_element).is('a') ) {
        // Если это <a>, то подставляем адрес и просим браузер продолжить переход по ссылке
        $(_element).prop('href', link);
        return true;
      }
      else {
        // Если это не <a>, то пытаемся перейти по адресу
        location.href = link;
        return false;
      }
    }
    else {
      // Попап успешно открыт, просим браузер не продолжать обработку
      return false;
    }
  },

  // ВКонтакте
  vkontakte: function(_options) {    
    var options = $.extend({
        url:    location.href,
        title:  document.title,
        image:  '',
        text:   '',
      }, _options);

    return 'http://vkontakte.ru/share.php?'
      + 'url='          + encodeURIComponent(options.url)
      + '&title='       + encodeURIComponent(options.title)
      + '&description=' + encodeURIComponent(options.text)
      + '&image='       + encodeURIComponent(options.image)
      + '&noparse=true';
  },

  // Одноклассники
  odnoklassniki: function(_options) {
    var options = $.extend({
        url:    location.href,
        text:   '',
      }, _options);

    return 'http://www.odnoklassniki.ru/dk?st.cmd=addShare&st.s=1'
      + '&st.comments=' + encodeURIComponent(options.text)
      + '&st._surl='    + encodeURIComponent(options.url);
  },

  // Мой мир
  mailru: function(_options) {
    var options = $.extend({
        url:    location.href,
        title:  document.title,
        image:  '',
        text:   '',
      }, _options);

    return 'http://connect.mail.ru/share?'
      + 'url='          + encodeURIComponent(options.url)
      + '&title='       + encodeURIComponent(options.title)
      + '&description=' + encodeURIComponent(options.text)
      + '&imageurl='    + encodeURIComponent(options.image);
  },

  // Твиттер
  twitter: function(_options) {
    var options = $.extend({
        url:        location.href,
        count_url:  location.href,
        title:      document.title,
      }, _options);

    return 'https://twitter.com/intent/tweet?'
      + 'url='       + encodeURIComponent(options.url)
      + '&text='     + encodeURIComponent(options.title)
      + '&counturl=' + encodeURIComponent(options.count_url);
  },

  // Facebook
  facebook: function(_options) {
    var options = $.extend({
        url:    location.href,
        title:  document.title,
        image:  '',
        text:   '',
      }, _options);

    return 'http://www.facebook.com/sharer.php?s=100'
      + '&p[title]='     + encodeURIComponent(options.title)
      + '&p[summary]='   + encodeURIComponent(options.text)
      + '&p[url]='       + encodeURIComponent(options.url)
      + '&p[images][0]=' + encodeURIComponent(options.image);
  },

  // Google
  plusone: function(_options) {
    var options = $.extend({
        url:    location.href,
        title:  document.title,
        image:  '',
        text:   '',
      }, _options);

    return ['https://plus.google.com/share?'
          + 'url=' + encodeURIComponent(options.url), options.type];
  },

  // Открыть окно шаринга
  popup: function(url) {
    return window.open(url,'','toolbar=0,status=0,scrollbars=1,width=551,height=319');
  }
}