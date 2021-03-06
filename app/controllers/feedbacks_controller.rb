class FeedbacksController < ApplicationController
  def create
    @tv_show = TvShow.find(params[:tv_show_id])
    @feedback = Feedback.new(feedback_params)
    @feedback.user = current_user
    @feedback.tv_show = @tv_show
    @feedbacks_like_number = Feedback.where(tv_show_id: @tv_show.id, status: "Like").count
    @feedbacks_dislike_number = Feedback.where(tv_show_id: @tv_show.id, status: "Dislike").count
    @feedbacks_superlike_number = Feedback.where(tv_show_id: @tv_show.id, status: "Superlike").count

    respond_to do |format|
      if @feedback.save!
        format.html { render partial:"shared/likes-votes-scores", locals: {tv_show: @tv_show, feedbacks_superlike_number: @feedbacks_superlike_number, feedbacks_like_number: @feedbacks_like_number, feedbacks_dislike_number: @feedbacks_dislike_number} }
        format.json
      else
        format.html { render "tv_show/show" }
        format.json
      end
    end
  end

  def update
    @tv_show = TvShow.find(params[:tv_show_id])

    @feedback = Feedback.find(params[:id])

    if params[:feedback].blank?
      @feedback.update(status: params[:status])
    else
      @feedback.update(feedback_params)
    end
    @feedbacks_like_number = Feedback.where(tv_show_id: @tv_show.id, status: "Like").count
    @feedbacks_dislike_number = Feedback.where(tv_show_id: @tv_show.id, status: "Dislike").count
    @feedbacks_superlike_number = Feedback.where(tv_show_id: @tv_show.id, status: "Superlike").count

    @feedback_of_user = Feedback.where(tv_show_id: @tv_show.id, user_id: current_user).where.not(comment: nil).last




    respond_to do |format|
      format.html { redirect_to tv_show_path(params[:tv_show_id]) }
      format.js { render partial:"shared/votes_scores", locals: {tv_show: @tv_show, feedbacks_superlike_number: @feedbacks_superlike_number, feedbacks_like_number: @feedbacks_like_number, feedbacks_dislike_number: @feedbacks_dislike_number} }
      format.text { render partial: "feedbacks/user_feedback", locals: { tv_show: @tv_show, feedback_of_user: @feedback_of_user,  }, formats: [:html] }
      format.json  { render json: @feedback }
    end

  end

  private

  def feedback_params
        params.require(:feedback).permit(:comment, :status, :rating)
  end
end
