class Admin::SubmissionsController < ApplicationController
  def index
    @submissions = Submission.by_recently_created_first.limit(1_000) # TODO: Paginate?
  end

  def show
    @submission = Submission.find(params[:id])
  end

  def update
    submission = Submission.find(params[:id])
    submission.update(params.require(:submission).permit(:result))
    redirect_to admin_submission_path(submission), notice: t(".flashes.success", number: submission.number)
  end
end
