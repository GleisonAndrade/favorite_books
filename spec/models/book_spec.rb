require 'rails_helper'

RSpec.describe Book, type: :model do
  context "validations" do
    let(:book) { build(:book) }

    it "is valid with valid attributes" do
      expect(book).to be_valid
    end

    it "is not valid without a title" do
      book.title = nil
      expect(book).to_not be_valid

      book.title = 'ab'
      expect(book).to_not be_valid
    end

    it "is not valid without a description" do
      book.description = nil
      expect(book).to_not be_valid

      book.description = 'ab'
      expect(book).to_not be_valid
    end

    it "is not valid without a author" do
      book.author = nil
      expect(book).to_not be_valid

      book.author = 'ab'
      expect(book).to_not be_valid
    end

    it "is not valid without a image_url" do
      book.image_url = nil
      expect(book).to_not be_valid
    end

    it "is not valid without a page_count" do
      book.page_count = nil
      expect(book).to_not be_valid

      book.page_count = 0
      expect(book).to_not be_valid
    end
  end

end
