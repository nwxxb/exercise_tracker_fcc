class ExerciseTrackerApi < Sinatra::Base
  get '/' do
    redirect '/index.html'
  end

  get '/api/hello' do
    content_type 'text/plain'
    
    'mantap mancing'
  end

  post '/api/users' do
    begin
      content_type 'application/json'

      user = User.create!(username: params['username'])
      return user.to_json
    rescue => Mongoid::Errors::Validations
      halt 400
    end
  end

  get '/api/users' do
    content_type 'application/json'

    User.all.to_json
  end

  post '/api/users/:user_id/exercises' do |user_id|
    begin
      content_type 'application/json'

      user = User.find(user_id)
      params['date'] ||= Date.today
      exercise_log = user.exercise_logs.create!(
        description: params['description'],
        duration: params['duration'],
        date: params['date'],
      )
      return {
        _id: user.id,
        username: user.username,
        description: exercise_log.description,
        duration: exercise_log.duration,
        date: exercise_log.date.strftime('%a %b %d %Y')
      }.to_json
    rescue => Mongoid::Errors::Validations
      halt 400
    end
  end

  get '/api/users/:user_id/exercises' do |user_id|
    content_type 'application/json'

    user = User.find(user_id)

    user_logs = user.exercise_logs.order_by(date: 'asc')
    if params[:from]
      user_logs = user_logs.where(date: { '$gte' => params[:from] })
    end

    if params[:to]
      user_logs = user_logs.where(date: { '$lte' => params[:to] })
    end

    if params[:limit]
      user_logs = user_logs.limit(params[:limit])
    end

    user_logs = user_logs.map do |log|
      {
        duration: log.duration,
        description: log.description,
        date: log.date.strftime('%a %b %d %Y')
      }
    end

    return {
      _id: user.id,
      username: user.username,
      count: user_logs.length,
      log: user_logs
    }.to_json
  end
end
