class LogsController < ApplicationController
  before_action :find_log, only: [:show, :update, :destroy]

  # GET /logs?sort_by=field&sort_direction=asc,desc&event_xid=x,y,z&event_type=a,b,c&username=d,e,f
  def index
    @logs = Log.where(filter_by_params)
                .order(sort_by_params)
                .each_slice(per_page).to_a[page_num]
    render json: @logs
  end

  # GET /logs/1
  def show
    render json: @log
  end

  # POST /logs
  def create
    @log = Log.new(log_params)
    if @log.save
      @log.update(data: params[:data])
      render json: @log, status: :created, location: @log
    else
      render json: @log.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /logs/1
  def update
    if @log.update(log_params)
      render json: @log
    else
      render json: @log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /logs/1
  def destroy
    @log.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def find_log
      @log = Log.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def log_params
      params.require(:log).permit(:event_type, :event_xid, :username)
    end

    def filter_by_params
      params.keys.inject({}) do |memo, param_name|
        next memo unless allowed_params_for_query.include?(param_name)
        memo[param_name] = params[param_name].split(',')
        if param_name == 'created_at'
          memo[param_name].map! { |v| DateTime.parse(v).beginning_of_day..DateTime.parse(v).end_of_day }
        end
        memo
      end
    end

    def sort_by_params
      return unless allowed_params_for_query.include?(params[:sort_by])
      sort_direction = %w(asc desc).include?(params[:sort_direction]) ? params[:sort_direction].to_sym : :asc
      { params[:sort_by].to_sym => sort_direction }
    end

    def allowed_params_for_query
      %w(username event_xid event_type created_at).freeze
    end

    def page_num
      params[:page_num] && params[:page_num].to_i != 0 ? params[:page_num].to_i : 1
    end

    def per_page
      params[:per_page] ? params[:per_page].to_i : 25
    end
end
