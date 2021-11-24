class My::OfflineSchedulesController < ApplicationController::Bootstrap
  before_action :find_current_user

  def index
    authorize!
    @offline_schedules = @user.offline_schedules.page(params[:page])
  end

  def show
    @offline_schedule = find_offline_schedule
    authorize! @offline_schedule
  end

  def new
    authorize!
    @offline_schedule = @user.offline_schedules.build
  end

  def edit
    @offline_schedule = find_offline_schedule
    authorize! @offline_schedule
  end

  def create
    @offline_schedule = @user.offline_schedules.build(offline_schedule_params)
    authorize! @offline_schedule

    if @offline_schedule.save
      redirect_to my_offline_schedules_path, notice: I18n.t('notice.my/offline_schedules.create.success')
    else
      render :new
    end
  end

  def update
    @offline_schedule = find_offline_schedule
    authorize! @offline_schedule

    if @offline_schedule.update(offline_schedule_params)
      redirect_to my_offline_schedules_path, notice: I18n.t('notice.my/offline_schedules.update.success')
    else
      render :edit
    end
  end

  def destroy
    @offline_schedule = find_offline_schedule
    authorize! @offline_schedule
    @offline_schedule.destroy
    redirect_to my_offline_schedules_path, notice: I18n.t('notice.my/offline_schedules.destroy.success')
  end

  private

  def find_current_user
    @user = current_user
  end

  def find_offline_schedule
    @user.offline_schedules.find_by(uid: params[:id])
  end

  def offline_schedule_params
    params.require(:offline_schedule).permit(:name, :start_at, :end_at, :repeat, :repeat_until)
  end
end
