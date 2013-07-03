class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]   # railstutorial.org Listings 9.12, 9.22, 9.46
  before_filter :correct_user,   only: [:edit, :update]   # railstutorial.org Listing 9.15 (continued below)
  before_filter :admin_user,     only: :destroy           # Listing 9.48
  before_filter :new_user,  only: [:new, :create]    # Exercise 9.6.6
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  # railstutorial.org Listing 9.35
  def index
    @users = User.paginate(page: params[:page])
  end
  
  # railstutorial.org Listing 9.2
  def edit
    # @user = User.find(params[:id])    # removed in Listing 9.15
  end
  
  # railstutorial.org Listing 9.8
  def update
    # @user = User.find(params[:id])    # removed in Listing 9.15
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  # railstutorial.org Listing 9.46
  # railstutorial.org Exercise 9.6.9
  def destroy
    user = User.find(params[:id])
    if (current_user == user) && (current_user.admin?)
      flash[:error] = "You cannot delete yourself."
      redirect_to root_path
    else
      user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end
  
  # railstutorial.org Listing 9.12
  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
    
    # railstutorial.org Listing 9.15
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    # railstutorial.org Listing 9.48
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    # railstutorial.org Exercise 9.6.6
    def new_user
      redirect_to(root_path) unless !signed_in?
    end
end