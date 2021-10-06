class FeedbacksController < ApplicationController
  skip_before_action :require_login

  def new
    @user = current_user
    @feedback = Feedback.new(user: @user)
    authorize! @feedback
  end

  def create
    @user = current_user
    @feedback = Feedback.new(feedback_params.merge(user: @user, user_uid: @user&.uid))
    authorize! @feedback

    if @feedback.save
      redirect_to done_feedbacks_path
    else
      render :new
    end
  end

  def done
    authorize!
  end

  private

  def feedback_params
    @feedback_params ||= params.require(:feedback).permit(:title, :body)
  end
end
