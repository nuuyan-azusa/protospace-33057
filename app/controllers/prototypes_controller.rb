class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new,:edit,:destroy]
  before_action :move_to_edit,only: [:edit]
  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end
  
  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    prototype = Prototype.find(params[:id])
    if prototype.update(prototype_params)
      redirect_to prototype_path(prototype.id)
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    if prototype.destroy
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def prototype_params
    params.require(:prototype).permit(:title,:catch_copy,:concept,:user,:image).merge(user_id: current_user.id)
  end

  def move_to_edit
    unless user_signed_in?
      redirect_to root_path
    end
  end
  
end
