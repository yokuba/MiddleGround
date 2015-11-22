class ActivitiesController < ApplicationController

  def search
    params = {
      term: 'movies',
      category_filter: 'movietheaters'
    }
    # render json: Yelp.client.search('Waterford, CT', params).businesses.map{|business| "#{business.name} #{business.location.display_address}"}.sample
    render json: Yelp.client.search("cll= 40.7, 74.0", params).businesses.map {|business| business.name }
  end

  def new
  end

  def create
    location = {latitude: params[:midlat], longitude: params[:midlong]}
    parameters = {
      term: params[:activity],
      radius_filter: 800
    }
   destination = Yelp.client.search_by_coordinates(location, parameters).businesses.sample
   title = destination.name
   address = destination.location.display_address.join(", ")

   @activity = Activity.new(location: address, title: title, creator_id: 1, friend_id: 2)
    if @activity.save!
    # byebug
      redirect_to activity_path(@activity.id)
    else
      flash[:errors] = "Something went wrong with your request. Please try again."
      redirect_to new_activity_path
    end
  end

  def show
    @activity = Activity.find(params[:id])
  end

  private

  def activity_params
    params.permit(:activity, :midlat, :midlong)
  end
end
