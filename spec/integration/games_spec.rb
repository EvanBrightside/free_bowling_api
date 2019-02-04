require 'swagger_helper'
require 'rails_helper'

describe 'Games API' do

  path '/api/games' do

    post 'Create new game' do
      tags 'Games'
      consumes 'application/json', 'application/xml'

      response '201', 'game created' do
        let(:game) {}
        run_test!
      end
    end
  end

  path '/api/games/{id}' do

    get 'Retrieves a game' do
      tags 'Games'
      consumes 'application/json', 'application/xml'
      parameter name: :id, in: :path, type: :string

      response '200', 'game found' do
        schema type: :object,
          properties: {
            id: { type: :integer }
          },
          required: ['id']

        let(:id) { Game.create.id }
        run_test!
      end

      response '404', 'game not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end

  path '/api/games/{id}/new_roll' do

    post 'Add number of pins for a game' do
      tags 'Games'
      consumes 'application/json', 'application/xml'
      parameter name: :pins, in: :body, schema: {
        type: :object,
        properties: {
          pins: { type: :integer }
        },
        required: ['pins']
      }
      parameter name: :id, in: :path, type: :string

      response '201', 'new roll created' do
        schema type: :object,
          properties: {
            id: { type: :integer }
          },
          required: ['id']

        let(:id) { Game.create.id }

        let(:new_roll) { { pins: 8 } }
        run_test!
      end
    end
  end
end
