class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end
  def index_user
    @count = 0
        matching_photos = Photo.all

    @list_of_photos = matching_photos.order({ :created_at => :desc })

  #  render({ :template => "photos/index.html.erb" })
    @users = User.all.order({ :username => :asc })
    un = params.fetch("username")
    @un = un
    render({ :template => "users/index_username.html.erb" })
  end

    def feed
    @count = 0
        matching_photos = Photo.all
      @index_counter=-1
    @list_of_photos = matching_photos.order({ :created_at => :desc })
    

  #  render({ :template => "photos/index.html.erb" })
    @users = User.all.order({ :username => :asc })
    un = params.fetch("username")
    
    @un = un
    @my_photos = Photo.where({:owner_id => User.where({:username => @un}).at(0).id })
    @following = User.where({:username => @un}).at(0).following
    #Photo.where({:owner_id => User.where({:username => @un}).at(0).following.at(0).id })
    #User.where({:username => @un}).at(0).following.at(0).id
    render({ :template => "users/index_feed.html.erb" })
  end

    def new_registration_form
      render({ :template => "users/signup_form.html.erb" })
    end

   def new_session_form
      render({ :template => "users/signin_form.html.erb" })
    end
     def authenticate
      un = params.fetch("input_username")
      pw = params.fetch("input_password")
      user = User.where({ :username => un}).at(0)

      if (user==nil) 
        redirect_to("/user_sign_in", {:alert => "nobody by that name"})
      else
        if (user.authenticate(pw))
          session.store(:user_id,user.id)
          session.store(:user_username, un)
          redirect_to("/", {:notice => "Welcome back " + user.username})
        else
          redirect_to("/user_sign_in", {:alert => "wrong password"})
        end
      end

      #render({ :plain => "hi" })
    end
  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end
  def toast_cookies
    reset_session
    redirect_to("/", {:notice => "See ya later"})
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")

    save_status = user.save

    if (save_status)
      session.store(:user_id, user.id)
      session.store(:user_username, user.username)
      redirect_to("/users/#{user.username}", { :notice => "Welcome, " + user.username + "!"})
    else
      redirect_to("/user_sign_up", {:alert => user.errors.full_messages.to_sentence})
    end
    
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch("input_username")

    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

end