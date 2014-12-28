class ApplicationController < ActionController::Base
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception

	before_filter :prepare_for_mobile

	private

	MOBILE_BROWSERS = ["android", "ipod", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]

	def mobile_device?
		##if session[:mobile_param]
		##	session[:mobile_param] = 1
		##elsif mobile_browser?
		##	session[:mobile_param] = 1
		##else
		##	request.user_agent =~ /Mobile|webOS/
		##end
		
		return true if session[:mobile_param] == 1 || mobile_browser?
		return false
	end
	helper_method :mobile_device?

	def mobile_browser?
		agent = request.headers["HTTP_USER_AGENT"].downcase

		MOBILE_BROWSERS.each do |browser|
			return true if agent.match(browser)
		end

		return false
	end

	#def prepare_for_mobile
	#	session[:mobile_param] = mobile_device? 1 : 0 
	#	#request.format = :mobile if mobile_device?
	#end
end
