class Session
	def login(email, name)
		user = User.find_by(:email => email)
		return 'User is not exists!' if user.nil?
		return 'Name not exists!' if !(user.name == name)
		return 'OK'
	end
end