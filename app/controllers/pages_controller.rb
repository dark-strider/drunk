# encoding: utf-8
class PagesController < ApplicationController
  respond_to :html, :json

  def home
    @all = select_all_places
    respond_with(@all)
  end
end
