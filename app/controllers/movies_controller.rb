class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	if params[:sort] == "title"
	@title_header="hilite"
	@date_header=nil
	
	elsif params[:sort] == "release_date"
	@title_header=nil
	@date_header = "hilite"

	else
	@title_header = nil
	@date_header = nil
    	end
	
	if params[:ratings]
	@ratings = params[:ratings].keys
	else 
	@ratings = Movie.all_ratings
	end	

	@movies = Movie.order(params[:sort]).find_all_by_rating(@ratings)
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
