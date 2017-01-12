require 'rails_helper'
require 'support/factory_girl'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
feature 'Create user' do
 scenario 'add new user to the list' do
   FactoryGirl.create(:user)

   visit root_path
   expect(page).to have_content ('testname')
   expect(page).to have_content ('testsecondname')

   page.save_screenshot('create.png')
 end
end

feature 'Modify user' do
  scenario 'See modified user' do
    FactoryGirl.create(:user)

    visit root_path
    within(find(:xpath,"//tr[td//text()[contains(., 'testname')]]")) do
      click_link 'Edit'
    end

    fill_in 'user_firstName', with: 'Modify'
    fill_in 'user_secondName', with: 'ModifyModify'
    click_button 'Update User'

    expect(page).to have_content ('Modify')
    expect(page).to have_content ('ModifyModify')
    page.save_screenshot('modify.png')
  end
end

feature 'Destroy user' do
  scenario 'See user was destroyed' do
    FactoryGirl.create(:user)
    visit root_path

    within(find(:xpath,"//tr[td//text()[contains(., 'testname')]]")) do
      click_link 'Destroy'
    end

    expect(page).not_to have_content ('testname')
    expect(page).not_to have_content ('testsecondname')
    page.save_screenshot('destroy.png')
  end
end

feature "Can't create user with empty fields" do
  scenario 'Fail to create user with empty field' do
    visit new_user_path

    fill_in 'user_firstName', with: ''
    fill_in 'user_secondName', with: ''
    click_button 'Create User'

    expect(page).to have_content ("can't be blank")
    page.save_screenshot('create_empty.png')
  end
end

feature "Can't create duplicate user" do
  scenario 'Fail to create duplicate user' do
  visit new_user_path

  fill_in 'user_firstName', with: 'duplicateName'
  fill_in 'user_secondName', with: 'duplicateSecondName'
  click_button 'Create User'

  expect(page).to have_content ('duplicateName')
  expect(page).to have_content ('duplicateSecondName')

    visit new_user_path

    fill_in 'user_firstName', with: 'duplicateName'
    fill_in 'user_secondName', with: 'duplicateSecondName'
    click_button 'Create User'

    expect(page).to have_content ('has already been taken')
    page.save_screenshot('duplicate.png')
  end
end

feature "Random pair generator works property" do
  scenario 'Random pair generator working' do
    (1..6).each do |user|
      FactoryGirl.create(:user, firstName: "#{user}", secondName: "#{user}")
    end
    result = 0
    visit generate_pairs_users_path
    (1..100).each do
      user = all("tr td")[0].text
      if user == "1 1"
        result +=1
      end
      visit generate_pairs_users_path
    end
    result = (100/result).round
    #lambda { whatever.merge }.should raise_error
    # visit generate_pairs_users_path
    # page.save_screenshot('1.png')
    # page.find_by_id('qwe').click
    # page.save_screenshot('2.png')
  end
end
