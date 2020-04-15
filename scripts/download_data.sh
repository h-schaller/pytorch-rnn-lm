#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data

mkdir -p $data

tools=$base/tools

# link default training data for easier access

mkdir -p $data/wikitext-2

for corpus in train valid test; do
    absolute_path=$(realpath $tools/pytorch-examples/word_language_model/data/wikitext-2/$corpus.txt)
    ln -snf $absolute_path $data/wikitext-2/$corpus.txt
done

# download a different interesting data set!
# Jane Austen's 'Pride and Prejudice', 'Emma' and 'Sense and Sensibility'

mkdir -p $data/austen/raw

cp example_data/austen_corpus.txt $data/austen/raw/

# preprocess slightly

cat $data/austen/raw/austen_corpus.txt | python $base/scripts/preprocess_raw.py > $data/austen/raw/austen_corpus.cleaned.txt

# shuffle lines of the file in order that training, validation and testing parts are equally diverse

shuf $data/austen/raw/austen_corpus.cleaned.txt -o $data/austen/raw/shuffled_lines.austen_corpus.cleaned.txt

# tokenize, fix vocabulary upper bound

cat $data/austen/raw/shuffled_lines.austen_corpus.cleaned.txt | python $base/scripts/preprocess.py --vocab-size 15000 --tokenize --lang "en" > $data/austen/raw/shuffled_lines.austen_corpus.preprocessed.txt

# split into train, valid and test

head -n 3000 $data/austen/raw/shuffled_lines.austen_corpus.preprocessed.txt > $data/austen/test.txt
head -n 6000 $data/austen/raw/shuffled_lines.austen_corpus.preprocessed.txt | tail -n 3000  > $data/austen/valid.txt
tail -n 30045 $data/austen/raw/shuffled_lines.austen_corpus.preprocessed.txt > $data/austen/train.txt
