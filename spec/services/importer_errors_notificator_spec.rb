require 'rails_helper'

describe ImporterErrorsNotificator do
  describe '.prices_errors' do
    it 'works' do
      ImporterErrorsNotificator.prices_errors('error_line')
    end
  end
end
