# frozen_string_literal: true

# problem with how mongoid shape id as a response
# source:
#  - https://stackoverflow.com/questions/18646223/ruby-model-output-id-as-object-oid
module BSON
  # this will prevent adding { $oid: ... } on response
  class ObjectId
    alias to_json to_s
    alias as_json to_s
  end
end
Mongoid.load!('./config/mongoid.yml', Sinatra::Base.environment)
