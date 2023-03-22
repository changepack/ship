# typed: false
# frozen_string_literal: true

class BlogComponent < ApplicationComponent
  # You can pass a post or a collection of posts
  attribute :posts, T.nilable(T::Posts)
  attribute :post, T.nilable(Post)
  # If not present, account will be inferred from the post
  attribute :account, T.nilable(Account)

  attr_reader :pagy, :collection

  def before_template
    instance_variable_set(:@account, post.account) if account.nil?
    instance_variable_set(:@posts, [post].compact) if posts.nil?

    @pagy, @collection = paginate!
    super
  end

  def template
    div class: 'block md:flex md:justify-between md:items-center' do
      section class: 'md:w-1/2' do
        title
      end

      compose!
    end

    content
    pagination
  end

  def title
    a href: account_path(account) do
      h1 class: 'font-semibold text-5xl' do
        text 'Changelog'
      end

      h2 class: 'mt-8' do
        title_text
      end

      account.description? && description
    end
  end

  def description
    div class: 'mt-2 text-sm dimmed' do
      text account.description
    end
  end

  def title_text
    text 'New updates and improvements'

    return if account.name.blank?

    whitespace
    text "to #{account.name}"
  end

  def compose!
    return if helpers.disallowed_to?(:create?, with: PostPolicy)

    div class: 'mt-4 md:mt-0' do
      a href: new_post_path, class: 'button-1', data: { test_id: 'new_post_button' } do
        icon 'plus', class: 'mr-2'
        text 'Compose'
      end
    end
  end

  def content
    section class: 'overflow-hidden', id: 'posts' do
      div class: 'py-12 md:py-32' do
        div class: '-my-8 divide-y-2 divide-gray-100' do
          render collection if collection.present?
        end
      end
    end
  end

  def pagination
    unsafe_raw helpers.pagy_nav(pagy).to_s if pagy.pages > 1
  end

  def paginate!
    if posts.is_a?(Array)
      helpers.pagy_array(posts)
    else
      helpers.pagy(posts)
    end
  end
end
