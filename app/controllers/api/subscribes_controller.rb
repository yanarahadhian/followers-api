class Api::SubscribesController < ApplicationController

  api :post, '/subscribes', 'Subscribe an email'
  param :requestor, String, required: true, desc: 'Subscriber email'
  param :target, String, required: true, desc: 'Subscribe email'

  def create
    subscribe = Subscribe.store(params[:requestor], params[:target])
    render json: subscribe
  end

  api :post, '/subscribes/block', 'Block subscriber'
  param :requestor, String, required: true, desc: 'Subscribe email'
  param :target, String, required: true, desc: 'Subscribe email'

  def block
    block = Subscribe.block(params[:requestor], params[:target])
    render json: block
  end

  api :post, '/subscribes/unblock', 'Unblock subscriber'
  param :requestor, String, required: true, desc: 'Subscribe email'
  param :target, String, required: true, desc: 'Subscribe email'

  def unblock
    block = Subscribe.unblock(params[:requestor], params[:target])
    render json: block
  end

  api :post, '/subscribes/send_email', 'Send updates to subscribers'
  param :sender, String, required: true, desc: 'Sender email'
  param :text, String, required: true, desc: 'Content'

  def send_email
    send_email = Subscribe.send_email(params[:sender], params[:text])
    render json: send_email
  end

end
