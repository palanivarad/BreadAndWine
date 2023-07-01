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
                        raise ActiveRecord::Rollback
                    end
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

    def index
        @user = User.find(session[:user_id])
        if params[:query].present?
            if params[:query] =~ /\A[a-zA-Z]+\z/
                @recipes = Recipe.where("recipe_name LIKE ?", "%#{params[:query]}%").paginate(page: params[:page], per_page: 9)
            else
                flash[:alert] = "Invalid Request"
                redirect_to recipes_path
            end
        elsif params[:ing_query].present?
            ingredient_names = params[:ing_query].split(',').map(&:strip)
            valid_ingredients = ingredient_names.all? { |element| element =~ /\A[a-zA-Z]+\z/ }

            if valid_ingredients
                @recipes = Recipe.joins(:ingredients).where(ingredients: { ingredient_name: ingredient_names }).distinct.paginate(page: params[:page], per_page: 9)
            else
                flash[:alert] = "Invalid Ingredients"
                redirect_to recipes_path
            end

        else
            @recipes = Recipe.paginate(page: params[:page], per_page: 9)
        end
    end

    def show
        @recipe = Recipe.find(params[:id])
        @recipe_ingredients = @recipe.recipe_ingredients
        @ingredients = @recipe.ingredients
        @steps = @recipe.steps.order("step_no")
    end

    def edit
        @recipe = Recipe.find(params[:id])
        @recipe_ingredients = @recipe.recipe_ingredients
        @ingredients = @recipe.ingredients
        @steps = @recipe.steps.order("step_no") 
    end

    def update
        @oldrecipe = Recipe.find(params[:id])
        @oldrecipe.destroy
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
                        raise ActiveRecord::Rollback
                    end
                end
                count = 1
                directions.each do |step|
                    @direction = Step.new(recipe_id: @recipe.id, step_no: count, direction: step)
                    if !@direction.save 
                        raise ActiveRecord::Rollback
                    end
                    count += 1
                end
                flash[:notice] = "Recipe edited sucessfully!"
                redirect_to root_path
            else
                flash[:alert] = "Couldn't cook recipe. Please, Try Again."
                render 'new'
            end
        end

    end
  
    def destroy
      @recipe = Recipe.find(params[:id])
      @recipe.destroy
      redirect_to '/myrecipes'
    end

    def myrecipes
        @recipes = Recipe.where("user_id = ?", session[:user_id]).paginate(page: params[:page], per_page: 9)
    end

    private
    def recipes_params
        params.require(:recipe).permit(:recipe_name, :cuisine, :kind, :image)
    end

  end
  