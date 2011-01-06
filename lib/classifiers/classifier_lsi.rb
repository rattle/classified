require 'classifier'

module Classified
  class ClassifierLSI < Base
    attr_accessor :classifier, :options
    def initialize options = {}
      @options = { :classes => [:positive, :negative]}.merge!(options)
      @classifier = ::Classifier::LSI.new
      #@classifier = ::Classifier::Bayes.new options[:classes]
    end

    def train classification, text
      @classifier.add_item(text, "train_#{classification.to_s}")
    end

    def classify text
      @classifier.classify text
    end

    def classifications
      @options[:classes]
    end

  end
end

