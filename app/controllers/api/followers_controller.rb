class Api::FollowersController < ApplicationController

  api :get, '/followers', 'Followers List'
  param :email, String, required: true, desc: 'Selected user email'

  def index
    followers = Follower.list(params[:email])
    render json: followers
  end

  api :post, '/followers', 'Following friends'
  param :followers, Array, required: true, desc: 'It must be not more than or less than 2 emails'
  
  def create
    follow = Follower.follow(params[:followers])
    render json:follow
  end

  api :post, '/followers/common', 'Common friends'
  param :followers, Array, required: true, desc: 'It must be not more than or less than 2 emails. To get mutual friends between those emails'
  
  def common
    common_friends = Follower.common(params[:followers])
    render json: common_friends
  end

end
