class AddSubmissionReferenceToInfectedKeys < ActiveRecord::Migration[6.0]
  def change
    add_reference :infected_keys, :submission, index: true, foreign_key: true, null: false
  end
end
