require 'classifier'

module Classified
  class ClassifierBayes < Base
    attr_accessor :classifier, :options
    def initialize options = {}
      @options = { :classes => ['Positive', 'Negative']}.merge!(options)
      @classifier = ::Classifier::Bayes.new 'Positive', 'Negative'
      #@classifier = ::Classifier::Bayes.new options[:classes]
    end

    def train classification, text
      @classifier.send("train_#{classification.to_s}", text)
    end

    def classify text
      @classifier.classify text
    end

    def classifications
      @options[:classes]
    end

    def transform text
      text.to_s.capitalize
    end

  end
end

