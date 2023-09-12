RSpec.describe ExerciseLog, type: :model do
  it { is_expected.to be_embedded_in(:user) }

  it { is_expected.to have_fields(:description).of_type(String) }
  it { is_expected.to have_fields(:duration).of_type(Integer) }
  it { is_expected.to have_fields(:date).of_type(Date) }

  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:duration) }
  it do 
    is_expected.to validate_format_of(:date).to_allow('2015-06-24')
      .not_to_allow('06-24-2015')
  end
end
