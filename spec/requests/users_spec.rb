require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    subject {get(users_path)}
    # before { create_list(:user, 3)}
    before { create_list(:user, user_count)}
    let(:user_count){3}
    it "ユーザーの一覧を取得できる" do

      subject

      # binding.pry
      res = JSON.parse(response.body)
      expect(res.length).to eq user_count
      expect(res[0].keys).to eq ["account", "name", "email"]
      # expect(response.status).to eq 200
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /users/:id" do
    subject { get(user_path(user_id)) }

    context "指定してidのユーザーが存在するとき" do
      # let(user_id) do
      #   # 存在するidって何？
      #   user = create(:user)
      #   user.id
      # end

      let(:user_id){ user.id }
      let(:user){ create(:user)}

      it "そのユーザーがレコードを取得できる" do
        subject

        binding.pry
        res = JSON.parse(response.body)
        expect(res["name"]).to eq user.name
        expect(res["account"]).to eq user.account
        expect(res["email"]).to eq user.email

        expect(response).to have_http_status(200)
      end
    end

    context "指定したidのユーザーが存在しないとき" do
      let(:user_id){ 100000 }

      it "ユーザーが見つからい" do
        # binding.pry
        # subject
        expect{subject}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /users" do
    subject { post(users_path, params: params)}
    context "適切なパラメータを送信したとき" do
      let(:params) {{ user: attributes_for(:user)}}
      it "ユーザーのレコードを作成できる" do
        expect{ subject }.to change{ User.count}.by(1)

        res = JSON.parse(response.body)
        expect(res["name"]).to eq params[:user][:name]
        expect(res["account"]).to eq params[:user][:account]
        expect(res["email"]).to eq params[:user][:email]

        expect(response).to have_http_status(200)
        binding.pry
      end
    end

    context "不適切なパラメータを送信したとき" do
      let(:params) { attributes_for(:user) }

      it "エラーする" do
        # binding.pry
        # subject
        expect{ subject }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  describe "PATCH /users/:id" do
    subject{ patch(user_path(user_id), params: params) }

    let(:params) do
      # { user: { name: "fff", create_at: 1.day.ago } }
      { user: { name: Faker::Name.name, create_at: 1.day.ago } }
    end
    let(:user_id){ user.id}
    let(:user){ create(:user)}

    fit "任意のユーザーレコードを更新できる" do
      # expect{ subject }.to change {User.find(user_id).name}.from(user.name).to(params[:user][:name]) &
      #                       not_change { User.find(user_id).account } &
      #                       not_change { User.find(user_id).email } &
      #                       not_change { User.find(user_id).created_at }

      expect{ subject }.to change { user.reload.name }.from(user.name).to(params[:user][:name]) &
                            not_change { user.reload.account } &
                            not_change { user.reload.email } &
                            not_change { user.reload.created_at }

    end
  end

  describe "DELETE /users/:id" do
    it "任意のユーザーレコードを削除できる" do
    end
  end
end
