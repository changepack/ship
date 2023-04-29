# typed: false
# frozen_string_literal: true

class Repository
  module Events
    extend ActiveSupport::Concern

    class Outdated < Event
      attribute :repository_id, String
    end

    class Authorized < Event
      attribute :provider, T::Key
      attribute :access_token, String
      attribute :account_id, String
    end

    class Created < Event
      attribute :id, String
      attribute :account_id, String
      attribute :name, String
    end
  end
end
