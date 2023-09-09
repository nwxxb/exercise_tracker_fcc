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
    it 'test' do
      get('/api/hello')

      expect(last_response).to be_ok
      expect(last_response.body).to eq('mantap mancing')
    end

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
end
