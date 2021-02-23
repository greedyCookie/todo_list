class TodoListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_todo_list

  def index
    @todo_list_items = @todo_list.todo_list_items

    render json: @todo_list_items, each_serializer: TodoListItemSerializer
  end

  def create
    @todo_list_item = @todo_list.todo_list_items.create(list_item_params)

    render_todo_list_item
  end

  def show
    @todo_list_item = @todo_list.todo_list_items.find(params[:id])

    render_todo_list_item
  end

  def update
    @todo_list_item = @todo_list.todo_list_items.find(params[:id])
    @todo_list_item.update(list_item_params)

    render_todo_list_item
  end

  def destroy
    @todo_list_item = @todo_list.todo_list_items.find(params[:id])

    @todo_list_item.destroy

    head :ok
  end

  private

  def list_item_params
    params.require(:todo_list_item).permit(:todo_list_id, :title, :description)
  end

  def render_todo_list_item
    render json: @todo_list_item, serializer: TodoListItemSerializer
  end

  def find_todo_list
    @todo_list = current_user.todo_lists.find(params[:todo_list_id])
  end
end
