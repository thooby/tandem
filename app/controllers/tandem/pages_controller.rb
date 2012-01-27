module Tandem
  class PagesController < ApplicationController
    load_and_authorize_resource :except => :home, :find_by => :slug
    layout :pages_layout

    # GET /pages/home
    # GET /pages.home.json
    def home
      @page = Page.where(is_default: true).first || Page.first || Page.new
      authorize!('index', Page)
      respond_to do |format|
        format.html { render (@page.template.present? ? @page.template : 'show'), notice: @page.new_record? ? 'No Pages Found.' : '' }
        format.json { render json: @page }
      end
    end

    # GET /pages
    # GET /pages.json
    def index
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @pages }
      end
    end
  
    # GET /pages/1
    # GET /pages/1.json
    def show
      respond_to do |format|
        format.html { render @page.template if @page.template.present? }
        format.json { render json: @page }
      end
    end
  
    # GET /pages/new
    # GET /pages/new.json
    def new
      @page.parent ||= Page.where(id: params['parent_id']).first
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @page }
      end
    end
  
    # GET /pages/1/edit
    def edit
    end

    # POST /pages
    # POST /pages.json
    def create
      respond_to do |format|
        if @page.save
          format.html { render action: "success", notice: 'Page was successfully created.' }
          format.json { render json: @page, status: :created, location: @page }
        else
          format.html { render action: "new" }
          format.json { render json: @page.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /pages/1
    # PUT /pages/1.json
    def update
      respond_to do |format|
        if @page.update_attributes(params[:page])
          format.html { render action: "success", notice: 'Page was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @page.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /pages/1
    # DELETE /pages/1.json
    def destroy
      @page.destroy

      respond_to do |format|
        format.html { redirect_to pages_url }
        format.json { head :ok }
      end
    end

    private

    def pages_layout
      case params[:action]
        when 'show', 'home'
          @page.layout.present? ? @page.layout : 'application'
        when 'new', 'create', 'edit', 'update'
          'tandem/popup'
        else
          'application'
      end
    end
  end
end
