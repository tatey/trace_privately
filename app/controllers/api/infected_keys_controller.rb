class Api::InfectedKeysController < Api::BaseController
  def index
    submissions = Submission.changed_since(extract_since_from_params_or_default).by_recently_changed_first.limit(1_000) # TODO: Paginate?
    @updated_at = submissions.first&.updated_at || Time.current
    @positively_infected_keys = InfectedKey.where(submission_id: submissions.positive)
    @negatively_infected_keys = InfectedKey.where(submission_id: submissions.negative)
  end

  def create
    keys_data = params.require(:keys)
    Submission.transaction do
      @submission = Submission.create!
      keys_data.each do |key_data|
        @submission.infected_keys.create!(data: key_data[:d], rolling_start_number: key_data[:r])
      end
    end
  end

  private

  def extract_since_from_params_or_default
    default = 30.days.ago
    return default unless params[:since]

    since = Time.zone.parse(params[:since]) rescue default
    if since >= default
      since
    else
      default
    end
  end
end
