class Users::EventMemoriesController < ApplicationController
  before_action :find_parent_user

  def index
    authorize!
    @event_memories = @user.event_memories
  end

  def show
    authorize!
    @event_memory = find_event_memory
  end

  def new
    @event_memory = @user.event_memories.build(new_params)
    @event_memory.validate
    authorize! @event_memory
  end

  def edit
    @event_memory = find_event_memory
    authorize! @event_memory
  end

  def create
    @event_memory = @user.event_memories.new(create_params)
    authorize! @event_memory

    if @event_memory.save
      redirect_to user_event_memories_path(@user), notice: 'EventMemory was successfully created'
    else
      render :new
    end
  end

  def update
    @event_memory = find_event_memory
    authorize! @event_memory
    if @event_memory.update(update_params)
      redirect_to [@user, @event_memory], notice: 'EventMemory was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event_memory = find_event_memory
    authorize! @event_memory
    @event_memory.destroy
    redirect_to users_url, notice: 'EventMemory was successfully destroyed.'
  end

  private

  def find_parent_user
    @user = User.friendly.find(params[:user_id])
  end

  def find_event_memory
    EventMemory.friendly.find(params[:id])
  end

  def new_params
    params.permit(:user_id, :event_id, :started_at)
  end

  def create_params
    create_params = params.require(:event_memory).permit(:event_id, :started_at, :body, :urls)
    create_params[:urls] = create_params[:urls].each_line.to_a.compact
    create_params
  end

  def update_params
    update_params = params.require(:event_memory).permit(:body, :urls)
    update_params[:urls] = update_params[:urls].each_line.to_a.compact
    update_params
  end
end