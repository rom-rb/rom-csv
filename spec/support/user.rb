class User
  include Virtus.model

  attribute :id, Integer
  attribute :name, String
  attribute :email, String
end
