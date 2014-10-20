class JudgesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_info
  def new
    if(session.has_key?(:last_country))
      @last_country=session[:last_country];
      @last_tree=session[:last_tree];
    end

    @judge = Judge.new
  end
  def create
    @judge = Judge.new(judge_params)
    if @judge.save
      redirect_to :root, notice: I18n.t("judge_created")
    else
      flash[:error] = I18n.t("judge_error")
      render 'new'
    end
  end
  def index

  end
  def update
    @judge = Judge.find(params[:id])
    @judge.update_attributes(judge_params)
    session[:last_country]=judge_params[:country];
    session[:last_tree]=judge_params[:country_tree];
    redirect_to judges_path
  end

  def destroy
    @judge = Judge.find(params[:id])
    @judge.destroy
    redirect_to judges_path
  end

  def edit
    @judge = Judge.find(params[:id])
  end

  private

  def judge_params
    params.require(:judge).permit(:name, :level, :parent_judge_id, :country,:country_tree,:dci,:l2_cert,:l3_cert)
  end

  def load_info
    @judges = Judge.asc(:name)
    @countries = IsoCountryCodes.for_select.sort_by{|c| c.first}
  end
end