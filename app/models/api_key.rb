class ApiKey < ActiveRecord::Base
  include ActiveModel::Validations::Callbacks
  attr_accessible :owner
  before_create :generate_access_token

protected
    def generate_access_token
      begin
        self.access_token = SecureRandom.hex
      end while self.class.exists?(access_token: access_token)
    end
end
