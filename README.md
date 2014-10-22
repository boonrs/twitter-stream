twitter-stream
==============

Coding exercise for [MediSas](http://www.medisas.com/).

## Assignment
Use Twitter's sample streaming API to show the top 10 retweeted tweets (note the retweeted_status field) in a rolling window of time, where the window's start is n minutes ago (where n is defined by the user) and the window's end is the current time.

Output should continuously update and include the tweet text and number of times retweeted in the current rolling window.

## Usage
Prerequisites: [ruby](https://www.ruby-lang.org/en/) & [bundler](http://bundler.io/)

1. Add twitter environment variables. Copy the environment template and add credentials: `cp template.env .env`
1. To run: `ruby program.rb`