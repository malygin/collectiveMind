class Discontent::PostAdvicesController < ApplicationController
  before_action :set_discontent_post_advice, only: [:show, :edit, :update, :destroy]

  # GET /discontent/post_advices/1
  def show
  end

  # GET /discontent/post_advices/new
  def new
    @discontent_post_advice = Discontent::PostAdvice.new
  end

  # GET /discontent/post_advices/1/edit
  def edit
  end

  # POST /discontent/post_advices
  def create
    @discontent_post_advice = Discontent::PostAdvice.new(discontent_post_advice_params)

    if @discontent_post_advice.save
      redirect_to @discontent_post_advice, notice: 'Post advice was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /discontent/post_advices/1
  def update
    if @discontent_post_advice.update(discontent_post_advice_params)
      redirect_to @discontent_post_advice, notice: 'Post advice was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /discontent/post_advices/1
  def destroy
    @discontent_post_advice.destroy
    redirect_to discontent_post_advices_url, notice: 'Post advice was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_discontent_post_advice
    @discontent_post_advice = Discontent::PostAdvice.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def discontent_post_advice_params
    params.require(:discontent_post_advice).permit(:content, :approved, :user_id, :discontent_post_id)
  end
end
