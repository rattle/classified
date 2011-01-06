# classified - classifier abstraction and comparison framework

## Description

classified provides an abstract interface to common ruby classifiers.  It allows comparison of these classifiers using common corpora to compare accuracy, precision, recall and f-measure metrics.

## Installation

    gem install classified
    bundle install

NOTE: You will need to have installed the libarchive library to support the decompression of the corpora used in the comparisons.

## Usage:

    bundle exec rake metrics:all

## Supported classifiers

* ankusa - https://github.com/livingsocial/ankusa
* hoatzin - https://github.com/rattle/hoatzin
* classifier (bayes + lsi) - https://github.com/cardmagic/classifier

## Analysis

For further information on interpreting the results of the comparison, see http://streamhacker.com/2010/05/17/text-classification-sentiment-analysis-precision-recall/

## Further reading and acknowledgements

See http://streamhacker.com/2010/05/10/text-classification-sentiment-analysis-naive-bayes-classifier/ for the original inspiration.

## Copyright and License

GPL v3 - See LICENSE.txt for details.
Copyright (c) 2010, Rob Lee
