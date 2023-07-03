class FavoritesController < ApplicationController

    def index
        @user = User.find(session[:user_id])
        @recipes = @user.favorite_recipes.paginate(page: params[:page], per_page: 9)
    end

    def create
        @user = User.find(session[:user_id])
        recipe = Recipe.find(params[:item_id])
        favorite = Favorite.new(recipe_id: recipe.id)
        @user.favorites << favorite unless @user.favorites.include?(favorite)
    end

    def destroy
        favorite = Favorite.find_by(user_id: session[:user_id], recipe_id: params[:id])
        favorite.destroy
        if request.referrer.include?('favorites')
            redirect_to favorites_path
        end
    end

end
  