class User
  include Mongoid::Document
  embeds_many :exercise_logs, store_as: 'log'

  field :username, type: String

  validates :username, presence: true
end

