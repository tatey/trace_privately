class Api::InfectedKeysController < Api::BaseController
  def index
    submissions = Submission.current.by_recently_changed_first.limit(1_000) # TODO: Paginate?
    if since = extract_since_from_params
      submissions = submissions.changed_since(since)
    end
    @updated_at = submissions.first&.updated_at || Time.current
    @positively_infected_keys = InfectedKey.where(submission_id: submissions.positive)
    @negatively_infected_keys = InfectedKey.where(submission_id: submissions.negative)
  end

  def create
    keys_data = params.require(:keys)
    Submission.transaction do
      @submission = Submission.create!
      keys_data.each do |key_data|
        @submission.infected_keys.create!(data: key_data[:d], rolling_start_number: key_data[:r], risk_level: key_data[:l])
      end
    end
  end

  private

  def extract_since_from_params
    Time.zone.parse(params[:since]) rescue nil
  end
end
