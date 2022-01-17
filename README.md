# Bem-vindo(a) ao My Favorite Books!

## Resumo

Esse é um sistema simples de gerenciamento de livros favoritos. Ele terá três perfis, o admin é o resposável por gerenciar tudo e cadastrar bibliotecários, já o bibliotecário é responsável por gerenciar os livros e por fim, o perfil leitor, pode pesquisar e seguir livros que considera interessante e salva-los como favorito.

## O que foi utilizado?

 1. Rails 6
 2. Yarn 1.22.4
 3. Node 16.22.4
 4. Bootstrap 5
 5. Devise
 6. Enumerize
 7. Simple Form
 8. Kaminari
 9. Pundit
 10. Has Scope
 11. RSpec
 12. Factory Bot
 13. Faker
 14. Simplecov
 

## Principais funcionalidades

 - [x] Cadastro de usuário (perfil padrão *read*);
 - [x] Login;
 - [ ] Listagem de usuários;
 - [ ] CRUD de usuários (apenas para *admin*);
 - [x] CRUD de livros (*admin* e *librarian*);
 - [ ] Seguir livro (*read*);
 - [x] Favoritar livro (*read*);
 - [ ] Registrar leitura (*read*);

## Pendências

 - [ ] Documentação geral do sistema (README);
 - [ ] Remoção de code smells;
 - [ ] Extração das regras de negocio utilizando u-case para criação de uma camada de casos de uso;
 - [ ] Aplicar corretamente a internacionalização na aplicação;
 - [ ] Implementação do CRUD de usuário;
 - [ ] Implementação da funcionalidade de seguir livros;
 - [ ] Implementação da funcionalidade de registrar leitura de livro seguido;
 - [ ] Adpatar as listagens de livros para as funcionalidades de seguir e registrar leitura de livros;
 - [ ] Atualização de testes com as novas funcionalidades;
 - [ ] Teste de integração;
 - [ ] Transformar o sistema em uma API;
 - [ ] Implementação do frontend com React ou Vue.js;

## Executando testes

    rspec --format documentation spec/
Será gerada uma pasta com a cobertura dos testes em *favorite_books/covarage/index.html*

## Executando o projeto

    bundle
    rails db:create
    rails db:migrate
    rails db:seed
    yarn install
    
Serão cadastrados alguns livros de exemplo e dois usuários com os perfis de Administrador e Bibliotecário. Credencias de acesso:

 - Administrador: admin@favoritebooks.com | senha: 12345678
 - Bibliotecário: librarian@favoriteboooks.com | senha: 12345678