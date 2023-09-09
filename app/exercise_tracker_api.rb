class User
  include Mongoid::Document

  field :username, type: String
end

class ExerciseTrackerApi < Sinatra::Base
  get '/' do
    redirect '/index.html'
  end

  get '/api/hello' do
    content_type 'text/plain'
    
    'mantap mancing'
  end

  post '/api/users' do
    content_type 'application/json'

    user = User.create!(username: params['username'])
    return user.to_json
  end

  get '/api/users' do
    content_type 'application/json'

    User.all.to_json
  end
end
