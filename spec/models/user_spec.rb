RSpec.describe User, type: :model do
  it { is_expected.to have_fields(:username).of_type(String) }
  it { is_expected.to embed_many(:exercise_logs) }
  it { is_expected.to validate_presence_of(:username) }
end
