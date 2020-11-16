require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = []
    n = 0
    while n < 10
      @grid << ('A'..'Z').to_a.sample
      n += 1
    end
  total
  end

  def count(letters)
    letter_frequencies = Hash.new(0)
    if letters.is_a? Array
      letters.each { |letter| letter_frequencies[letter] += 1 }
    else
      letters_separated = letters.split("")
      letters_separated.each { |letter| letter_frequencies[letter] += 1 }
    end
    return letter_frequencies
  end

  def score
    @attempt = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    open_url = open(url)
    @word = JSON.parse(open(url).read)
    ok = 0
    count(@attempt.upcase).each { |letter, frequency| frequency <= count(params[:letters])[letter] ? ok += 0 : ok += 1 }
    if @word["found"] && ok.zero?
      @result = { score: @word["length"], message: "Well done!"}
    elsif @word["found"] == false && ok.zero?
      @result = { score: 0, message: "Nice try but #{@attempt} is not an english word!" }
    else
      @result = { score: 0, message: "Nice try but in #{@attempt} some letters are not in the grid!" }
    end
    session[:score] ? session[:score] << @result[:score] : session[:score] = [@result[:score]]
    total
  end

  def total
    session[:score].nil? ? 0 : @total = session[:score].reduce(0, :+)
  end
end
