class TodoListsController < ApplicationController
  before_action :authenticate_user!

  def index
    @todo_lists = current_user.todo_lists

    render json: @todo_lists, each_serializer: TodoListSerializer
  end

  def create
    @todo_list = current_user.todo_lists.create(list_params)

    render_todo_list
  end

  def show
    @todo_list = current_user.todo_lists.find(params[:id])

    render_todo_list
  end

  def update
    @todo_list = current_user.todo_lists.find(params[:id])
    @todo_list.update(list_params)

    render_todo_list
  end

  def destroy
    @todo_list = current_user.todo_lists.find(params[:id])

    @todo_list.destroy

    head :ok
  end

  private

  def list_params
    params.require(:todo_list).permit(:name)
  end

  def render_todo_list
    render json: @todo_list, serializer: TodoListSerializer
  end
end
