require 'open-uri'
require 'json'
=begin
BT Search Framwork
Supports :
  - www.sobt5.org
  - so.loldytt.com
  - Other web site which can group different page from HTTP_GET method.
    You can add configs for them.
Usage :
  * use           - Use a config files.Default config files is so.loldytt.com.ini
  * getallconfigs - Get all available configs
  * set           - Set settings in current configs and save it to file
  * next          - Next page
  * pre           - Pre page
Settings :
  * engine       - Engine to use
  * default_page - Default page from default_page's page start
  * encoding     - Page encoding
  * matches      - Rule for engine use like
                   so.loldytt.com(engine)/q/...(title)_rel_123(page).html convert to
                   #{engine}/q/#{title}_rel_#{page}.html
  * reg_url_list - Big range for url list
  * reg_url      - Regexp to get url
  * reg_items    - Detials to match
    & name       - Key for detials. special key list will create a hash like {:file,:detail}
    & reg        - Regexp for match the key information
=end
class BTSearcher
  def load_config config # load config from config files given
    @config = JSON.parse(File.read(config, encoding: 'utf-8'))
    @engine = @config["engine"] # engine used
    @matches = @config["matches"].gsub /\#{engine}/, @engine
  end

  def initialize config = "./config/so.loldytt.com.ini" # default is so.loldytt.com.ini
    @rel = [] # result sets
    @title = "" # search titles
    @state = true # progam run state
    @page = 1 # current page number
    @options = [ # functions
      'exit',
      'help',
      'search',
      'next',
      'pre',
      'get',
      'getsize',
      'set',
      'getallconfigs',
      'use'
    ]
    @confs = [] # available configs sets
    load_config config
  end
  
  def shell # shell
    self.help # print help information
    while @state
      print "shell:>"
      r = gets.strip
      r = r.split ' '
      if @options.include? r[0]
        self.send r[0], *r[1, r.size]
      else
        puts "Error"
      end
    end
  end
  
  def getallconfigs
    dic = Dir.new "./config"
    index = 0
    dic.each do |file|
      next if file =~ /^\.$|^\.\.$/ # pass file . ..
      puts "#{index} - #{file}"
      index += 1
      @confs << file
    end
  end
  
  def use index # use configs
    if @confs.size == 0
      puts "please get all configs first"
    else
      index = index.to_i
      load_config "./config/" + @confs[index]
    end
  end
  
  def set *args # set settings
    sets = [ # All settings can be setted
      'default_page',
      'encoding',
      'engine',
      'matches',
      'reg_url_list',
      'reg_url'
    ]
    index = sets.index args[0]
    if index.nil?
      puts "Error"
      return
    end
    @config[args[0]] = args[1]
    self.send "write_sets_to_file"
  end
  
  def getsize # return number of results
    if @rel.size == 0
      @rel = JSON.parse(File.read('result.txt', encoding: 'gbk'))
    end
    puts @rel.size
  end
  
  def get *args # get information from result
    if args.size < 2
      p args.size
      puts "Error"
      return
    end
    if @rel.size == 0
      @rel = JSON.parse(File.read('result.txt', encoding: 'gbk'))
    end
    index = args[0].to_i
    index = index % @rel.size if index > @rel.size
    r = @rel[index - 1][args[1]]
    r = @rel[index - 1][args[1].to_sym] if r.nil?
    if Array === r
      r.each do |i|
        i.each do |k,v|
          puts "#{k}:#{v}"
        end
      end
    else
      puts r
    end
  end
  
  def exit *args
    @state = false
  end
  
  def help *args
    puts "exit           -- exit program"
    puts "search content -- search torrent about content"
    puts "next           -- next page"
    puts "pre            -- pre page"
    puts "get index [op] -- get op-information from index'th result"
    puts "          [op] -- title, torrent, size, list"
    puts "getsize        -- get results size"
    puts "set options v  -- set options with v"
    puts "getallconfigs  -- get all available configs"
    puts "use config     -- use index'th config file"
    puts "help           -- this help"
  end
  
  def next *args
    @page += 1
    if @title != ""
      self.send "search", @title
    else
      puts "please search first"
    end
  end
  
  def pre *args
    @page -= 1
    if @page < 1
      @page = 1
    end
    if @title != ""
      self.send "search", @title
    else
      puts "please search first"
    end
  end

  def search title
    title = title.encode "utf-8"
    if title != @title
      @title = title
      @page = @config["default_page"]
    end
    # create target url
    matcher = @matches.gsub /\#{page}/, @page.to_s
    matcher = matcher.gsub /\#{title}/, title
    uri = open URI.encode matcher
    html = uri.read
    reg = Regexp.new @config["reg_url_list"] # match urls by gradually narrow the range
    html = html.force_encoding @config["encoding"]
    task = []
    html.scan reg do |re|
      re[0] = re[0].gsub(/<em>/, '')
      re[0] = re[0].gsub(/<\/em>/, '')
      re[0] =~ Regexp.new(@config["reg_url"])
      if $1.start_with? "http://"
        task << $1
      else
        task << @engine + $1
      end
    end
    @rel.clear
    task.each do |t| # get item detail information
      @rel << (getHash t)
      puts "#{t[29,10]} ..."
    end
    write_to_file # write to file
    @rel
  end
  private
  def getHash url
    uri = open URI.encode url
    html = uri.read
    html = html.force_encoding @config["encoding"]
    hash = {}
    @config["reg_items"].each do |regs| # match all regexp given.
      if regs["name"] == "list"
        hash[:list] = []
        html.scan Regexp.new(regs["reg"]) do |re|
          hash[:list] << {:file => re[0].encode(@config["encoding"]), :detail => re[1]}
        end
      else
        html =~ Regexp.new(regs["reg"])
        hash[regs["name"].to_sym] = $1
      end
    end
    hash
  end
  
  def write_to_file
    File.write('result.txt',JSON.pretty_generate(@rel, indent: '    '),encoding: 'gbk')
  end
  
  def write_sets_to_file
    File.write('./config/' + @config["engine"][7,@config["engine"].size] + '.ini',JSON.pretty_generate(@config, indent: '    '),encoding: 'utf-8')
  end
end

BTSearcher.new.shell