class InfectedKeysController < ApplicationController
  skip_forgery_protection

  def index
    @keys = InfectedKey.recent.limit(1_000) # TODO: Paginate
    if since = extract_since_from_params
      @keys = @keys.since(since)
    end
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
