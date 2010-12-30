require 'helper'
require 'pp'

class TestClassified < Test::Unit::TestCase

  context "With the default ankusa classifier" do

    setup do
      @c = Classified::Classifier.create(:storage => :memory)
    end

    should "support training and classification" do
      assert_equal @c.train(:positive, "Thats nice"), {:nice => 1}
      assert_equal @c.classify("Thats nice"), :positive
    end

    context "with a trained moview review corpus" do

      setup do 
        corpus = Classified::Corpus.load_movie_reviews
        Classified::Corpus.train_classifier @c, corpus[:training]
      end

      should "correctly classify text" do
        assert_equal @c.classify("It was rubbish"), :negative
      end

    end

  end
end
