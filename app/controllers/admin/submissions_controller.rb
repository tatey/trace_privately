class Admin::SubmissionsController < ApplicationController
  def index
    @submissions = Submission.by_recently_created_first.limit(1_000) # TODO: Paginate?
  end
end
