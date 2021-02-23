# == Schema Information
#
# Table name: todo_list_items
#
#  id           :bigint           not null, primary key
#  description  :string
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  todo_list_id :bigint           not null
#
# Indexes
#
#  index_todo_list_items_on_todo_list_id  (todo_list_id)
#
# Foreign Keys
#
#  fk_rails_...  (todo_list_id => todo_lists.id)
#
require 'rails_helper'

RSpec.describe TodoListItem, type: :model do
  subject { create(:todo_list_item) }

  describe 'columns' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:todo_list) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index((:todo_list_id)) }
  end
end
