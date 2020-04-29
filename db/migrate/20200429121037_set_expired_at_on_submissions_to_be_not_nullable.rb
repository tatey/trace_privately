class SetExpiredAtOnSubmissionsToBeNotNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :submissions, :expired_at, false
  end
end
