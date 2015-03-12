class Api::V1::RandomController < Api::V1::ApiController
  def index
    render json:{"random_number"=>rand(100)}
  end

  def update
    raise Exception.new ("Missing seed") unless params[:seed]
    render json:{seed_taken:!!srand(params[:seed])}
  end
end
