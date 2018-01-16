Thread.abort_on_exception = true

def every(seconds)
  Thread.new do
    loop do
      sleep seconds
      yield
    end
  end
end

def render_state
  puts "-" * 40
  debugger
end

def update_state(update)
  update.each do |port, (movie, version_number)|

  end 
end
