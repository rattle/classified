require 'ankusa'
require 'ankusa/file_system_storage'

module Classified
  class Ankusa < Base
    attr_accessor :classifier
    def initialize options = {}
      case options.delete(:storage)
      when :memory
        @storage = ::Ankusa::MemoryStorage.new
      when :file
        @storage = ::Ankusa::FileSystemStorage.new options.delete(:file)
      else
        @storage = ::Ankusa::MemoryStorage.new
      end
      @classifier = ::Ankusa::NaiveBayesClassifier.new @storage
    end

    def train classification, text
      @classifier.train classification, text
    end

    def classify text
      @classifier.classify text
    end

    def classifications
      @classifier.classnames
    end

    def save
      # TODO: confirm this is a support method for the classifier
      @storage.save
    end
  end
end

