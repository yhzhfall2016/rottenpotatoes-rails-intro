class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Defaults
    @ratings = Movie.all_ratings
    @sort = nil
    @order = 'asc'

    do_redirect = false
    
    
    
    if params[:ratings]
      @ratings = params[:ratings].keys
    elsif session[:ratings]
      @ratings = session[:ratings]
      do_redirect = true
    end
    session[:ratings] = @ratings
    
    if %w{title rating release_date}.include?(params[:sort])
      @sort = params[:sort]
    elsif session[:sort]
      @sort = session[:sort]
      do_redirect = true
    end
    session[:sort] = @sort


    @movies = Movie.with_ratings(@ratings)
    @hilite = {}
    
    
    @all_ratings = Movie.all_ratings

    if @sort
      @movies = @movies.order(@sort)
      @hilite[@sort] = 'hilite'
    end

    if do_redirect
      return redirect_to movies_path(
        :ratings => Hash[@ratings.collect { |item| [item, 1] } ],
        :sort => @sort)
   
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
