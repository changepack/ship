# frozen_string_literal: true

require 'rails_helper'

module Repositories
  describe Pull, :vcr do
    subject(:command) { described_class.new(user:) }
    let(:user) { create(:user) }

    context 'with a GitHub integration' do
      context 'without a token' do
        it "doesn't execute" do
          expect { command.run }.to raise_error Repositories::Pull::Disconnected
        end
      end

      context 'with a token' do
        let(:user) { create(:user, providers: { github: { access_token: 'access_token' } }) }

        it 'upserts repositories' do
          expect { command.run }.to change(user.repositories, :count)
        end
      end
    end
  end
end
