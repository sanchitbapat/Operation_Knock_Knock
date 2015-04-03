class MessageController < ApplicationController
skip_before_filter :verify_authenticity_token
  def add
	knock_sequence 2, session[:userid]
  end

  def add_message
	if params[:title] === "" || params[:message] === ""
		redirect_to "/message/add", flash: {:r => "Title and/or message does not exist"}
	else
		if session[:flag] === 5
			@messages = Messages.new(:title => params[:title],:message => params[:message],:secret => 1)
		else
			@messages = Messages.new(:title => params[:title],:message => params[:message],:secret => 0)
		end
		@messages.save
		redirect_to "/message/list"
	end
  end

  def list
	knock_sequence 3, session[:userid]
  end
  def knock_sequence (linkNo, userId)
	$user=Register.select('loginflag').where(:username => userId)
	user=$user.first
	loginflag=user[:loginflag]
	if loginflag != 5 then
		if loginflag != 0 then
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
