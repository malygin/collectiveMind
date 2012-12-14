# encoding: utf-8
class QuestionsController < ApplicationController
  
  def plus
    @question = Question.find(params[:id])
    if @question.users.include?(current_user)
      flash[:success] = "Вы уже голосовали за этот вопрос"
      redirect_to questions_path
    else
      @question.users << current_user
      @question.raiting+=1
      if @question.save
        flash[:success] = "Голос За то, что вопрос полезен"
        redirect_to questions_path
      end
    end
  end 


  def minus
    @question = Question.find(params[:id])
    if @question.users.include?(current_user)
      flash[:success] = "Вы уже голосовали за этот вопрос"
      redirect_to questions_path
    else
      @question.users << current_user
      @question.raiting-=1
      if @question.save
        flash[:success] = "Голос За то, что вопрос бесполезен"
        redirect_to questions_path
      end
    end
  end

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.paginate(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(params[:question])
    #puts params[:question]
    @question.user = current_user
    @question.raiting = 0

    respond_to do |format|
      if @question.save
        current_user.journals.build(:type_event=>'question_save', :body=>@question.id).save!

        format.html { redirect_to questions_path, notice: 'Вопрос задан, ждем ответа!' }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
end
