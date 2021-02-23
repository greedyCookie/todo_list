# == Schema Information
#
# Table name: todo_lists
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_todo_lists_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class TodoList < ApplicationRecord
  has_many :todo_list_items, dependent: :destroy
  belongs_to :user, required: true
end
