class CreateTodoListItems < ActiveRecord::Migration[6.1]
  def change
    create_table :todo_list_items do |t|
      t.string :title
      t.string :description
      t.references :todo_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
