class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy favorite]
  before_action :authorize_book, only: %i[index new create]
  before_action :authorize_book_with_record, only: %i[show edit update destroy favorite]

  # GET /books or /books.json
  def index
    params[:filter] ||= 'all'

    if params[:filter] == 'all'
      @books = policy_scope(Book).page(params[:page]).order(created_at: :desc)
    else
      @books = policy_scope(Book.favorite_books(current_user)).page(params[:page]).order(created_at: :desc)
    end
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "O livro #{@book.title} foi cadastrado com sucesso." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "O livro #{@book.title} foi atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    respond_to do |format|
      if @book.remove(current_user)
        format.html { redirect_to books_url, notice: "O livro #{@book.title} foi excluído com sucesso." }
        format.json { head :no_content }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def favorite
    favorite = @book.favorite?(current_user)
    notice = "O Livro #{@book.title} foi #{favorite ? 'removido dos favoritos' : 'adicionado aos favoritos'} com sucesso."

    respond_to do |format|
      if @book.favorite(current_user)
        format.html { redirect_to books_url, notice: notice }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :description, :image_url, :page_count, :author)
    end

    def authorize_book
      authorize Book
    end

    def authorize_book_with_record
      authorize @book
    end
end
