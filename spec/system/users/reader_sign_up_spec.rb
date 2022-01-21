require "rails_helper"

RSpec.describe "Reader signs up", :type => :system, js: true do
  let(:user) { build(:reader) }

  scenario 'with valid email, password, password_confirmation and name' do
    sign_up_with user.email, user.password, user.password_confirmation, user.name

    expect(page).to have_content('Livros')
  end

  scenario 'with duplicated email' do
    expect(user.save).to eq(true)

    sign_up_with user.email, user.password, user.password_confirmation, user.name

    expect(page).to have_content('E-mail já está em uso')
  end

  scenario 'with blank email' do
    sign_up_with '', user.password, user.password_confirmation, user.name

    expect(page).to have_content('E-mail não pode ficar em branco')
  end

  scenario 'with in invalid email' do
    sign_up_with 'invalid_email', user.password, user.password_confirmation, user.name

    message = find("#user_email").native.attribute("validationMessage").gsub("\"", "").encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    expect(message).to eq "Inclua um @ no endereo de e-mail.invalid_email est com um @ faltando." # removing non UTF-8 characters

    # expect(page).to have_content('E-mail não é válido')
  end

  scenario 'with blank password' do
    sign_up_with user.email, '', '', 'Testing'

    expect(page).to have_content('Senha não pode ficar em branco')
  end

  scenario 'with short password' do
    sign_up_with user.email, '123456', '123456', 'Testing'

    expect(page).to have_content('Senha é muito curto (mínimo: 8 caracteres)')
  end

  scenario 'with blank password_confirmation' do
    sign_up_with user.email, '12345678', '', 'Testing'

    expect(page).to have_content('Confirme sua senha não é igual a Senha')
  end

  scenario 'with different password and password_confirmation' do
    sign_up_with user.email, '12345678', '87654321', 'Testing'

    expect(page).to have_content('Confirme sua senha não é igual a Senha')
  end

  scenario 'with blank name' do
    sign_up_with user.email, user.password, user.password_confirmation, ''

    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Nome é muito curto (mínimo: 3 caracteres)')
  end
end
