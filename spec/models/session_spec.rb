require 'rails_helper'

RSpec.describe Session do  
	
  # let!(:suite) { @user = create(:user) }
  let!(:session) { Session.new }  
  context 'when input email' do
  	# it 'is user'do
  	# 	expect(user.class.name).to eq("User")
  	# end
  	context 'in valid' do
  		it 'email is not exists!' do
				expect(session.login('theanh.hu11y@gmail.com', 'TheAnh')).to eq('User is not exists!')
			end
			it 'name is not exists!' do
				expect(session.login('theanh.huy@gmail.com', 'TheAnh')).to eq('Name not exists!')
			end
  	end		

  	it 'success'do  		
  		expect(session.login('theanh.huy@gmail.com', 'The Anh')).to eq('OK')
  	end
  end
end
