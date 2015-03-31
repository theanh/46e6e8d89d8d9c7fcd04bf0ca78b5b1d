#App Survey
Application allows user to take a survey

#How to run
1. Install dependencies
2. Migrate database
  - i.e. Setup sample data
  + Install dependencies: `bundle install --path vendor/bundle`
  + Clone sample_database.yml into database.yml and change config to connect your database.
  + Create database & sample data: `bundle exec rake db:setup`

#Note
- This app contains hightchart js that allows using under free licenses only for non-profit projects.
  + There are several free JavaScript Libraries, i.e. Raphaël, that can be extended to draw charts easily.
- Ruby gem:
  + `gem 'survey', '~> 0.1'`: https://github.com/runtimerevolution/survey
    - According to Author: "Survey models were designed to be flexible enough in order to be extended and integrated with your own models."
    - This gem defines the concept of participant: "Every participant can respond to surveys and every response is registered as a attempt"
    - Thank you Runtime Revolution for this gem!

#Sample data
  References 
  - http://www.swc.com/perspective/surveys
  - http://www.swc.com/uploads/2012_Tech_Trends_Survey.pdf

#Documentation
  + Please check https://github.com/theanh/46e6e8d89d8d9c7fcd04bf0ca78b5b1d/wiki/Document
