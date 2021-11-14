class Users::EventMemoriesController < ApplicationController::Bootstrap
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
      redirect_to user_event_memories_path(@user), notice: I18n.t('notice.users/event_memories.create.success')
    else
      render :new
    end
  end

  def update
    @event_memory = find_event_memory
    authorize! @event_memory
    if @event_memory.update(update_params)
      redirect_to [@user, @event_memory], notice: I18n.t('notice.users/event_memories.update.success')
    else
      render :edit
    end
  end

  def destroy
    @event_memory = find_event_memory
    authorize! @event_memory
    @event_memory.destroy
    redirect_to users_url, notice: I18n.t('notice.users/event_memories.destroy.success')
  end

  private

  def find_parent_user
    @user = User.friendly.find(params[:user_id])
  end

  def find_event_memory
    @user.event_memories.find_by(uid: params[:id])
  end

  def new_params
    new_params = params.permit(:user_id, :event_id, :started_at)
    new_params[:event_id] = Event.friendly.find(new_params[:event_id]).id
    new_params
  end

  def create_params
    create_params = params.require(:event_memory).permit(:event_id, :started_at, :body, :urls)
    create_params[:event_id] = Event.friendly.find(create_params[:event_id]).id
    create_params[:urls] = create_params[:urls].each_line.to_a.compact
    create_params
  end

  def update_params
    update_params = params.require(:event_memory).permit(:body, :urls)
    update_params[:urls] = update_params[:urls].each_line.to_a.compact
    update_params
  end
end
