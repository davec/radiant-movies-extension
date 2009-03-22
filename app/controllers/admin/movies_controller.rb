class Admin::MoviesController < Admin::ResourceController
  model_class Movie
  
  
  def index
    self.models = model_class.find(:all, :order => "position ASC")
  end

  def reorder
    @movies = Movie.find(:all, :order => 'position ASC')
  end

  def update_order
    if request.post? && params.key?(:sort_order)
      list = params[:sort_order].split(',')
      list.size.times do |i|
        audio = Movie.find(list[i])
        audio.position = i + 1
        audio.save
      end
      redirect_to admin_movies_path
    end
  end
  
end
