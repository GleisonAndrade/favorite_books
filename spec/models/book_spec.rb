require 'rails_helper'

RSpec.describe Book, type: :model do
  PARAMS_TO_SCRUB = ['id', 'status', 'created_at', 'updated_at']

  context "validations" do
    let(:book) { build(:book) }
    let(:admin) { build(:admin) }

    it "is valid with valid attributes" do
      book.create(admin, book.attributes.except!(*PARAMS_TO_SCRUB))
      expect(book).to be_valid
    end

    it "is not valid without a title" do
      book.title = nil
      book.create(admin, book.attributes.except!(*PARAMS_TO_SCRUB))
      expect(book).to_not be_valid
    end

    it "is not valid with a short title" do
      book.title = 'ab'
      book.create(admin, book.attributes.except!(*PARAMS_TO_SCRUB))
      expect(book).to_not be_valid
    end

    it "is not valid without a description" do
      book.description = nil
      book.create(admin, book.attributes.except!(*PARAMS_TO_SCRUB))
      expect(book).to_not be_valid
    end

    it "is not valid with a short description" do
      book.description = 'ab'
      book.create(admin, book.attributes.except!(*PARAMS_TO_SCRUB))
      expect(book).to_not be_valid
    end

    it "is not valid without a image_url" do
      book.image_url = nil
      book.create(admin, book.attributes.except!(*PARAMS_TO_SCRUB))
      expect(book).to_not be_valid
    end

    it "is not valid without a page_count" do
      book.page_count = nil
      book.create(admin, book.attributes.except!(*PARAMS_TO_SCRUB))
      expect(book).to_not be_valid
    end

    it "is not valid page_count with zero value" do
      book.page_count = 0
      book.create(admin, book.attributes.except!(*PARAMS_TO_SCRUB))
      expect(book).to_not be_valid
    end

    it "is not valid without a author" do
      book.author = nil
      book.create(admin, book.attributes.except!(*PARAMS_TO_SCRUB))
      expect(book).to_not be_valid
    end

    it "is not valid with a short author" do
      book.author = 'ab'
      book.create(admin, book.attributes.except!(*PARAMS_TO_SCRUB))
      expect(book).to_not be_valid
    end
  end

  context 'user with reader profile' do
    before do
      @user = create(:reader)
      @book = build(:book)
    end

    it "cannot create book" do
      @new_book = Book.new
      @new_book.create(@user, @book.attributes.except!(*PARAMS_TO_SCRUB))
      expect(@new_book).to_not be_valid
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

    it "set as favorite with invalid book" do
      expect(@user.profile.reader?).to eq(true)

      book = create(:book)
      book.title = nil
      book.favorite(@user)
      book.reload

      expect(book.errors).to_not be_empty
      expect(book.favorite?(@user)).to eq(false)
      expect(book.follow?(@user)).to eq(false)
      expect(book.errors.full_messages.include?('Não foi possível adicionar o livro aos favoritos')).to eq(true)
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
      expect(book.errors.full_messages.include?('Apenas usuários leitores podem realizar essa ação')).to eq(true)
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

    it "remove invalid book" do
      expect(@user.profile.admin?).to eq(true)

      @book.title = nil
      @book.remove(@user)
      @book.reload

      expect(@book.status).to eq(:active)
      expect(@book.errors).to_not be_empty
      expect(@book.errors.full_messages.include?('Não foi possível excluír o livro')).to eq(true)
    end
  end

  context 'user with reader profile' do
    before do
      @user = create(:reader)
      @book = create(:book)
    end
    
    it "edit active book" do
      expect(@user.profile.reader?).to eq(true)

      book_new = build(:book)
     @book.edit(@user, book_new.attributes.except!(*PARAMS_TO_SCRUB))
      @book.reload

      expect(@book.attributes.except!(*PARAMS_TO_SCRUB)).to_not eq(book_new.attributes.except!(*PARAMS_TO_SCRUB))
      expect(@book.errors).to_not be_empty
    end

    it "edit inactive book" do
      expect(@user.profile.reader?).to eq(true)

      @book.remove(@user)

      book_new = build(:book)
     @book.edit(@user, book_new.attributes.except!(*PARAMS_TO_SCRUB))
      @book.reload

      expect(@book.attributes.except!(*PARAMS_TO_SCRUB)).to_not eq(book_new.attributes.except!(*PARAMS_TO_SCRUB))
      expect(@book.errors).to_not be_empty
    end
  end

  context 'user with librarian profile' do
    before do
      @user = create(:librarian)
      @book = create(:book)
    end
    
    it "edit active book" do
      expect(@user.profile.librarian?).to eq(true)

      book_new = build(:book)
     @book.edit(@user, book_new.attributes.except!(*PARAMS_TO_SCRUB))
      @book.reload

      expect(@book.attributes.except!(*PARAMS_TO_SCRUB)).to eq(book_new.attributes.except!(*PARAMS_TO_SCRUB))
      expect(@book.errors).to be_empty
    end

    it "edit inactive book" do
      expect(@user.profile.librarian?).to eq(true)

      @book.remove(@user)

      book_new = build(:book)
     @book.edit(@user, book_new.attributes.except!(*PARAMS_TO_SCRUB))
      @book.reload

      expect(@book.attributes.except!(*PARAMS_TO_SCRUB)).to_not eq(book_new.attributes.except!(*PARAMS_TO_SCRUB))
      expect(@book.errors).to_not be_empty
    end
  end

  context 'user with admin profile' do
    before do
      @user = create(:admin)
      @book = create(:book)
    end
    
    it "edit active book" do
      expect(@user.profile.admin?).to eq(true)

      book_new = build(:book)
      @book.edit(@user, book_new.attributes.except!(*PARAMS_TO_SCRUB))
      @book.reload

      expect(@book.attributes.except!(*PARAMS_TO_SCRUB)).to eq(book_new.attributes.except!(*PARAMS_TO_SCRUB))
      expect(@book.errors).to be_empty
    end

    it "edit inactive book" do
      expect(@user.profile.admin?).to eq(true)

      @book.remove(@user)

      book_new = build(:book)
      @book.edit(@user, book_new.attributes.except!(*PARAMS_TO_SCRUB))
      @book.reload

      expect(@book.attributes.except!(*PARAMS_TO_SCRUB)).to_not eq(book_new.attributes.except!(*PARAMS_TO_SCRUB))
      expect(@book.errors).to_not be_empty
      expect(@book.errors.full_messages.include?('O livro não pode ser atualizado, pois já foi removido')).to eq(true)
    end
    
    it "edit invalid book" do
      expect(@user.profile.admin?).to eq(true)
      
      book_new = build(:book)
      book_params = book_new.attributes.except!(*PARAMS_TO_SCRUB)
      book_params['title'] = nil
      
      @book.edit(@user, book_params)
      @book.reload
      
      expect(@book.attributes.except!(*PARAMS_TO_SCRUB)).to_not eq(book_params)
      expect(@book.errors).to_not be_empty
      expect(@book.errors.full_messages.include?('Não foi possível editar o livro')).to eq(true)
    end
  end
end
