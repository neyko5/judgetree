class JudgesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_info
  def new
    @judge = Judge.new
  end
  def create
    @judge = Judge.new(judge_params)
    if @judge.save
      redirect_to :root, notice: 'Juiz criado'
    else
      flash[:error] = "Erro ao criar Juiz"
      render 'new'
    end
  end
  def index

  end
  def update
    @judge = Judge.find(params[:id])
    @judge.update_attributes(judge_params)
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
    params.require(:judge).permit(:name, :level, :parent_judge_id, :country,:country_tree,:dci)
  end

  def load_info
    @judges = Judge.asc(:name)
    @countries = IsoCountryCodes.for_select.sort_by{|c| c.first}
  end
end