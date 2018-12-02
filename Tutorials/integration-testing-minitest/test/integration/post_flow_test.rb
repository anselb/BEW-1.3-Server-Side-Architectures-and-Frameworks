require 'test_helper'

class PostFlowTest < ActionDispatch::IntegrationTest
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
    visit posts_path

    click_on 'New Post'

    fill_in 'Title', with: 'Test Title'
    fill_in 'Body',  with: 'Test Body'

    click_on 'Create Post'

    assert_current_path post_path(Post.last)
    assert page.has_content?('Test Title')
    assert page.has_content?('Test Body')
  end
end
