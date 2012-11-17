class CreateTableTags < ActiveRecord::Migration
  def up
    drop_table :tags
  end

    def down
      drop_table :tags
    end
end
