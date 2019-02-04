class Api::GamesController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :set_game, only: %i[show new_roll]

  # api :POST, 'http://localhost:3000/api/games
  def create
    @game = Game.create!

    render json: @game, status: 201
  end

  # api :GET, 'http://localhost:3000/api/games/:id'
  def show
    render json: @game
  end

  # api :POST, 'http://localhost:3000/api/games/:id/new_roll?pins=5'
  def new_roll
    errors = @game.new_roll params[:pins]
    if errors.empty?
      render json: @game, status: 201
    else
      render json: { errors: errors }, status: 422
    end
  end

  private

  def set_game
    @game = Game.find params[:id] || params[:game_id]
  end
end
