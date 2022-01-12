require 'rails_helper'

RSpec.describe "books/new", type: :view do
  before(:each) do
    assign(:book, Book.new(
      title: "MyString",
      description: "MyText",
      image_url: "MyString",
      page_count: 1,
      author: "MyString"
    ))
  end

  it "renders new book form" do
    render

    assert_select "form[action=?][method=?]", books_path, "post" do

      assert_select "input[name=?]", "book[title]"

      assert_select "textarea[name=?]", "book[description]"

      assert_select "input[name=?]", "book[image_url]"

      assert_select "input[name=?]", "book[page_count]"

      assert_select "input[name=?]", "book[author]"
    end
  end
end
