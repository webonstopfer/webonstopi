require 'json'
module Jekyll
  class SmapmainPageGenerator < Generator
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
      dr = ["de"]
      maps = (as.length/limiter).floor
      (0..maps).each do |tag|
	    dnmo = tag+1
		cru = tag*limiter 
        arre = as[cru,cru+limiter]
        dr.append(arre[-1]["time"])
      end
      site.pages << SmapmainPage.new(site, site.source, as,dr)
    end
  end

  class SmapmainPage < Page
    def initialize(site, base, as, dr)
      @site = site
      @base = base
      @dir  = "sitemap.xml"
      @name = 'index.xml'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'sitemap.xml')
      self.data['tot'] = as.length
      self.data['totd'] = dr
	  self.data['permalink'] = "/sitemap_index.xml"
    end
  end
end