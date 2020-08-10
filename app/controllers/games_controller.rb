class GamesController < ApplicationController

  require 'open-uri'
  require 'json'

  def new
    @start_time = Time.now
    @letters = Array.new(10) { ('a'..'z').to_a.sample }
  end

  def score
    @letters = params[:letters]
    @answer = params[:answer]
    @start_time = params[:start_time].to_time
    @end_time = Time.now
    @time_taken = @end_time - @start_time

    if included?(@answer, @letters)
      if english_word?(@answer)
        @score = compute_score(@answer, @time_taken)
        @message = "Congratulations ! #{@answer} is a valid English word!"
      else
        @score = 0
        @message = "Sorry but #{@answer} is not an english word"
      end
    else
      @score = 0
      @message = "Sorry but #{@answer.capitalize} is not in the grid"
    end
  end

  def included?(answer, letters)
    array_answer = answer.split("")
    array_letter = letters.split(" ")
    array_answer.all? { |letter| array_letter.include?(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def compute_score(answer, time)
    score = time > 60.0 ? 0 : answer.size * (1.0 - time / 60.0)
    score.to_i
  end
end
