class Condition
  def setter
    now = Time.now.utc
    new_live = 0
    new_over = 0
    new_ready = 0

    ready = Event.where(condition: :ready)
    live = Event.live

    ready.each do |event|
      extra = event.begin_at - 10.minutes
      if extra < now
        event.set(:condition, :live)
        new_live += 1
      end
    end

    live.each do |event|
      if event.end_at < now
        event.set(:condition, :over)
        new_over += 1
      end
      # Так как пользователь может самостоятельно выставить live,
      # проверяем чтобы он был выставлен максимум за 20 минут до начала.
      extra = event.begin_at - 20.minutes
      if extra > now
        event.set(:condition, :ready)
        new_ready += 1
      end
    end

    puts "---| live: #{new_live}\n---| over: #{new_over}\n---| ready: #{new_ready}\n---| #{Time.now}"
  end
  handle_asynchronously :setter, priority: 20
end