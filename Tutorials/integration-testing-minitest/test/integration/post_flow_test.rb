require 'test_helper'

class PostFlowTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  def setup
    @one = posts :one
    @two = posts :two
  end

  test 'post index' do
    visit posts_path

    assert page.has_content?(@one.title)
    assert page.has_content?(@two.title)
  end

  test 'writing a new post' do
    write_new_post

    latest_post = Post.last

    assert_current_path post_path(latest_post)
    assert page.has_content?('Test Title')
    assert page.has_content?('Test Body')
  end

  test 'writing a new post sends admin notice' do
    perform_enqueued_jobs do
      write_new_post

      last_post = Post.last
      mail      = ActionMailer::Base.deliveries.last

      assert_equal 'admin@example.com', mail['to'].to_s
      assert_equal 'New post added', mail.subject
    end
  end

  private

  def write_new_post
    visit posts_path

    click_on 'New Post'

    fill_in 'Title', with: 'Test Title'
    fill_in 'Body',  with: 'Test Body'

    click_on 'Create Post'
  end
end
