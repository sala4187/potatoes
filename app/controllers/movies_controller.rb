class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
  sort = params[:sort] || session[:sort]

  case sort
  when "title"
  @title_header="hilite"
  @date_header=nil

  when "release_date"
  @title_header=nil
  @date_header = "hilite"
  end

  @ratings = params[:ratings] || session[:ratings] || {}

  if params[:sort] != session[:sort]
    session[:sort] = sort
    redirect_to :sort => sort, :ratings => @ratings and return
  end

  if params[:ratings] != session[:ratings] and @ratings != {}
    session[:sort] = sort
    session[:ratings] = @ratings
    redirect_to :sort => sort, :ratings => @ratings and return
  end

  if @ratings == {}
    Movie.all_ratings.each_with_index { |rating, index|
      @ratings[rating] = index
    }
  end

  @movies = Movie.order(params[:sort]).find_all_by_rating(@ratings.keys)
  @all_ratings = Movie.all_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end


end