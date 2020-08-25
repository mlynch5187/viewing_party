class User::MoviesController < ApplicationController
  def index
    search_results = SearchResults.new
    search_query = params[:search_query]
    @top_rated_movies = search_results.top_rated
    @movie_search = search_results.movie_search(search_query)
  end

  def show
    movie_id = params[:id].to_i
    movie_response = conn.get("movie/#{movie_id}") do |f|
      f.params['movie_id'] = movie_id
    end
    movie_json = JSON.parse(movie_response.body, symbolize_names: true)
    @movie = Movie.new(movie_json)

    credit_response = conn.get("movie/#{movie_id}/credits") do |f|
      f.params['movie_id'] = movie_id
    end
    credit_json = JSON.parse(credit_response.body, symbolize_names: true)
      mapped_credits = credit_json[:cast].map do |member|
        member[:name]
      end
      @credits = Credit.new(mapped_credits)

    review_response = conn.get("movie/#{movie_id}/reviews") do |f|
      f.params['movie_id'] = movie_id
    end
    review_json = JSON.parse(review_response.body, symbolize_names: true)
      require "pry"; binding.pry
      @review = Review.new(review_json)
  end

  private

  def conn
    Faraday.new('https://api.themoviedb.org/3/') do |f|
      f.params['api_key'] = ENV['MOVIE_KEY']
    end
  end
end
