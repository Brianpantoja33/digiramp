require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe FrontEndContentsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # FrontEndContent. As you add validations to FrontEndContent, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FrontEndContentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all front_end_contents as @front_end_contents" do
      front_end_content = FrontEndContent.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:front_end_contents)).to eq([front_end_content])
    end
  end

  describe "GET show" do
    it "assigns the requested front_end_content as @front_end_content" do
      front_end_content = FrontEndContent.create! valid_attributes
      get :show, {:id => front_end_content.to_param}, valid_session
      expect(assigns(:front_end_content)).to eq(front_end_content)
    end
  end

  describe "GET new" do
    it "assigns a new front_end_content as @front_end_content" do
      get :new, {}, valid_session
      expect(assigns(:front_end_content)).to be_a_new(FrontEndContent)
    end
  end

  describe "GET edit" do
    it "assigns the requested front_end_content as @front_end_content" do
      front_end_content = FrontEndContent.create! valid_attributes
      get :edit, {:id => front_end_content.to_param}, valid_session
      expect(assigns(:front_end_content)).to eq(front_end_content)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new FrontEndContent" do
        expect {
          post :create, {:front_end_content => valid_attributes}, valid_session
        }.to change(FrontEndContent, :count).by(1)
      end

      it "assigns a newly created front_end_content as @front_end_content" do
        post :create, {:front_end_content => valid_attributes}, valid_session
        expect(assigns(:front_end_content)).to be_a(FrontEndContent)
        expect(assigns(:front_end_content)).to be_persisted
      end

      it "redirects to the created front_end_content" do
        post :create, {:front_end_content => valid_attributes}, valid_session
        expect(response).to redirect_to(FrontEndContent.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved front_end_content as @front_end_content" do
        post :create, {:front_end_content => invalid_attributes}, valid_session
        expect(assigns(:front_end_content)).to be_a_new(FrontEndContent)
      end

      it "re-renders the 'new' template" do
        post :create, {:front_end_content => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested front_end_content" do
        front_end_content = FrontEndContent.create! valid_attributes
        put :update, {:id => front_end_content.to_param, :front_end_content => new_attributes}, valid_session
        front_end_content.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested front_end_content as @front_end_content" do
        front_end_content = FrontEndContent.create! valid_attributes
        put :update, {:id => front_end_content.to_param, :front_end_content => valid_attributes}, valid_session
        expect(assigns(:front_end_content)).to eq(front_end_content)
      end

      it "redirects to the front_end_content" do
        front_end_content = FrontEndContent.create! valid_attributes
        put :update, {:id => front_end_content.to_param, :front_end_content => valid_attributes}, valid_session
        expect(response).to redirect_to(front_end_content)
      end
    end

    describe "with invalid params" do
      it "assigns the front_end_content as @front_end_content" do
        front_end_content = FrontEndContent.create! valid_attributes
        put :update, {:id => front_end_content.to_param, :front_end_content => invalid_attributes}, valid_session
        expect(assigns(:front_end_content)).to eq(front_end_content)
      end

      it "re-renders the 'edit' template" do
        front_end_content = FrontEndContent.create! valid_attributes
        put :update, {:id => front_end_content.to_param, :front_end_content => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested front_end_content" do
      front_end_content = FrontEndContent.create! valid_attributes
      expect {
        delete :destroy, {:id => front_end_content.to_param}, valid_session
      }.to change(FrontEndContent, :count).by(-1)
    end

    it "redirects to the front_end_contents list" do
      front_end_content = FrontEndContent.create! valid_attributes
      delete :destroy, {:id => front_end_content.to_param}, valid_session
      expect(response).to redirect_to(front_end_contents_url)
    end
  end

end