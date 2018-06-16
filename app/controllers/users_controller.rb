class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
  #binding.pry
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'Cadastro criado com sucesso!' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(
        :full_name, :bio, :password, :password_confirmation, :email, :location
    )
  end



end