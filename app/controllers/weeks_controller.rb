class WeeksController < ApplicationController
  allow_unauthenticated_access only: %i[ index ]
  before_action :redirect_unless_authenticated, only: %i[ index ]

  def index
    @weeks = Week.all
  end

  def show
    @week = Week.find_by(id: params[:id])
  end

  def new
    @week = Week.new
    5.times { @week.words.build }
  end

  def create
    @week = Week.new(week_params)
    if @week.save
      redirect_to @week
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @week = Week.find_by(id: params[:id])
  end

  def update
    @week = Week.find_by(id: params[:id])
    if @week.update(week_params)
      redirect_to @week
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @week = Week.find_by(id: params[:id])
    @week.destroy!

    redirect_to root_path
  end

  private

  def week_params
    params.expect(week: {})
  end

  def redirect_unless_authenticated
    unless authenticated?
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end
end
