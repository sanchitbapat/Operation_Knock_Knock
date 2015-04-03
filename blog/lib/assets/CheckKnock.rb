module CheckKnock
  def knock_sequence (linkNo, userId)
	$user=Register.select('loginflag').where(:username => userId)
	user=$user.first
	loginflag=user[:loginflag]
	if loginflag != 5 then
		if loginflag != 0 then
			 if loginflag === 1
				$knock=Register.select('knock1').where(:username => userId)
				knock=$knock.first
				knockcode = knock[:knock1]
			elsif loginflag === 2
				$knock=Register.select('knock2').where(:username => userId) 
				knock=$knock.first
				knockcode = knock[:knock2]
			elsif loginflag === 3
				$knock=Register.select('knock3').where(:username => userId) 
				knock=$knock.first
				knockcode = knock[:knock3]
			elsif loginflag === 4
				$knock=Register.select('knock4').where(:username => userId) 
				knock = $knock.first
				knockcode = knock[:knock4]
			end
			if linkNo === knockcode
				loginflag++
			else
				loginflag = 1
			end
		end
	end
	Register.where(:username == userId).update_all(:loginflag => loginflag)
	session[:flag] => loginflag
  end
end
