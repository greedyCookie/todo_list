require 'rails_helper'

RSpec.resource 'todo list items' do
  include_context 'integration'

  let(:user) { create(:user) }
  let!(:todo_lists) { create_list(:todo_list, 3, user: user) }

  get '/user/todo_lists' do
    shared_examples_for 'index :success' do
      example 'successful responce' do
        do_request

        expect(status).to be(200)

        expect(data.size).to eq(todo_lists.size)

        if data.size > 0
          expect(data.is_a? Array).to be(true)

          expected_keys = %w(id name created_at updated_at todo_list_items)

          expect(data.first.keys).to eq(expected_keys)
        end
      end
    end

    context 'when user is authenticated' do
      before do
        sign_in user
      end

      context 'when user has todo_lists' do
        it_behaves_like 'index :success'
      end

      context 'when user doesn`t have todo_lists' do
        let(:todo_lists) { [] }

        it_behaves_like 'index :success'
      end
    end

    it_behaves_like 'when user not authenticated'
  end

  get '/user/todo_lists/:id' do
    context 'when user is authenticated' do
      let(:target_todo_list) { user.todo_lists.last }
      let!(:todo_list_item) { create(:todo_list_item, todo_list: target_todo_list) }
      let(:id) { target_todo_list.id }

      before do
        sign_in user
      end

      example 'will show requested todo_list' do
        do_request

        expected_attribute_names = %w(id name)
        received_attributes = expected_attribute_names.map{ |a| data[a] }
        expected_attributes = expected_attribute_names.map{ |a| target_todo_list.send(a) }

        expect(received_attributes).to match_array(expected_attributes)

        received_item_id = data['todo_list_items'].first['id']

        expect(received_item_id).to eq(todo_list_item.id)
      end
    end

    it_behaves_like 'when user not authenticated'
  end

  post '/user/todo_lists' do
    context 'when user is authenticated' do
      let(:name) { FFaker::Lorem.word }
      let(:params) { { todo_list: { name: name } } }

      before do
        sign_in user
      end

      example 'will create todo_lists' do
        expect{ do_request(params) }.to change{ TodoList.count }.by(1)

        expected_todo_list_name = user.reload.todo_lists.last.name

        expect(expected_todo_list_name).to eq(name)
      end
    end

    it_behaves_like 'when user not authenticated'
  end

  put '/user/todo_lists/:id' do
    context 'when user is authenticated' do
      let(:target_todo_list) { user.todo_lists.last }
      let(:id) { target_todo_list.id }
      let(:name) { FFaker::Lorem.word }
      let(:params) { { todo_list: { name: name } } }

      before do
        sign_in user
      end

      example 'will update todo_lists' do
        expect{ do_request(params) }.to change{ target_todo_list.reload.name }.to(name)
      end
    end

    it_behaves_like 'when user not authenticated'
  end

  delete '/user/todo_lists/:id' do
    context 'when user is authenticated' do
      let(:target_todo_list) { user.todo_lists.last }
      let(:id) { target_todo_list.id }

      before do
        sign_in user
      end

      example 'will delete todo_list' do
        expect { do_request }.to change { user.reload.todo_lists.count }.by(-1)
      end
    end

    it_behaves_like 'when user not authenticated'
  end
end
