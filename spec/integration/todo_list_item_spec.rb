require 'rails_helper'

RSpec.resource 'todo lists' do
  include_context 'integration'

  let(:user) { create(:user) }
  let(:todo_list) { create(:todo_list, user: user) }
  let(:todo_list_id) { todo_list.id }

  let(:target_list_item) { create(:todo_list_item, todo_list: todo_list) }

  get '/user/todo_lists/:todo_list_id/todo_list_items' do
    shared_examples_for 'index :success' do
      example 'successful responce' do
        do_request

        expect(status).to be(200)

        expect(data.size).to eq(expected_items.size)

        if data.size > 0
          expect(data.is_a? Array).to be(true)

          expected_keys = %w(id title description created_at updated_at)

          expect(data.first.keys).to eq(expected_keys)
        end
      end
    end

    context 'when user is authenticated' do
      before do
        sign_in user
      end

      context 'when user has todo_list with items' do
        let!(:expected_items) do
          create_list(:todo_list_item, 3, todo_list: todo_list)
        end

        it_behaves_like 'index :success'
      end

      context 'when there are no items in user`s todo list' do
        let(:expected_items) { [] }

        it_behaves_like 'index :success'
      end
    end

    it_behaves_like 'when user not authenticated'
  end

  get '/user/todo_lists/:todo_list_id/todo_list_items/:id' do
    context 'when user is authenticated' do
      let!(:id) { target_list_item.id }

      before do
        sign_in user
      end

      example 'will show requested todo_list_item' do
        do_request

        expected_attribute_names = %w(id title description)
        received_attributes = expected_attribute_names.map{ |a| data[a] }
        expected_attributes = expected_attribute_names.map{ |a| target_list_item.send(a) }

        expect(received_attributes).to match_array(expected_attributes)
      end
    end

    it_behaves_like 'when user not authenticated'
  end

  post '/user/todo_lists/:todo_list_id/todo_list_items' do
    context 'when user is authenticated' do
      let(:title) { FFaker::Lorem.sentence(2) }
      let(:description) { FFaker::Lorem.sentence(2) }
      let(:params) { { todo_list_item: { title: title, description: description } } }

      before do
        sign_in user
      end

      example 'will create todo_list_item' do
        expect{ do_request(params) }.to change{ todo_list.reload.todo_list_items.count }.by(1)

        expected_item_attrs = todo_list.reload.todo_list_items
                                       .last.attributes.slice('title', 'description').symbolize_keys

        expect(expected_item_attrs).to match({ title: title, description: description })
      end
    end

    it_behaves_like 'when user not authenticated'
  end

  put '/user/todo_lists/:todo_list_id/todo_list_items/:id' do
    context 'when user is authenticated' do
      let(:id) { target_list_item.id }
      let(:title) { FFaker::Lorem.sentence(2) }
      let(:params) { { todo_list_item: { title: title } } }

      before do
        sign_in user
      end

      example 'will update todo_list_item' do
        expect{ do_request(params) }.to change{ target_list_item.reload.title }.to(title)
      end
    end

    it_behaves_like 'when user not authenticated'
  end

  delete '/user/todo_lists/:todo_list_id/todo_list_items/:id' do
    context 'when user is authenticated' do
      let!(:id) { target_list_item.id }

      before do
        sign_in user
      end

      example 'will delete todo_list_item' do
        expect { do_request }.to change { todo_list.reload.todo_list_items.count }.by(-1)
      end
    end

    it_behaves_like 'when user not authenticated'
  end
end
