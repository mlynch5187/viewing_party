class User::PartiesController < ApplicationController

  def new
    @party = Party.new
  end

  def create
    user = current_user
    @party = user.parties.create(party_params)
    # day = @party.when[4..5]
    # month = @party.when[11]
    # year = @party.when[17..20]
    # @party.when = "#{day}/#{month}/#{year}"
    redirect_to '/user'
  end

  private

  def party_params
    params.require(:party).permit(:duration, 'when(3i)', 'when(2i)', 'when(1i)', :attendees)
  end
end
