require 'rails_helper'
require 'support/factory_girl'
require 'database_cleaner'

def authenticate(url)
  page.driver.basic_authorize(Figaro.env.administrator_login, Figaro.env.administrator_password) if page.driver.respond_to?(:basic_authorize)
  visit url
end
DatabaseCleaner.strategy = :truncation

describe 'Students managment' do
  context 'CRUD functionality' do


    it 'Add new user to the list' do

      FactoryGirl.create(:user)

      authenticate(root_path)


      expect(page).to have_content ('testname')
      expect(page).to have_content ('testsecondname')

      page.save_screenshot('create.png')
    end

    it 'Editing user' do

       FactoryGirl.create(:user)
       authenticate(root_path)

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

     it 'Destroy of the user' do

       FactoryGirl.create(:user)
       authenticate(root_path)
       within(find(:xpath,"//tr[td//text()[contains(., 'testname')]]")) do
         click_link 'Destroy'
       end

       expect(page).not_to have_content ('testname')
       expect(page).not_to have_content ('testsecondname')
       page.save_screenshot('destroy.png')
     end
  end

  context 'Validation for CRUD' do
    it 'Fail to create user with empty field' do
      authenticate(new_user_path)

      fill_in 'user_firstName', with: ''
      fill_in 'user_secondName', with: ''
      click_button 'Create User'

      expect(page).to have_content ("can't be blank")
      page.save_screenshot('create_empty.png')
    end


    it 'Fail to create duplicate user' do
      authenticate(new_user_path)

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

  context 'Pairs generator' do
    it 'Checks whether pairs generator correctly works' do

      (1..6).each do |user|
        FactoryGirl.create(:user, firstName: "#{user}", secondName: "#{user}")
      end
      authenticate(generate_pairs_users_path)
      result = 0
      (1..100).each do
        user = all("tr td")[0].text
        if user == "1 1"
          result +=1
        end
        click_on('Generate')
      end
      result = (result/100.0).round(2)

      if result > 0.2 #|| result < 0.16
        raise Exception.new('Your pairs generator is very very BAAAAAD!')
      end
    end
   end
end
