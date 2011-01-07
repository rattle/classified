require 'libarchive' if Gem.available?('libarchive')

module Classified
  module Corpus
    class Utils

      def self.load_movie_reviews
        # See if we've already unpacked them
        base_dir = File.join(File.dirname(__FILE__), '..', '..', 'test', 'corpora', 'movie_reviews')
        classification_count = { :negative => 0, :positive => 0}
        movie_review_corpus = []
        if File.directory?(File.join(base_dir, 'movie_reviews', 'neg'))
          ['negative', 'positive'].each do |classification|
            dir = File.join(base_dir, 'movie_reviews', classification[0,3])
            Dir[dir + "/*.txt"].each do |filename|
              movie_review_corpus << {:classification => classification.to_sym, :text => File.read(filename) }
              classification_count[classification.to_sym] +=1
            end
          end
        else
          ::Archive.read_open_filename(File.join(base_dir, 'movie_reviews.zip')) do |ar|
            while entry = ar.next_header
              name = entry.pathname
              if name =~ /\/$/
                FileUtils.mkdir_p File.join(base_dir, name)
                next
              end
              classification = name =~ /neg/ ? :negative : :positive
              text = ar.read_data
              movie_review_corpus << { :classification => classification, :text => text }
              file = File.join(base_dir, name)
              File.open(file, 'w') {|f| f.write(text) }
              classification_count[classification.to_sym] +=1
            end
          end
        end

        movie_review = { :training => [], :test => [] }
        count = { :positive => 0, :negative => 0}
        movie_review_corpus.each do |doc|
          count[doc[:classification]]+=1
          if count[doc[:classification]] > classification_count[doc[:classification]]*3/4
            # Add to test set
            movie_review[:test] << doc
          else
            # Add to training set
            movie_review[:training] << doc
          end
        end
        movie_review
      end

      def self.load_twitter_sentiment(file)
        docs = []
        classification_count = { :positive => 0, :negative => 0 }
        File.open( file ) do |yf|
          YAML.load_documents( yf ) do |status|
            docs << { :text => status[:text], :classification => status[:classification] }
            classification_count[status[:classification]] +=1
          end
        end

        corpus = { :training => [], :test => [] }
        count = { :positive => 0, :negative => 0}
        docs.each do |doc|
          count[doc[:classification]]+=1
          if count[doc[:classification]] > classification_count[doc[:classification]]*3/4
            # Add to test set
           corpus[:test] << doc
          else
            # Add to training set
            corpus[:training] << doc
          end
        end
        corpus
      end

    end
  end
end
