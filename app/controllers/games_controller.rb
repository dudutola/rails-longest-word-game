require "open-uri"
require "json"
require "time"

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
    session[:score] ||= 0
    session[:start_time] = Time.now
  end

  def score
    @word = params[:word].upcase
    letters = params[:letters]

    start_time = Time.parse(session[:start_time])
    end_time = Time.now
    @time_taken = (end_time - start_time).round(2)
    @score = (@word.size / (@time_taken / 10.0)).round(2)

    valid_word = @word.chars.all? { |char| letters.include?(char) } &&
    @word.chars.all? { |char| @word.count(char) <= letters.count(char) }

    if valid_word
      url = "https://dictionary.lewagon.com/#{@word}"
      response = URI.open(url).read
      data = JSON.parse(response)

      if data["found"]
        @result = "Congratulations! #{@word} is a valid English word!"
        session[:score] = (session[:score].to_f + @score).round(2)
      else
        @result = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry but #{@word} can't be built out of #{letters.join(", ")}."
    end
  end
end
