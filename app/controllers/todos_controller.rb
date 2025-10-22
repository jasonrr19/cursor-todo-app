# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :set_todo, only: %i[show edit update destroy toggle]

  def index
    @todos = Todo.order(created_at: :desc)
    @todo = Todo.new
  end

  def show
  end

  def new
    @todo = Todo.new
  end

  def edit
  end

  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to todos_path, notice: 'Todo was successfully created.' }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@todo, partial: 'todos/form', locals: { todo: @todo })
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to @todo, notice: 'Todo was successfully updated.' }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@todo, partial: 'todos/form', locals: { todo: @todo })
        end
      end
    end
  end

  def destroy
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to todos_path, notice: 'Todo was successfully deleted.' }
      format.turbo_stream
    end
  end

  def toggle
    @todo.toggle!
    respond_to do |format|
      format.html { redirect_to todos_path }
      format.turbo_stream
    end
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :completed)
  end
end
