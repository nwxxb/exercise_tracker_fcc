class ExerciseTrackerApi < Sinatra::Base
  get '/' do
    redirect '/index.html'
  end

  get '/hello' do
    content_type 'text/plain'
    
    'mantap mancing'
  end

  post '/api/users' do
    content_type 'application/json'

    return { _id: '1234', username: 'John Doe' }.to_json
  end

  get '/api/users' do
    content_type 'application/json'

    return [{ _id: '1234', username: 'John Doe' }].to_json
  end
end
