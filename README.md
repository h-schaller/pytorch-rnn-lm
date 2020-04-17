# Pytorch RNN Language Models

This repo shows how to train neural language models using [Pytorch example code](https://github.com/pytorch/examples/tree/master/word_language_model).

# Requirements

- This only works on a Unix-like system, with bash.
- Python 3 must be installed on your system, i.e. the command `python3` must be available
- Make sure virtualenv is installed on your system. To install, e.g.

    `pip install virtualenv`

# Steps

Clone this repository in the desired place:

    git clone https://github.com/bricksdont/pytorch-rnn-lm
    cd pytorch-rnn-lm

Create a new virtualenv that uses Python 3. Please make sure to run this command outside of any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell script above.

Download and install required software:

    ./scripts/install_packages.sh

Download and preprocess data:

    ./scripts/download_data.sh

Train a model:

    ./scripts/train.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Generate (sample) some text from a trained model with:

    ./scripts/generate.sh

___

# Changes from the original scripts:

The following elements were changed in:

download_data.sh
- A folder 'austen' is created in the data folder.
- A language model is created based on the three best-known novels of Jane Austen: _Pride and Prejudice_, _Sense and Sensibility_ and _Emma_. The textfile with the texts from these three novels (retrieved from Project Gutenberg) are already provided in the forked repo in the 'example_data' folder.
- A vocabulary size of 10000 was chosen.
- The preprocessing steps are the same except for the additional shuf command. This was added that training data, test data and validation data all have lines from all three novels.
- Since the preprocessed file has 36045 lines, the test and validation files received each 3000 lines whereas the training file had the rest of 30045 lines. This way, the training data is approximately ten times larger than the test and validation data.

train.sh
- Data is taken from the 'austen' folder.
- Nine models were trained with different hyperparameters (number of epochs, embedding size, dropout). These values were for the training of each model adjusted in train.sh. (And of course every model has to be saved with a different name.)

generate.sh
- Data is taken from the 'austen' folder.
- Number of words was increased to 300.
- The best model was used for text generation.

# How to recreate the training and text generation process
- run scripts/download_data.sh
- run scripts/train.sh and change the following parameters in the script to train each model*:
--epochs | --emsize and --nhid | --dropout | --save
--- | --- | --- | ---
40 | 200 | 0.5 | $models/model1.pt
40 | 250 | 0.5 | $models/model2.pt
40 | 150 | 0.5 | $models/model3.pt
40 | 200 | 0.3 | $models/model4.pt
40 | 200 | 0.7 | $models/model5.pt
40 | 250 | 0.3 | $models/model6.pt
50 | 225 | 0.5 | $models/model7.pt
40 | 100 | 0.5 | $models/model8.pt
40 | 300 | 0.5 | $models/model9.pt
\* The training of some models took slightly longer than 2 hours when something else was done on the computer in parallel.


- run scripts/generate.sh (I already inserted the name of the model with the lowest perplexity.) The generated text will be in the 'samples' file.

# Findings from experimenting with hyperparameters

The following results were achieved when training the models:

_Models with 40 epochs, dropout of 0.5:_
Embedding size | Test perplexity (↓)
--- | ---
100 | 97.48
150 | 89.60
200 | 85.20
250 | 81.37
300 | 79.78
The model on the last line with embedding size 300 and the other specified hyperparamters was the one that achieved to lowest perplexity of all trained models.

_Some further models I experimented with:_
Epochs | Embedding size | Dropout | Test perplexity (↓)
--- | --- | --- | ---
40 | 200 | 0.7 | 103.55
50 | 225 |0.5 | 82.96
40 | 200 | 0.3 | 80.63
40 | 250 | 0.3 | 80.14

As can be seen from the above data, it can be confirmed that the perplexity decreases with increasing embedding size. However, maybe a lower perplexity could have been achieved when also lowering the dropout somewhat since the model with the second-lowest perplexity had an embedding size of 250 and a dropout of 0.3.
