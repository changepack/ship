# frozen_string_literal: true

class CommitDecorator < ApplicationDecorator
  delegate_all

  def abbr
    object.message.truncate(50)
  end

  def checkbox_options(changelog)
    [].tap do |opts|
      true_value = object.id
      false_value = nil

      opts << checkbox_html_options(changelog)
      opts << true_value
      opts << false_value
    end
  end

  def checked?(changelog)
    changelog.id && object.changelog == changelog
  end

  def disabled?(changelog)
    object.changelog && object.changelog != changelog
  end

  private

  def checkbox_html_options(changelog)
    {
      multiple: true,
      id: object.id,
      class: 'w-4 h-4 text-blue-600 bg-gray-100 rounded border-gray-300 focus:ring-blue-500 focus:ring-2',
      checked: checked?(changelog),
      disabled: disabled?(changelog)
    }
  end
end
