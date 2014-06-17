class Catalog::DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  include Transloadit::Rails::ParamsDecoder
  include AccountsHelper
  include CatalogsHelper

  
  before_filter :access_account
  before_filter :access_catalog

  # GET /documents
  # GET /documents.json
  def index

    # ids of Legal Documents from the catalog
    document_ids = CatalogItem.where(  category: 'File',
                                       catalog_itemable_type: 'Document',
                                       catalog_id:             @catalog.id,
                                      ).pluck(:catalog_itemable_id)
    # find Documents
    documents         = Document.where(id: document_ids)                                
    # filete by search query                                  
    @documents = Document.catalogs_search( documents , params[:query]).order('title asc').page(params[:page]).per(24) 

  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    
  end

  # GET /documents/new
  def new

  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    forbidden unless current_account_user.create_legal_document
    
    documents = TransloaditDocumentsParser.parse params[:transloadit], @account.id
    if documents
      documents.each do |document|
        CatalogItem.create( catalog_id:             @catalog.id,
                            catalog_itemable_type: 'Document',
                            catalog_itemable_id:    document.id,
                            category:             'File'
                          )
        DocumentExtractTextWorker.perform_async( document.id )
      end
    end
    redirect_to catalog_account_catalog_documents_path(@account, @catalog)
    
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    @document.update_attributes(document_params)
    redirect_to catalog_account_catalog_document_path(@account, @catalog, @document)
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    forbidden unless current_account_user.delete_legal_document
    document = Document.cached_find(params[:id])
    document.destroy!
    redirect_to catalog_account_catalog_documents_path(@account, @catalog)

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit!
    end
end