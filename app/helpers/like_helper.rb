# encoding: utf-8
module LikeHelper
  def like_for(target)
    like_title(target)
    link_to @title, like_path(resource_name: target.class, resource_id: target.id), method: :post, class: "btn btn-#{@size}"
  end

  def unlike_for(target)
    like_title(target)
    link_to @title, like_path(resource_name: target.class, resource_id: target.id), method: :delete, class: "btn btn-success btn-#{@size}"
  end

  def dislike_for(target)
    dislike_title(target)
    link_to @title, dislike_path(resource_name: target.class, resource_id: target.id), method: :post, class: "btn btn-#{@size}"
  end

  def undislike_for(target)
    dislike_title(target)
    link_to @title, dislike_path(resource_name: target.class, resource_id: target.id), method: :delete, class: "btn btn-danger btn-#{@size}"
  end

private

  def like_title(target)
    case target.class.to_s
      when 'Place'
        @title = 'Классное место'
        @size = 'small'
      when 'Event'
        @title = 'Было здорово'
        @size = 'small'
      when 'Comment'
        @title = 'Нравится'
        @size = 'mini'
      when 'Photo'
        @title = 'Классная фотка'
        @size = 'small'
      else
        @title = 'Нравится'
        @size = 'small'
    end
  end

  def dislike_title(target)
    case target.class.to_s
      when 'Place'
        @title = 'Не очень'
        @size = 'small'
      when 'Event'
        @title = 'Не понравилось'
        @size = 'small'
      when 'Photo'
        @title = 'Классная фотка'
        @size = 'small'
      else
        @title = 'Не нравится'
        @size = 'small'
    end
  end
end