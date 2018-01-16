require 'sinatra'
require 'byebug'
require 'pry'

BALANCES = {
  'bryan' => 100
}

get "/balance" do
  user = params['user']
  "#{user} has #{BALANCES[user]}"
end

post "/users" do
  name = params['name']
  BALANCES[name] ||= 100
  "OK"
end

post "/transfer" do
  from, to = params.values_at('from', 'to').map(&:downcase)
  amount = params['amount'].to_i
  raise unless BALANCES[from] >= amount
  BALANCES[from] -= amount
  BALANCES[to] += amount
end
