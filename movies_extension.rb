class MoviesExtension < Radiant::Extension
  version "0.1"
  description "Allows you to embed movies from YouTube or other video streaming sites."
  url "http://github.com/nelstrom/radiant-movies-extension"
  
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources 'movies', {
        :collection => {
          :reorder => :get,
          :update_order => :post
        }
      }
    end
  end
  
  def activate
    admin.tabs.add "Movies", "/admin/movies", :after => "Layouts", :visibility => [:all]
    Page.send :include, MovieTags
    Radiant::AdminUI.class_eval do
      attr_accessor :movies
    end
    admin.movies = load_default_movies_regions
    MoviePage
  end
  
  def deactivate
    admin.tabs.remove "Movies"
  end
  
private

  # Defines this extension's default regions (so that we can incorporate shards
  # into its views).
  def load_default_movies_regions
    returning OpenStruct.new do |movies|
      movies.edit = Radiant::AdminUI::RegionSet.new do |edit|
        edit.main.concat %w{edit_header edit_form}
        edit.form.concat %w{edit_title edit_content edit_timestamp}
        edit.content_bottom.concat %w{edit_filter}
        edit.form_bottom.concat %w{edit_buttons}
      end
      movies.new = movies.edit
    end
  end
end
