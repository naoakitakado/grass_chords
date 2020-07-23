require 'rails_helper'

RSpec.feature "Users", type: :feature do
  scenario "お試しログイン" do
    user = FactoryBot.create(:user, id: 0)
    other_user = FactoryBot.create(:user)

    visit root_path
    expect(page).to_not have_content "マイページ"
    expect(page).to_not have_content "データ作成"

    click_link "ログイン"
    click_link "お試しログイン"

    expect(page).to have_content "お試しログインに成功しました"
    expect(page).to have_content "マイページ"
    expect(page).to have_content "データ作成"

    click_link "マイページ"

    expect(page).to have_content user.name
    expect(page).to have_content user.email
    expect(page).to have_content user.place

    visit "#{other_user.id}"

    expect(page).to have_content other_user.name
    expect(page).to_not have_content other_user.email
    expect(page).to have_content other_user.place

    # ログアウトテスト
    click_link "ログアウト"
    expect(page).to have_content "ログアウトしました"

    expect(page).to_not have_content "マイページ"
    expect(page).to_not have_content "データ作成"
  end
  scenario "ユーザ登録" do
    user = FactoryBot.build(:user)
    visit root_path

    expect(page).to_not have_content "マイページ"
    expect(page).to_not have_content "データ作成"

    expect{
    click_link "ユーザ登録"

    fill_in "名前", with: user.name
    fill_in "主な活動地域", with: user.place
    fill_in "メール", with: user.email
    fill_in "パスワード", with: user.password
    fill_in "パスワード(確認)", with: user.password

    click_button "登録"

    expect(page).to have_current_path(root_path)
    expect(page).to have_content "ようこそ！ アカウントが登録されました"
    expect(page).to have_content "マイページ"
    expect(page).to have_content "データ作成"
  }.to change(User, :count).by(1)
  end

  scenario "ユーザー情報の編集・削除" do
    user = FactoryBot.create(:user, id: 1)

    visit root_path
    click_link "ログイン"

    fill_in "メール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    click_link "マイページ"
    click_link "Edit"

    fill_in "名前", with: "New Name"
    fill_in "現在のパスワード", with: user.password

    click_button "登録"

    expect(page).to have_current_path(root_path)
    expect(page).to have_content "アカウントが更新されました"

    click_link "マイページ"

    expect(page).to have_content "New Name"

    click_link "Edit"
    click_button "ユーザを削除する"

    expect(page).to have_content "ご利用ありがとうございました。アカウント情報が削除されました"
  end

  scenario "テストユーザーはユーザー情報を編集することも削除することもできない" do
    user = FactoryBot.create(:user, id: 0)

    visit root_path
    click_link "ログイン"
    click_link "お試しログイン"

    click_link "マイページ"
    click_link "Edit"

    expect {
    fill_in "名前", with: "New Name"
    fill_in "現在のパスワード", with: user.password

    click_button "登録"

    expect(page).to have_current_path(edit_user_registration_path)
    expect(page).to have_content "テストユーザーは編集できません"

    click_button "ユーザを削除する"

    expect(page).to have_current_path(edit_user_registration_path)
    expect(page).to have_content "テストユーザーは編集できません"
  }.to change(User, :count).by(0)
  end
end