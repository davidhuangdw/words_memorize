
# The Words Memorizing App

### Features

1. lookup dictionary (including 770k words, 56k frequent words)
    * words recommendation as user inputs, and allows input errors(insert/delete/replace)
	    * current strategy(front-end): allowed_errors = min(input_length/4, 2)
    * click 'forgot' to save the word into memo

2. record and test Memos(saved unknown words)
    * random test: with the probability proportional to the memo_word's weight
        * weight: by recent forgotten rate and the word's frequency_rank
    * select a word to test from the sorted memo-list
    
### Performance

* recommendation query:
    * each query recommends the most frequent 50 words from the 56k frequent words
    * <20MB extra memory usage
        * O(n*w) memory and pre-process time
    * 5-50ms server side for each recommend query
        * when recommend 50 words with <= 2 allowed_errors

### Install

1. install and start MongoDB

2. import the dictionary into MongoDB:

    ```
    # ecdict csv file can be downloaded from: https://github.com/skywind3000/ECDICT/blob/master/ecdict.csv

    cd words_memorize_backend/
    bundle install
    bundle exec rake import:from_ecdict_csv[ecdict_csv_file_path]
    ```

### Start App

1. build front-end:

    ```
    cd words_memorize_frontend/
    yarn
    yarn build
    ```
    
2. start rails (./public has been soft linked to words_memorize_frontend/dist)

    ```
    cd words_memorize_backend/
    rails s
    ```
    
3. http://localhost:3000/

