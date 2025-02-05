class ItemsController < ApplicationController
    before_action :set_todo
    before_action :set_todo_item, only: [:show, :update, :destroy]
  
    # GET /todos/:todo_id/items
    def index
      render json: @todo.items
    end
  
    # GET /todos/:todo_id/items/:id
    def show
      render json: @item
    end
  
    # POST /todos/:todo_id/items
    def create
        @item = @todo.items.create!(item_params)
        json_response(@item, :created)
      rescue ActiveRecord::RecordInvalid => e
        json_response({ error: e.message }, :unprocessable_entity)
    end
      
      
  
    # PUT /todos/:todo_id/items/:id
    def update
        if @item.update(item_params)
          head :no_content # 204 status code
        else
          render json: @item.errors, status: :unprocessable_entity # 422 status code
        end
      end
  
    # DELETE /todos/:todo_id/items/:id
    def destroy
        if @item.destroy
          head :no_content
        else
          json_response({ error: "Item not found or could not be deleted" }, :unprocessable_entity)
        end
      end
      
  
    private
  
    def item_params
        params.permit(:name, :done)
      end
      
  
    def set_todo
      @todo = Todo.find(params[:todo_id])
    end

    def set_todo_item
        @item = @todo.items.find(params[:id])
      end      
  end
  