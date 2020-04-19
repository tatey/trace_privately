class InfectedKeysController < ApplicationController
  skip_forgery_protection

  def index
    submissions = Submission.recent.limit(1_000) # TODO: Paginate?
    if since = extract_since_from_params
      submissions = submissions.since(since)
    end
    @updated_at = submissions.first&.updated_at || Time.current
    @positively_infected_keys = InfectedKey.where(submission_id: submissions.positive)
    @negatively_infected_keys = InfectedKey.where(submission_id: submissions.negative)
  end

  def create
    keys_data = params.require(:keys)
    Submission.transaction do
      submission = Submission.create!
      keys_data.each do |key_data|
        submission.infected_keys.create!(data: key_data)
      end
    end
  end

  private

  def extract_since_from_params
    Time.zone.parse(params[:since]) if params[:since]
  rescue ArgumentError
    nil
  end
end
