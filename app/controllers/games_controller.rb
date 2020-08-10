class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('a'..'z').to_a.sample}
  end

  def score
    @answer = params[:answer]
    if included?(@answer, @letters)
      @score = "Well done!"
    else
      @score = "Not in the grid"
    end
  end

  def included?(answer, letters)
    answer.chars.all? { |letter| answer.count(letter) <= letters.count(letter)}
  end
end
