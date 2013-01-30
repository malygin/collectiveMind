# encoding: utf-8
class TestsController < ApplicationController
  before_filter :authenticate
  # GET /tests
  # GET /tests.json

  def save_attempt
    test_questions = params[:test_questions]
    text_questions = params[:text_questions]
    #puts params[:text_questions]
    #puts params[:test_questions]
    @test = Test.find(params[:id])
    test_attempt = TestAttempt.create()
    test_attempt.user = current_user
    test_attempt.test = @test
    test_attempt.save!
    @test.test_questions.each  do |q|
      question_attempt =TestQuestionAttempt.create(:test_attempt => test_attempt, :test_question => q)
      if test_questions[q.id.to_s].nil? and text_questions[q.id.to_s]== ''
          flash[:error] = "Вы ответили не на Все вопросы, будьте внимательны"
          test_attempt.destroy
          return redirect_to @test
      else
        if  text_questions[q.id.to_s]!= ''
          question_attempt.answer = text_questions[q.id.to_s]
        else
          question_attempt.answer = test_questions[q.id.to_s]
        end
        #puts question_attempt.answer
        question_attempt.save!
      end
    end
    flash[:success] = "Спасибо за участие в опросе!"
    redirect_to user_path(current_user)
  end
  
  def index
    @tests = Test.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tests }
    end
  end

  # GET /tests/1
  # GET /tests/1.json
  def show
    #if current_user.test_attempts.empty?
      @test = Test.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @test }
      end
    #else
    #  redirect_to '/tests'
    #end
  end

  # GET /tests/new
  # GET /tests/new.json
  def new
    @test = Test.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @test }
    end
  end

  # GET /tests/1/edit
  def edit
    @test = Test.find(params[:id])
  end

  # POST /tests
  # POST /tests.json
  def create
    @test = Test.new(params[:test])

    respond_to do |format|
      if @test.save
        format.html { redirect_to @test, notice: 'Test was successfully created.' }
        format.json { render json: @test, status: :created, location: @test }
      else
        format.html { render action: "new" }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tests/1
  # PUT /tests/1.json
  def update
    @test = Test.find(params[:id])

    respond_to do |format|
      if @test.update_attributes(params[:test])
        format.html { redirect_to @test, notice: 'Test was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    @test = Test.find(params[:id])
    @test.destroy

    respond_to do |format|
      format.html { redirect_to tests_url }
      format.json { head :no_content }
    end
  end
end
