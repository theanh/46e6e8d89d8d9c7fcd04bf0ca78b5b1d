require 'rails_helper'

RSpec.describe Session do	
  context 'when input email not valid' do
  	byebug
  	it { is_expected.to eq 101 }
  end
end
