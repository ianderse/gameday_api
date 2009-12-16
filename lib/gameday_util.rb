require 'open-uri'


class GamedayUtil
  
  # Converts a digit into a 2 character string, prepended with '0' if necessary
  def self.convert_digit_to_string(digit)
    if digit<10
      result = '0' + digit.to_s
    else
      result = digit.to_s
    end
    result
  end
  
  # Example gameday_gid = gid_2009_06_21_milmlb_detmlb_1
  def self.parse_gameday_id(gameday_gid)
    gameday_info = {}
    gameday_info["year"] = gameday_gid[4..7]
    gameday_info["month"] = gameday_gid[9..10]
    gameday_info["day"] = gameday_gid[12..13]
    gameday_info["visiting_team_abbrev"] = gameday_gid[15..17]
    gameday_info["home_team_abbrev"] = gameday_gid[22..24]
    gameday_info["game_number"] = gameday_gid[29..29]
    return gameday_info
  end


	# Read configuration from gameday_config.yml file to create
	# instance configuration variables.
	def self.read_config
    settings = YAML::load_file(File.expand_path(File.dirname(__FILE__) + "/gameday_config.yml"))
    #settings = YAML::load_file(File.expand_path('gameday_config.yml'))
    # Proxy Info
    @@proxy_addr = ''
    @@proxy_port = ''
    if settings['proxy']
      @@proxy_addr = settings['proxy']['host']
    end
    if settings['proxy']
      @@proxy_port = settings['proxy']['port']
    end
	end
  
  
  def self.get_connection(url)
    self.read_config
    begin
      if !@@proxy_addr.empty?
        connection = open(url, :proxy => "http://#{@@proxy_addr}:#{@@proxy_port}")
      else
        connection = open(url)
      end
      connection
    rescue
      puts 'Could not open connection'
    end
  end
  
  
  def self.net_http
    self.read_config
    if !@@proxy_addr.empty?
      return Net::HTTP::Proxy(@@proxy_addr, @@proxy_port)
    else
      return Net::HTTP
    end
  end
  
  
  def self.build_day_url(year, month, day)
    "#{Gameday::GD2_MLB_BASE}/mlb/year_#{year}/month_#{month}/day_#{day}/"
  end
  
  
  def self.save_file(filename, data)
    File.open(filename, 'w') {|f| f.write(data) }
  end
  
end