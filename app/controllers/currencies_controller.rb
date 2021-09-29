# frozen_string_literal: true

class CurrenciesController < ApplicationController
  before_action :load_variables

  def task1
    @payloads = CurrencyService.metadata(permitted_params) if params[:ids].present?
  end

  def task2
    @payloads = CurrencyService.ticker(permitted_params) if params[:ids].present?
  end

  def task3
    @payloads = CurrencyService.sparkline(permitted_params) if params[:ids].present?
  end

  def task4
    @payloads = CurrencyService.rate_conversion(permitted_params) if params[:ids].present?
  end

  private

  def load_variables
    @payloads = []
    @ids = params[:ids]
    @start = params[:start] || Date.today
    @end = params[:end] || Date.today
    @convert = params[:convert]
    @interval = params[:interval]
    @status = params[:status]
  end

  def permitted_params
    parameters = params.permit(:ids, :interval, :convert, :start, :end, :status).to_h.symbolize_keys
    parameters[:ids] = params[:ids].to_s.upcase.split(',')
    parameters
  end
end
