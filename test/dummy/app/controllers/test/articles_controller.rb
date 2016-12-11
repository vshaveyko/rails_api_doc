class Test::ArticlesController < ApplicationController

  before_action :set_article, only: [:show, :edit, :update, :destroy]

  parameter :title, type: :string
  parameter :body, type: :string, required: true
  parameter :rating, type: :enum, enum: [1, 2, 3]
  parameter :data_attributes, type: :object, model: 'Datum' do
    parameter :creation_date, type: :datetime
    parameter :comment, type: :string
  end

  def test_member_route
  end

  def test_collection_route
  end

  # GET /articles
  def index
    @articles = Article.all
  end

  # GET /articles/1
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def article_params
      params.require(:article).permit(:title, :body, :author_id, :rating, :data_id)
    end
end
