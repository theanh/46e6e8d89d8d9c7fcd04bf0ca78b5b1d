class AddFieldsToTable < ActiveRecord::Migration
  def change
    add_column :survey_answers, :deleted_at, :datetime, after: :correct
    add_column :survey_attempts, :deleted_at, :datetime, after: :score
    add_column :survey_options, :deleted_at, :datetime, after: :correct
    add_column :survey_questions, :deleted_at, :datetime, after: :text
    add_column :survey_surveys, :deleted_at, :datetime, after: :active
  end
end
