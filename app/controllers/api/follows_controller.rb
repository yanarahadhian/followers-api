class Api::FollowsController < ApplicationController

  api :get, '/follows', 'Followers List'
  param :email, String, required: true, desc: 'Selected all followers email'
  def index
    follows = Follow.list(params[:email])
    render json: follows
  end
  
  api :post, '/follows', 'Following'
  param :followers, Array, required: true, desc: 'It should minimum have 2 users'
  def create
    follow = Follow.connect(params[:followers])
    render json:follow
  end
  
  api :post, '/follows/common', 'Common Follower'
  param :followers, Array, required: true, desc: 'It should minimum have 2 users. To get mutual followers between those emails'
  def common
    common_friends = Follow.common(params[:followers])
    render json: common_friends
  end

  api :put, '/follows/block', 'Block follower'
  param :emails, Array, required: true, desc: 'It should minimum have 2 users. as requestor who will block target'
  def block
    block = Follow.block(params[:emails])
    render json: block
  end

  api :put, '/follows/unblock', 'Unblock follower'
  param :emails, Array, required: true, desc: 'It should minimum have 2 users. as requestor who will unblock target'
  def unblock
    block = Follow.unblock(params[:emails])
    render json: block
  end

  api :put, '/follows/subscribe', 'Subscribe'
  param :emails, Array, required: true, desc: 'It should minimum have 2 users. as requestor who will subscribe target'
  def subscribe
    block = Follow.subscribe(params[:emails])
    render json: block
  end

  api :put, '/follows/unsubscribe', 'Unsubscribe'
  param :emails, Array, required: true, desc: 'It should minimum have 2 users. as requestor who will unsubscribe target'
  def unsubscribe
    block = Follow.unsubscribe(params[:emails])
    render json: block
  end

  api :post, '/subscribes/send_email', 'Send updates to subscribers'
  param :sender, String, required: true, desc: 'Sender email'
  param :text, String, required: true, desc: 'Content'
  def send_email
    send_email = Follow.send_email(params[:sender], params[:text])
    render json: send_email
  end
end
