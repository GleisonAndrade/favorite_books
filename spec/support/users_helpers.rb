module UsersHelpers
  def sign_up_with(email, password, password_confirmation, name)
    visit new_user_registration_path
    
    fill_in 'Nome', with: name
    fill_in 'E-mail', with: email
    fill_in 'Senha', with: password
    fill_in 'Confirme sua senha', with: password_confirmation
    check 'Eu concordo com os Termos de Serviço e Política de Privacidade.'

    click_button 'Cadastrar'
  end
end
