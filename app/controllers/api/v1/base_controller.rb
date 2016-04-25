module API
  module V1
    class BaseController < ApplicationController
      skip_before_filter :authenticate_user!

      def who_are_you
        render json: {
          role: 'webapp',
          title: 'Dalphi',
          description: 'The Ruby on Rails Dalphi webapp for user interaction and service intercommunication',
          capability: 'ner',
          url: root_url,
          version: '1.0'
        }
      end
    end
  end
end
