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

RSpec.describe CmsVideosController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # CmsVideo. As you add validations to CmsVideo, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CmsVideosController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all cms_videos as @cms_videos" do
      cms_video = CmsVideo.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:cms_videos)).to eq([cms_video])
    end
  end

  describe "GET show" do
    it "assigns the requested cms_video as @cms_video" do
      cms_video = CmsVideo.create! valid_attributes
      get :show, {:id => cms_video.to_param}, valid_session
      expect(assigns(:cms_video)).to eq(cms_video)
    end
  end

  describe "GET new" do
    it "assigns a new cms_video as @cms_video" do
      get :new, {}, valid_session
      expect(assigns(:cms_video)).to be_a_new(CmsVideo)
    end
  end

  describe "GET edit" do
    it "assigns the requested cms_video as @cms_video" do
      cms_video = CmsVideo.create! valid_attributes
      get :edit, {:id => cms_video.to_param}, valid_session
      expect(assigns(:cms_video)).to eq(cms_video)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new CmsVideo" do
        expect {
          post :create, {:cms_video => valid_attributes}, valid_session
        }.to change(CmsVideo, :count).by(1)
      end

      it "assigns a newly created cms_video as @cms_video" do
        post :create, {:cms_video => valid_attributes}, valid_session
        expect(assigns(:cms_video)).to be_a(CmsVideo)
        expect(assigns(:cms_video)).to be_persisted
      end

      it "redirects to the created cms_video" do
        post :create, {:cms_video => valid_attributes}, valid_session
        expect(response).to redirect_to(CmsVideo.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved cms_video as @cms_video" do
        post :create, {:cms_video => invalid_attributes}, valid_session
        expect(assigns(:cms_video)).to be_a_new(CmsVideo)
      end

      it "re-renders the 'new' template" do
        post :create, {:cms_video => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested cms_video" do
        cms_video = CmsVideo.create! valid_attributes
        put :update, {:id => cms_video.to_param, :cms_video => new_attributes}, valid_session
        cms_video.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested cms_video as @cms_video" do
        cms_video = CmsVideo.create! valid_attributes
        put :update, {:id => cms_video.to_param, :cms_video => valid_attributes}, valid_session
        expect(assigns(:cms_video)).to eq(cms_video)
      end

      it "redirects to the cms_video" do
        cms_video = CmsVideo.create! valid_attributes
        put :update, {:id => cms_video.to_param, :cms_video => valid_attributes}, valid_session
        expect(response).to redirect_to(cms_video)
      end
    end

    describe "with invalid params" do
      it "assigns the cms_video as @cms_video" do
        cms_video = CmsVideo.create! valid_attributes
        put :update, {:id => cms_video.to_param, :cms_video => invalid_attributes}, valid_session
        expect(assigns(:cms_video)).to eq(cms_video)
      end

      it "re-renders the 'edit' template" do
        cms_video = CmsVideo.create! valid_attributes
        put :update, {:id => cms_video.to_param, :cms_video => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested cms_video" do
      cms_video = CmsVideo.create! valid_attributes
      expect {
        delete :destroy, {:id => cms_video.to_param}, valid_session
      }.to change(CmsVideo, :count).by(-1)
    end

    it "redirects to the cms_videos list" do
      cms_video = CmsVideo.create! valid_attributes
      delete :destroy, {:id => cms_video.to_param}, valid_session
      expect(response).to redirect_to(cms_videos_url)
    end
  end

end
