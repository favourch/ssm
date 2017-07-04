class CreateClassHomeworks < ActiveRecord::Migration
  def self.up
    create_table :class_homeworks do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :class_homeworks
  end
end
