class Api::V1::VersionController < ApplicationController
  def index
    render json: {
        title: "Ship Sticks' Shipping Package Calculator",
        version: 1,
        author: 'Efren Vila Alfonso (efrenvalfonso@gmail.com)'
    }
  end
end