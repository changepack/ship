# typed: false
# frozen_string_literal: true

class Summary
  class OnRequested < Handler
    on ::Summary::Requested

    sig { override.returns T.nilable(Post) }
    def run
      Summary.new(changelog:).save if changelog.present?
    end

    sig { returns T.nilable(Changelog) }
    def changelog
      Changelog.find_by(id: event.changelog_id)
    end
  end
end
