require 'rails_helper'

RSpec.describe Book, type: :model do
  context "creating books" do
    let(:book) { build(:book) }

    it "is valid with valid attributes" do
      expect(book).to be_valid
    end

    it "is not valid without a title" do
      book.title = nil
      expect(book).to_not be_valid
    end

    it "is not valid with a short title" do
      book.title = 'ab'
      expect(book).to_not be_valid
    end

    it "is not valid without a description" do
      book.description = nil
      expect(book).to_not be_valid
    end

    it "is not valid with a short description" do
      book.description = 'ab'
      expect(book).to_not be_valid
    end

    it "is not valid without a author" do
      book.author = nil
      expect(book).to_not be_valid
    end

    it "is not valid with a short author" do
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
    end

    it "is not valid with zero page_count" do
      book.page_count = 0
      expect(book).to_not be_valid
    end
  end

  context 'user with reader profile' do
    before do
      @user = create(:reader)
    end
    
    it "set as favorite" do
      expect(@user.profile.reader?).to eq(true)

      book = create(:book)

      book.favorite(@user)

      expect(book.favorite?(@user)).to eq(true)
      expect(book.follow?(@user)).to eq(true)
    end

    it "remove book from favorites" do
      book = create(:book)
      book.favorite(@user)

      expect(@user.profile.reader?).to eq(true)

      book.favorite(@user)

      expect(book.favorite?(@user)).to eq(false)
      expect(book.follow?(@user)).to eq(false)
    end
  end

  context 'user with librarian profile' do
    before do
      @user = create(:librarian)
    end
    
    it "set as favorite" do
      expect(@user.profile.librarian?).to eq(true)

      book = create(:book)
      book.favorite(@user)

      expect(book.errors).to_not be_empty
      expect(book.favorite?(@user)).to eq(false)
      expect(book.follow?(@user)).to eq(false)
    end

    it "remove book from favorites" do
      book = create(:book)
      book.favorite(@user)

      expect(@user.profile.librarian?).to eq(true)

      book.favorite(@user)

      expect(book.errors).to_not be_empty
      expect(book.favorite?(@user)).to eq(false)
      expect(book.follow?(@user)).to eq(false)
    end
  end

  context 'user with admin profile' do
    before do
      @user = create(:admin)
    end
    
    it "set as favorite" do
      expect(@user.profile.admin?).to eq(true)

      book = create(:book)
      book.favorite(@user)

      expect(book.errors).to_not be_empty
      expect(book.favorite?(@user)).to eq(false)
      expect(book.follow?(@user)).to eq(false)
    end

    it "remove book from favorites" do
      book = create(:book)
      book.favorite(@user)

      expect(@user.profile.admin?).to eq(true)

      book.favorite(@user)

      expect(book.errors).to_not be_empty
      expect(book.favorite?(@user)).to eq(false)
      expect(book.follow?(@user)).to eq(false)
    end
  end

  context 'user with reader profile' do
    before do
      @user = create(:reader)
      @book = create(:book)
    end
    
    it "remove active book" do
      expect(@user.profile.reader?).to eq(true)

      @book.remove(@user)

      expect(@book.status).to eq(:active)
      expect(@book.errors).to_not be_empty
    end

    it "remove inactive book" do
      expect(@user.profile.reader?).to eq(true)

      @book.status = :inactive
      @book.remove(@user)

      expect(@book.status).to eq(:inactive)
      expect(@book.errors).to_not be_empty
    end
  end

  context 'user with librarian profile' do
    before do
      @user = create(:librarian)
      @book = create(:book)
    end
    
    it "remove active book" do
      expect(@user.profile.librarian?).to eq(true)

      @book.remove(@user)

      expect(@book.status).to eq(:inactive)
      expect(@book.errors).to be_empty
    end

    it "remove inactive book" do
      expect(@user.profile.librarian?).to eq(true)

      @book.status = :inactive
      @book.remove(@user)

      expect(@book.status).to eq(:inactive)
      expect(@book.errors).to_not be_empty
    end
  end

  context 'user with admin profile' do
    before do
      @user = create(:admin)
      @book = create(:book)
    end
    
    it "remove active book" do
      expect(@user.profile.admin?).to eq(true)

      @book.remove(@user)

      expect(@book.status).to eq(:inactive)
      expect(@book.errors).to be_empty
    end

    it "remove inactive book" do
      expect(@user.profile.admin?).to eq(true)

      @book.status = :inactive
      @book.remove(@user)

      expect(@book.status).to eq(:inactive)
      expect(@book.errors).to_not be_empty
    end
  end

end
