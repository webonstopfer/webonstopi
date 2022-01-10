require 'json'
module Jekyll
  class StatsPageGenerator < Generator
    safe true

    def generate(site)
	  limiter = Jekyll.configuration({})['sitemap_limit']
      file = File.read('./data.json')
      pesrt = JSON.parse(file)
      as = []
      today=Time.now
      pesrt.each do |tag|
        unless tag[1]["time"].empty?
            datey = Time.parse(tag[1]["time"])
            
            if today >= datey
                as.append(tag[1])
            end
        end
      end
        (1..15).each do |di|
            if(File.file?('./data#{di.to_s}.json')) 
                file = File.read('./data#{di.to_s}.json')
                pesrt = JSON.parse(file)
                pesrt.each do |tag|
                    #print tag[1]["time"]
                    unless tag[1]["time"].empty?
                        datey = Time.parse(tag[1]["time"])
                        if today >= datey
                            as.append(tag[1])
                        end
                    end
                end
            end
        end
      site.pages << StatsPage.new(site, site.source, as)
    end
  end

  class StatsPage < Page
    def initialize(site, base, as)
      @site = site
      @base = base
      @dir  = "stats.json"
      @name = 'index.json'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'stats.json')
      self.data['tot'] = as.length
      self.data['first'] = as[0]["time"]
      self.data['last'] = as[-1]["time"]
	  self.data['permalink'] = "/stats.json"
    end
  end
end