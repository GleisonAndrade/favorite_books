require 'rails_helper'

RSpec.describe "books/index", type: :view do
  before(:each) do
    assign(:books, [
      Book.create!(
        title: "Title",
        description: "MyText",
        image_url: "Image Url",
        page_count: 2,
        author: "Author"
      ),
      Book.create!(
        title: "Title",
        description: "MyText",
        image_url: "Image Url",
        page_count: 2,
        author: "Author"
      )
    ])
  end

  it "renders a list of books" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "Image Url".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: "Author".to_s, count: 2
  end
end
