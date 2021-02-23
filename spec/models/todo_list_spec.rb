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
require 'rails_helper'

RSpec.describe TodoList, type: :model do
  subject { create(:todo_list) }

  describe 'columns' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: true) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:todo_list_items) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index((:user_id)) }
  end
end
