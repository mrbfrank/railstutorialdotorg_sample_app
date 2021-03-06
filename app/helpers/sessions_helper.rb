module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end
  
  # Check if there is a current user in the session, used to change layout for signed-in users (Listing 8.23)
  def signed_in?
    !current_user.nil?
  end
    
  # railstutorial.org Listing 8.20
  def current_user=(user)
    @current_user = user
  end
  
  # railstutorial.org Listing 8.22
  def current_user
      @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  
  # railstutorial.org Listing 9.16
  def current_user?(user)
    user == current_user
  end
  
  # railstutorial.org Listing 10.27
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
  
  # railstutorial.org Listing 8.30
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  # railstutorial.org Listing 9.18
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end