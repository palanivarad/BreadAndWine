class RecipesController < ApplicationController

    def new
        @recipe = Recipe.new
    end
  
    def create
        ActiveRecord::Base.transaction do
            @recipe = Recipe.new(recipes_params)
            @recipe.user_id = session[:user_id]
            if @recipe.save
                ingredients = params[:ingredient]
                quantity = params[:quantity]
                directions = params[:directions]
                ingredients.zip(quantity).each do |ing, quan|
                    @ingredient = Ingredient.find_or_create_by(ingredient_name: ing)
                    @recipe_ingredient = RecipeIngredient.new(recipe_id: @recipe.id, ingredient_id: @ingredient.id, quantity: quan)
                    if  !@recipe_ingredient.save
                        byebug
                        raise ActiveRecord::Rollback
                    end
                    byebug
                end
                count = 1
                directions.each do |step|
                    @direction = Step.new(recipe_id: @recipe.id, step_no: count, direction: step)
                    if !@direction.save 
                        raise ActiveRecord::Rollback
                    end
                    count += 1
                end
                flash[:notice] = "Recipe posted sucessfully!"
                redirect_to root_path
            else
                flash[:alert] = "Couldn't cook recipe. Please, Try Again."
                render 'new'
            end
        end
    end

    def edit
        @recipe = Recipe.find_by(recipe_name: , user_id: )
    end

    def update
    end
  
    def destroy
      
    end

    private
    def recipes_params
        params.require(:recipe).permit(:recipe_name, :cuisine, :kind)
    end

  end
  