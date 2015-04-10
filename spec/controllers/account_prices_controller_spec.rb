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

RSpec.describe AccountPricesController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # AccountPrice. As you add validations to AccountPrice, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AccountPricesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all account_prices as @account_prices" do
      account_price = AccountPrice.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:account_prices)).to eq([account_price])
    end
  end

  describe "GET show" do
    it "assigns the requested account_price as @account_price" do
      account_price = AccountPrice.create! valid_attributes
      get :show, {:id => account_price.to_param}, valid_session
      expect(assigns(:account_price)).to eq(account_price)
    end
  end

  describe "GET new" do
    it "assigns a new account_price as @account_price" do
      get :new, {}, valid_session
      expect(assigns(:account_price)).to be_a_new(AccountPrice)
    end
  end

  describe "GET edit" do
    it "assigns the requested account_price as @account_price" do
      account_price = AccountPrice.create! valid_attributes
      get :edit, {:id => account_price.to_param}, valid_session
      expect(assigns(:account_price)).to eq(account_price)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new AccountPrice" do
        expect {
          post :create, {:account_price => valid_attributes}, valid_session
        }.to change(AccountPrice, :count).by(1)
      end

      it "assigns a newly created account_price as @account_price" do
        post :create, {:account_price => valid_attributes}, valid_session
        expect(assigns(:account_price)).to be_a(AccountPrice)
        expect(assigns(:account_price)).to be_persisted
      end

      it "redirects to the created account_price" do
        post :create, {:account_price => valid_attributes}, valid_session
        expect(response).to redirect_to(AccountPrice.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved account_price as @account_price" do
        post :create, {:account_price => invalid_attributes}, valid_session
        expect(assigns(:account_price)).to be_a_new(AccountPrice)
      end

      it "re-renders the 'new' template" do
        post :create, {:account_price => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested account_price" do
        account_price = AccountPrice.create! valid_attributes
        put :update, {:id => account_price.to_param, :account_price => new_attributes}, valid_session
        account_price.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested account_price as @account_price" do
        account_price = AccountPrice.create! valid_attributes
        put :update, {:id => account_price.to_param, :account_price => valid_attributes}, valid_session
        expect(assigns(:account_price)).to eq(account_price)
      end

      it "redirects to the account_price" do
        account_price = AccountPrice.create! valid_attributes
        put :update, {:id => account_price.to_param, :account_price => valid_attributes}, valid_session
        expect(response).to redirect_to(account_price)
      end
    end

    describe "with invalid params" do
      it "assigns the account_price as @account_price" do
        account_price = AccountPrice.create! valid_attributes
        put :update, {:id => account_price.to_param, :account_price => invalid_attributes}, valid_session
        expect(assigns(:account_price)).to eq(account_price)
      end

      it "re-renders the 'edit' template" do
        account_price = AccountPrice.create! valid_attributes
        put :update, {:id => account_price.to_param, :account_price => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested account_price" do
      account_price = AccountPrice.create! valid_attributes
      expect {
        delete :destroy, {:id => account_price.to_param}, valid_session
      }.to change(AccountPrice, :count).by(-1)
    end

    it "redirects to the account_prices list" do
      account_price = AccountPrice.create! valid_attributes
      delete :destroy, {:id => account_price.to_param}, valid_session
      expect(response).to redirect_to(account_prices_url)
    end
  end

end
