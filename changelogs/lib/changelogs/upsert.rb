# frozen_string_literal: true

module Changelogs
  class Upsert < Command
    option :changelog, model: Changelog
    option :user, model: User
    option :content, type: Types::String
    option :title, type: Types::String, optional: true
    option :published, type: Types::String, optional: true
    option :commits, type: Types::Array.of(Types::String), optional: true

    def execute
      changelog.tap do |changelog|
        changelog.update(attributes)
        changelog.transition_to!(:published) if publish?
        changelog.transition_to!(:draft) if draft?

        deattach_irrelevant_commits
        attach_new_commits
      end
    end

    private

    def attributes
      { title:, content:, account:, user: }
    end

    def user
      changelog.user || @user
    end

    def deattach_irrelevant_commits
      changelog.commits
               .where.not(id: commits)
               .each { |commit| commit.update!(changelog: nil) }
    end

    def attach_new_commits
      account.commits
             .where(id: commits)
             .includes(:account, :repository)
             .each { |commit| commit.update!(changelog:) }
    end

    def publish?
      published.present? && changelog.can_transition_to?(:published)
    end

    def draft?
      published.blank? && changelog.can_transition_to?(:draft)
    end

    delegate :account, to: :user
  end
end
