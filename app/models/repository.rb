# frozen_string_literal: true

class Repository < ApplicationRecord
  include Status

  key :rep

  attribute :name, :string
  attribute :default_branch, :string
  attribute :status, :string, default: :inactive
  attribute :provider, :string
  attribute :provider_id, :string

  belongs_to :account
  belongs_to :user

  validates :name, presence: true
  validates :default_branch, presence: true
  validates :status, presence: true
  validates :provider, presence: true, inclusion: { in: %w[github] }
  validates :provider_id, presence: true

  normalize :name
  normalize :default_branch
  inquirer :status
end
