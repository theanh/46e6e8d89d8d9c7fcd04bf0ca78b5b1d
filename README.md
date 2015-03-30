#App Survey
Application allows user to take a survey

#How to run
1. Install dependencies
2. Migrate database
3. Setup sample data
- Run these commands:
  + Install dependences: `bundle install --path vendor/bundle`
  + Create database & sample data: `bundle exec rake db:setup`

#Note
- This app contain hightchart js that allow using under free licenses only for non-profit project.
- Ruby gem:
  + `gem 'survey', '~> 0.1'`: https://github.com/runtimerevolution/survey
    - According to author: "Survey models were designed to be flexible enough in order to be extended and integrated with your own models."
    - Thank you Runtime Revolution for this gem!

#Sample data
  Reference from 
  - http://www.swc.com/perspective/surveys
  - http://www.swc.com/uploads/2012_Tech_Trends_Survey.pdf

#Documentation
  + Please check https://github.com/theanh/46e6e8d89d8d9c7fcd04bf0ca78b5b1d/wiki/Document
