class UserController < ApplicationController
skip_before_filter :verify_authenticity_token
  def login
	knock_sequence 1, session[:userid]
  end

  def userlogin
	if Register.exists?(username: params[:username])
		$user=Register.select('password').where(:username => params[:username]).limit(1)
		users = $user.first
		if users[:password] === Digest::MD5.hexdigest(params[:password])
			session[:userid] = params[:username]
			Register.where(:username == session[:userId]).update_all(:loginflag => 1)
			redirect_to "/"
		else
			redirect_to "/user/login",  flash: {:r => "Wrong Password"}
		end
	else
		redirect_to "/user/login",  flash: {:r => "No such user"}
	end
  end

  def register
	knock_sequence 0, session[:userid]
  end

  def logout
	Register.where(:username == session[:userId]).update_all(:loginflag => 0)
	session[:userid] = nil
  end

  def create
	if params[:username] === "" || params[:password] === ""
		redirect_to "/user/register", flash: {:r => "Username and/or password does not exist"}
	else
		if params[:password_confirm] === params[:password]
			user_hash=Digest::MD5.hexdigest(params[:username])
			knock1 = (user_hash[0].to_i(16)) % 4 
			knock2 = (user_hash[1].to_i(16)) % 4 
			knock3 = (user_hash[2].to_i(16)) % 4 
			knock4 = (user_hash[3].to_i(16)) % 4 
			@register = Register.new(:username => params[:username],:password => Digest::MD5.hexdigest(params[:password]),:loginflag => 0,:knock1 => knock1,:knock2 => knock2,:knock3 => knock3,:knock4 => knock4)
			unless Register.exists?(username: params[:username])
				@register.save
				redirect_to "/"
			else
				redirect_to "/user/register", flash: {:r => "User already exists"}
			end
		else
			redirect_to "/user/register", flash: {:r => "Password do no match"}
		end
	end
  end
  def knock_sequence (linkNo, userId)
	$user=Register.select('loginflag').where(:username => userId)
	user=$user.first
	loginflag=user[:loginflag]
	if loginflag != 5 then
		if loginflag != 0
			$knock=Register.select('knock1').where(:username => userId)
			knock1=$knock.first
			$knock=Register.select('knock2').where(:username => userId)
			knock2=$knock.first
			$knock=Register.select('knock3').where(:username => userId)
			knock3=$knock.first
			$knock=Register.select('knock4').where(:username => userId)
			knock4=$knock.first
			if loginflag === 1
				knockcode = knock1[:knock1]
			elsif loginflag === 2
				knockcode = knock2[:knock2]
			elsif loginflag === 3 
				knockcode = knock3[:knock3]
			elsif loginflag === 4
				knockcode = knock4[:knock4]
			end
			if linkNo === knockcode
				loginflag = loginflag + 1
			elsif linkNo === knock2[:knock2] && knock2[:knock2] === knock1[:knock1] && loginflag === 3 
				loginflag = loginflag
			elsif loginflag === 4 && knock1[:knock1] === knock2[:knock2] && knock1[:knock1] === knock3[:knock3] && linkNo === knock3[:knock3]
				loginflag = loginflag
			else
				$knock=Register.select('knock1').where(:username => userId)
				knock=$knock.first
				knockcode = knock[:knock1]
				if linkNo === knockcode
					loginflag = 2
				else
					loginflag = 1
				end
			end
		end
	end
	Register.where(:username == userId).update_all(:loginflag => loginflag)
	session[:flag] = loginflag
  end
end
