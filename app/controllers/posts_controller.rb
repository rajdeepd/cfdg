class PostsController < ApplicationController
	def index
		render :layout => false
	end

	def chapterposts
    chapter_id = params[:chapter_id]
    @profile_page = params[:profile_page] == "true"
    @chapter = Chapter.find(chapter_id)
    #user_events = EventMember.find_all_by_user_id(@current_user.id, :include => ['event'], :conditions => "events.chapter_id = #{chapter_id}") || []
    @posts = Post.find_all_by_chapter_id(chapter_id)
    @chapter_home = params[:chapter_home] == "true"
    
     respond_to do |format|      
      if !params["page"].blank?
         format.js
      else
        format.js {render :partial => 'posts_list' }# new.html.erb
      end
    end
 
  end

  def new
    @post = Post.new    
    respond_to do |format|      
      format.js {render :partial => 'form'} # new.html.erb
      format.json { render json: @event }
    end
  end

  def create
  @post = Post.new(params[:post])
  @chapter = Chapter.find(@post.chapter_id)
    respond_to do |format|
      if @post.save
        @posts = Post.find_all_by_chapter_id(@post.chapter_id)        
      end      
      format.js      
    end
  end

  def show
  @post = Post.find(params[:id])
  end

end
