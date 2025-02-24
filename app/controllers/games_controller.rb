require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @word = params[:word].upcase
    letters = params[:letters]

    valid_word = @word.chars.all? { |char| letters.include?(char) } &&
    @word.chars.all? { |char| @word.count(char) <= letters.count(char) }

    if valid_word
      url = "https://dictionary.lewagon.com/#{@word}"
      response = URI.open(url).read
      data = JSON.parse(response)

      if data["found"]
        @result = "Congratulations! #{@word} is a valid English word!"
      else
        @result = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry but #{@word} can't be built out of #{letters.join(", ")}"
    end
  end
end
