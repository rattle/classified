require 'hoatzin'

module Classified
  class Hoatzin < Base
    attr_accessor :classifier
    def initialize options = {}
      @classifier = ::Hoatzin::Classifier.new options
    end

    def train classification, text
      @classifier.train classification, text
    end

    def classify text
      @classifier.classify text
    end

    def classifications
      @classifier.classifications
    end

    def save options = {}
      # TODO: confirm this is a support method for the classifier
      @classifier.save options
    end
  end
end

