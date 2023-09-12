RSpec.describe "api working properly" do
  def app
    ExerciseTrackerApi
  end

  def setup_header(**keyword_args)
    keyword_args.each do |key, val|
      header key.to_s.upcase, val
    end
  end

  describe 'create user correctly' do
    it 'successfully create user' do
      setup_header(
        content_type: 'application/x-www-form-urlencoded;charset=utf-8',
        accept: 'application/json'
      )
      post('/api/users', URI.encode_www_form({username: 'John Doe'}))
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)['_id']).to be_an_instance_of(String)
      expect(JSON.parse(last_response.body)['username']).to eq('John Doe')
      create_response = JSON.parse(last_response.body)

      setup_header(
        content_type: 'application/x-www-form-urlencoded;charset=utf-8',
        accept: 'application/json'
      )
      post('/api/users', URI.encode_www_form({username: 'Jane Doe'}))

      setup_header(accept: 'application/json')
      get('/api/users')
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body).length).to eq(2)
      expect(JSON.parse(last_response.body)).to include(create_response)
      expect(JSON.parse(last_response.body).collect { |user| user['username'] }).to include('John Doe', 'Jane Doe')
    end
  end

  describe 'create exercise correctly' do
    let(:user_data) do
      setup_header(
        content_type: 'application/x-www-form-urlencoded;charset=utf-8',
        accept: 'application/json'
      )
      post('/api/users', URI.encode_www_form({username: 'John Doe'}))
      JSON.parse(last_response.body)
    end

    it 'successfully create exercise logs that depends on a user' do
      setup_header(
        content_type: 'application/x-www-form-urlencoded;charset=utf-8',
        accept: 'application/json'
      )
      post(
        "/api/users/#{user_data['_id']}/exercises",
        URI.encode_www_form({description: 'bowling', duration: 69, date: '1990-1-1'})
      )
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)).to include(
        '_id' => user_data['_id'],
        'username' => user_data['username'],
        'description' => 'bowling',
        'duration' => 69,
        'date' => 'Mon Jan 01 1990'
      )

      # probably you need to insert it directly to db instead through api
      post(
        "/api/users/#{user_data['_id']}/exercises",
        URI.encode_www_form({description: 'running', duration: 15, date: '1990-1-1'})
      )

      setup_header(
        accept: 'application/json'
      )
      get("/api/users/#{user_data['_id']}/exercises")
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)).to include(
        '_id' => user_data['_id'],
        'username' => user_data['username'],
        'count' => 2,
        'log' => [
          {
            'description' => 'bowling',
            'duration' => 69,
            'date' => 'Mon Jan 01 1990'
          },
          {
            'description' => 'running',
            'duration' => 15,
            'date' => 'Mon Jan 01 1990'
          }
        ]
      )
    end

    it 'if date field is empty, set to today' do
      setup_header(
        content_type: 'application/x-www-form-urlencoded;charset=utf-8',
        accept: 'application/json'
      )
      post(
        "/api/users/#{user_data['_id']}/exercises",
        URI.encode_www_form({description: 'bowling', duration: 69})
      )

      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)).to include(
        '_id' => user_data['_id'],
        'username' => user_data['username'],
        'description' => 'bowling',
        'duration' => 69,
        'date' => Date.today.strftime('%a %b %d %Y')
      )
    end

    it 'query params is work' do
      setup_header(
        content_type: 'application/x-www-form-urlencoded;charset=utf-8',
        accept: 'application/json'
      )
      post(
        "/api/users/#{user_data['_id']}/exercises",
        URI.encode_www_form({description: 'bowling', duration: 69, date: '2000-06-24'})
      )
      post(
        "/api/users/#{user_data['_id']}/exercises",
        URI.encode_www_form({description: 'bowling', duration: 69, date: '2008-06-24'})
      )
      post(
        "/api/users/#{user_data['_id']}/exercises",
        URI.encode_www_form({description: 'bowling', duration: 69, date: '2005-06-24'})
      )
      post(
        "/api/users/#{user_data['_id']}/exercises",
        URI.encode_www_form({description: 'bowling', duration: 69, date: '2007-06-24'})
      )
      post(
        "/api/users/#{user_data['_id']}/exercises",
        URI.encode_www_form({description: 'bowling', duration: 69, date: '2010-06-24'})
      )

      setup_header(
        accept: 'application/json'
      )
      get("/api/users/#{user_data['_id']}/exercises?from=2001-06-24&to=2009-06-24&limit=2")
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)['log'].length).to eq(2)
      expect(JSON.parse(last_response.body)['log']).to include(
        {'description' => 'bowling', 'duration' => 69, 'date' => 'Fri Jun 24 2005'},
        {'description' => 'bowling', 'duration' => 69, 'date' => 'Sun Jun 24 2007'}
      )
    end
  end
end
