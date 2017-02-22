require 'rails_helper'
require 'shared_context/elasticsearch_setup'
require 'shared_context/record_finder'

RSpec.describe BatchesController, type: :controller do
  let(:batch) { double( Batch ) }

  describe 'GET new' do
    before {get :new}

    it 'renders the new template' do
      expect( response ).to render_template(:new)
    end

    it 'assigns a new Batch object' do
      expect( assigns[:batch] ).to be_a_new(Batch)
    end

    it 'assigns an array of products to the @products' do
      expect( assigns[:products] ).not_to be_nil
    end
  end

  describe 'POST create' do
    context "when the data isn't enough to create a record" do
      before(:example){
        post :create, params: { batch: {barcode: 1234567890123, cost: ""} }
      }

      it 'renders the new template again' do
        expect( response ).to render_template(:new)
      end

      it 'has entries in the errors hash' do
        expect( assigns[:batch].errors.messages ).not_to be_empty
      end
    end

    context "when the form data is enough to create the record" do
      # let(:stub_save) { allow( batch ).to receive(:save).and_return(true) }
      let(:send_form) { post :create, params: {batch: attributes_for(:batch) } }

      before {
        allow( Batch ).to receive(:new).and_return( batch )
        allow( batch ).to receive(:save).and_return true
        send_form
      }

      it 'calls save on the object' do
        expect( batch ).to have_received(:save)
      end

      it "redirects to the index page" do
        expect( response ).to redirect_to(batches_path)
      end

      it 'has a success entry on the flash hash' do
        expect( flash[:notice] ).not_to be_empty
      end
    end
  end

  describe 'GET index' do
    let(:stub_es_query) { allow( Batch ).to receive(:es_query).and_return([build(:batch)]) }

    context 'when no aditional params are informed' do
      before(:example) {
        stub_es_query
        get :index
      }

      it 'has a 200 status code' do
        expect( response ).to have_http_status(200)
      end

      it 'renders the index template' do
        expect( response ).to render_template(:index)
      end

      it 'assigns the @products variable' do
        expect( assigns[:batches] ).not_to be_nil
      end
    end

    context 'when the request is a xhr' do
      before {
        stub_es_query
        get :index, xhr: true
      }

      it 'renders the update_table_and_pagination' do
        expect( response ).
          to render_template('shared/update_table_and_pagination')
      end
    end

    context 'when the request has params' do
      query = 'Brontek'
      page = "2"

      it 'calls es_query with the params' do
        expect( Batch ).to receive(:es_query).with(query, page)
        get :index, params: { page: page, query: query }
      end

    end
  end

  describe 'GET edit' do
    include_context 'record finder' do
      let(:send_request){
        get :edit, params: { id: 5, batch: attributes_for(:batch) }
      }
      let(:record_dbl){ batch }
    end
  end

  describe 'POST update' do
    include_context 'record finder' do
      let(:send_request){
        patch :update, params: { id: 5, batch: attributes_for(:batch) }
      }
      let(:record_dbl){
        allow( batch ).to receive(:update).and_return true
        batch
      }
    end

    context "when the data isn't enough to update a record" do
      before(:example){
        allow( Batch ).to receive(:find).with(any_args).and_return(batch)
        allow( batch ).to receive_messages(update: false, batch_params: [])
        post :update, params: {id: 1 ,batch: attributes_for(:batch) }
      }

      it 'renders the edit template again' do
        expect( response ).to render_template(:edit)
      end
    end

    context "when the form data is enough to update the record" do
      # let(:stub_save) { allow( batch ).to receive(:save).and_return(true) }
      let(:send_form) {
        put :update, params: {id: 1 ,batch: attributes_for(:batch) }
      }

      before {
        allow( Batch ).to receive(:find).and_return( batch )
        allow( batch ).to receive(:update).and_return true
        send_form
      }

      it 'calls update on the object' do
        expect( batch ).to have_received(:update)
      end

      it "redirects to the index page" do
        expect( response ).to redirect_to(batches_path)
      end

      it 'has a success entry on the flash hash' do
        expect( flash[:notice] ).not_to be_empty
      end
    end
  end

  describe 'DELETE destroy' do
    let(:send_request){ delete :destroy, params: { id: 5 } }
    let(:record_dbl){
      allow( batch ).to receive(:destroy).and_return true
      batch
    }
    let(:stub_find) { allow( Batch  ).to receive(:find).and_return( record_dbl ) }

    include_context 'record finder'

    context 'when a record is found' do
      before { stub_find && send_request }

      it 'calls destroy on the record' do
        expect( record_dbl ).to have_received(:destroy)
      end

      it 'redirects to the index view' do
        expect( response ).to redirect_to(batches_url)
      end

      it 'has a message in the flash hash' do
        expect( flash[:notice] ).not_to be_empty
      end
    end
  end
end
