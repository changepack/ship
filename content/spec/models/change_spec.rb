# typed: false
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Change do
  subject { build(:change) }

  it { is_expected.to belong_to(:account) }
  it { is_expected.to belong_to(:commit) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_inclusion_of(:type).in_array(described_class::TYPES) }
  it { is_expected.to validate_uniqueness_of(:commit_id).scoped_to(:account_id) }
end
