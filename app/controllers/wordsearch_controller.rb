class WordsearchController < ApplicationController
  allow_unauthenticated_access

  def index
    @pagehead = "Spellings wordsearch"
  end
end
