require 'helper'
require 'pp'

class TestClassified < Test::Unit::TestCase

  context "With the default ankusa classifier" do

    setup do
      @c = Classified::Classifiers.create(:storage => :memory)
    end

    should "support training and classification" do
      assert_equal Hash[:nice, 1], @c.train(:positive, "Thats nice")
      assert_equal :positive, @c.classify("Thats nice")
    end

    context "with a trained moview review corpus" do

      setup do 
        corpus = Classified::Corpus::Utils.load_movie_reviews
        Classified::Metrics.train_classifier @c, corpus[:training]
      end

      should "correctly classify text" do
        assert_equal :negative, @c.classify("It was rubbish")
      end

    end

  end
end
