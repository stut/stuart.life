module Jekyll
  class ArchiveIndex < Page
    def initialize(site, base, dir, period, posts)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'archive.html')
      self.data['period'] = period
      self.data['period_posts'] = posts
      if period["month"]
      	month_name = Date::MONTHNAMES[period['month']]
        self.data['title'] = "#{month_name} #{period['year']}"
      else
        self.data['title'] = "#{period['year']}"
      end
    end
  end
  class ArchiveGenerator < Generator
    safe true
    def generate(site)
      if site.layouts.key? 'archive'
        site.posts.docs.group_by{ |c| {'month' => c.date.month, 'year' => c.date.year} }.each do |period, posts|
          archive_dir = File.join(period['year'].to_s(), '%02d' % period['month'].to_s())
          write_archive_index(site, archive_dir, period, posts)
        end

        site.posts.docs.group_by{ |c| {'year' => c.date.year} }.each do |period, posts|
          archive_dir = File.join(period['year'].to_s())
          write_archive_index(site, archive_dir, period, posts)
        end        
      end
    end
    def write_archive_index(site, dir, period, posts)
      index = ArchiveIndex.new(site, site.source, dir, period, posts)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end
  end
end
