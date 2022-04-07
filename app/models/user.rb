# frozen_string_literal: true

class User < ApplicationRecord
  key :usr

  devise :database_authenticatable, :rememberable, :validatable

  attribute :name, :string

  belongs_to :account
  has_many :changelogs, dependent: :nullify
  accepts_nested_attributes_for :account

  validates :name, presence: true
  normalize :name

  after_initialize do
    self.account = Account.new if account_id.nil?
  end
end
