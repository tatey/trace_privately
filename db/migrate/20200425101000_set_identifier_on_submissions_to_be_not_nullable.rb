class SetIdentifierOnSubmissionsToBeNotNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :submissions, :identifier, false
  end
end
