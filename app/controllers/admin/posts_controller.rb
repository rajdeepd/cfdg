class Admin::PostsController < ApplicationController
  before_filter :admin_required
  layout 'admin'

  def index
    @posts = Chapter.find(params[:chapter_id]).posts
  end

  def new
    chapter = Chapter.find(params[:chapter_id])
    @post = chapter.posts.new

  end

  def create
    @post = Post.new(params[:post])
    respond_to do |format|
      if @post.save
        format.html { redirect_to admin_chapter_posts_path(params[:chapter_id]), notice: 'Post was successfully created.' }
      else
        format.html { render :new }
      end
    end

  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])

  end

  def update
    post = Post.find(params[:id])
    post.update_attributes(params[:post])
    redirect_to admin_chapter_posts_path(params[:chapter_id])

  end
end
