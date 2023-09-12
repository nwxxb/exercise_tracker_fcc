class ExerciseLog
  include Mongoid::Document
  embedded_in :user

  field :date, type: Date
  field :description, type: String
  field :duration, type: Integer

  validates :description, presence: true
  validates :duration, presence: true
  validates :date, format: {
    with: /\A\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])\z/,
    message: "please follow yyyy-mm-dd format"
  }
end

