use toph-arena

accountsN = db.accounts.count()
db.accounts.find().forEach(function(user, i) {
	user.emails = [user.emails[0]]
	user.emails[0].address = user._id.valueOf()+'@toph.s.furqan.io'
	user.emails[0].address_norm = user._id.valueOf()+'@toph.s.furqan.io'
	user.emails[0].token = new ObjectId().valueOf()
	user.password = new BinData(0, '')
	user.salt = new BinData(0, '')
	user.registration_ip = []
	user.login_ips = []
	print(db.accounts.update({ _id: user._id }, user))
	if(i > 0 && i%1000 === 0 || i === accountsN-1) {
		print('Anonymized '+(i+1)+' accounts')
	}
})
