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

      setup_header(accept: 'application/json')
      get('/api/users')
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body).length).to eq(1)
      expect(JSON.parse(last_response.body).first['_id']).to be_an_instance_of(String)
      expect(JSON.parse(last_response.body).first['username']).to eq('John Doe')
    end
  end
end
