class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id]) #コメントする投稿
    @comment = BookComment.new(book_comment_params)
    @comment.user_id = current_user.id
    @comment.book_id = @book.id #どの投稿にコメントするか
    @comment_new = BookComment.new
    if @comment.save
      redirect_to book_path(@book)
    else
      @user = @book.user
      render 'book/show'
    end
  end

  def destroy
    BookComment.find_by(id: params[:id]).destroy
    redirect_to book_path(params[:book_id])
  end


  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
