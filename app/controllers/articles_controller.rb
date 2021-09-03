class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @articles = Article.order("created_at DESC")

    if params[:search]
      @search_term = params[:search]
      @articles = @articles.search_by(@search_term)
      if @articles.count == 0 && @search_term != ""
        # redirect_to articles_path, alert: "No search found."
        flash.now[:alert] = "No search found."
      end
    end
  end

  def show
    @article = Article.find(params[:id])
    @author = User.find(@article.user_id)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article, notice: "Article successfully created."
    else
      render :new
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.user_id == current_user.id
      if @article.update(article_params)
        redirect_to @article, notice: "Article successfully updated."
      else
        render :edit
      end
    else
      redirect_to articles_path, alert: "You are not the author of the article."
    end
  end

  def destroy
    if @article.user_id == current_user.id
      @article = Article.find(params[:id])
      @article.destroy

      redirect_to root_path, notice: "Article has been deleted."
    else
      redirect_to articles_path, alert: "You are not the author of the article."
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :user_id)
    end
end