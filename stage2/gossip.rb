require 'sinatra'
require 'active_support/time'
require_relative 'helpers'
require_relative 'client'
require 'byebug'

PORT, PEER_PORT = ARGV.first(2)
set :port, PORT

STATE = ThreadSafe::Hash.new
update_state(PORT => nil)
update_state(PEER_PORT => nil)

MOVIES = File.readlines('movies.txt').map(&:chomp)
@favorite_movie = MOVIES.sample
@version_number = 0
puts "My fav movie is #{@favorite_movie}"

update_state(PORT => [@favorite_movie, @version_number])

every(8.seconds) do
  puts "nevermind, #{@favorite_movie}"
  @version_number += 1
  @favorite_movie = MOVIES.sample
  update_state(PORT => [@favorite_movie, @version_number])
  puts "my new favorite movie is #{@favorite_movie}"
end

every(3.seconds) do
  STATE.keys.each do |port|
    next if port == PORT
    puts "fetching update from #{port.to_s}"
    begin
      gossip_response = Client.gossip(port, JSON.dump(STATE))
      update_state(JSON.load(gossip_response))
    rescue Faraday::ConnectionFailed => e
      STATE.delete(port)
    end
  end
  render_state
end

post '/gossip' do
  their_state = params[:state]
  update_state(JSON.load(their_state))
  JSON.dump(STATE)
end
