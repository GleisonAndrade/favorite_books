# Bem-vindo(a) ao My Favorite Books!

<h4 align="center"> 🚧 My Favorite Books 🚀 Em construção... 🚧 </h4>

### Pré-requisitos 

Antes de começar, você vai precisar ter instalado em sua máquina as seguintes ferramentas: [Git](https://git-scm.com), [Node.js](https://nodejs.org/en/), [Yarn](https://yarnpkg.com/), [Ruby On Rails](https://guides.rubyonrails.org/getting_started.html) e [PostgreSQL](https://www.postgresql.org/) . Além disto é bom ter um editor para trabalhar com o código como [VSCode](https://code.visualstudio.com/).

## Resumo

Esse é um sistema simples de gerenciamento de livros favoritos. Ele terá três perfis, o admin é o resposável por gerenciar tudo e cadastrar bibliotecários, já o bibliotecário é responsável por gerenciar os livros e por fim, o perfil leitor, pode pesquisar e seguir livros que considera interessante e salva-los como favorito.

## O que foi utilizado até o momento?

 1. Rails 6
 2. Yarn 1.22.4
 3. Node 16.22.4
 4. PostgreSQL
 5. Bootstrap 5
 6. Devise
 7. Enumerize
 8. Simple Form
 9. Kaminari
 10. Pundit
 11. Has Scope
 12. RSpec
 13. Factory Bot
 14. Faker
 15. Simplecov
 
## Principais funcionalidades

 - [x] Cadastro de usuário (perfil padrão *read*);
 - [x] Login;
 - [ ] CRUD de usuários (apenas para *admin*);
 - [x] CRUD de livros (*admin* e *librarian*);
 - [x] Favoritar livro (*read*);
 - [ ] Seguir livro (*read*);
 - [ ] Registrar leitura (*read*);

## Pendências

 - [x] Documentação geral do sistema (README);
 - [ ] Bugfix tab de favoritos e todos os livros;
 - [ ] Remoção de code smells;
 - [ ] Extração das regras de negocio utilizando u-case para criação de uma camada de casos de uso (Clean Architecture);
 - [ ] Aplicar corretamente a internacionalização na aplicação;
 - [ ] Implementação do CRUD de usuário;
 - [ ] Implementação da funcionalidade de seguir livros;
 - [ ] Implementação da funcionalidade de registrar leitura de livro seguido;
 - [ ] Adpatar as listagens de livros para as funcionalidades de seguir e registrar leitura de livros;
 - [ ] Atualização de testes com as novas funcionalidades;
 - [ ] Teste de integração;
 - [ ] Transformar o sistema em uma API;
 - [ ] Implementação do frontend com React ou Vue.js;

## Instalando o projeto

Altere as credenciais do banco em `config/database.yml`, em desenvolvimento e test já estão definidas as seguintes configurações:

 - Host: localhost
 - Porta: 5432
 - Usuário: `DATABASE_USER`
 - Senha: `DATABASE_PASSWORD`
 - Databases: *favorite_books_development* e *favorite_books_test*

Para executar o projeto localmente, execute os seguintes comandos:

    git clone https://github.com/GleisonAndrade/favorite_books.git
    cd favorite_books/
    bundle
    yarn install
    rails db:setup    

Serão cadastrados alguns livros de exemplo e dois usuários com os perfis de Administrador e Bibliotecário. Credencias de acesso:

 - Administrador: admin@favoritebooks.com | senha: 12345678
 - Bibliotecário: librarian@favoriteboooks.com | senha: 12345678

## Executando o projeto
Depois de instalar o projeto, execute os seguintes comandos:

    cd favorite_books/
    rails s

Abra seu navegador e acesse http://localhost:3000/

A seguinte página será exibida:

![Tela de Login da aplicação](https://photos.app.goo.gl/k222GsYp3ZUekM5RA)

Acesse o sistema com um dos usuários abaixo ou se preferir acesse a opção cadastrar e faça o cadastro de um usuário leitor.
 - Administrador: admin@favoritebooks.com | senha: 12345678
 - Bibliotecário: librarian@favoriteboooks.com | senha: 12345678
 
 Para ter acesso a funcionalidade de favoritar é necessário possuir um perfil de leitor. Realize o cadastro como mostra a figura abaixo. Não é necessário confirmar o e-mail, após o registro o sistema já realize o login com a conta cadastrada.
 
 ![Tela de Cadastro de usuário](https://photos.app.goo.gl/UwPaPYKkY7R9aU5L9)

Por fim, a tela inicial do sistema é uma listagem com todos os livros cadastrados no sistema. Ele também possuí uma opção para listar apenas aqueles livros favoritados pelo usuário que está disponível apenas para usuários leitores.

![Listagem de livros](https://photos.app.goo.gl/L9chbo6Y9MHjAiGs5)


## Executando testes

    rspec --format documentation spec/
Será gerada uma pasta com a cobertura dos testes em *favorite_books/covarage/index.html*

## Arquitetura

> Aqui será feita apenas uma discussão simples que ainda está em contrução. Nãoestou defindo qual a melhor arquitetura para se utilizar. Esse é apenas um projeto para estudos e a arquitetura deve ser definida baseada no problema que você pretende resolver.

### Model-View-Controller (MVC)

O sistema é um CRUD de livros com apenas uma funcionalidade extra que é a de favoritar livro. Por essa característica a arquitetura mais adequada para o sistema é o MVC. Sistemas com essa características tiram o máximo do que o Ruby On Rails pode oferecer, garantindo uma implementação em um curto perído de tempo e completa. Um problema comum ao se utilizar essa arquitetura é uma quebra as responsabilidades, onde começam a ser adicionadas responsabilidades que não são de acordo com as definições da camada. Por exemplo, as classes de modelo convertendo dados para formatos usados na Visão, como xml, json e outros.

### Active Record

Este padrão dearquitetura é utilizado pelo rails, ele possui um objeto que mantém os dados e comportamentos, tais dados normlamente são persistidos em um banco de dados, isso faz com que ele tenha a responsabilidade de acessar os dados. Apesar de estar de acordo com os principios da Orientação a Objetos (OO) e facilitar a codificação de interações com o banco, esse modelo viola os principios do *Single-responsibility principle* (SOLID).

O uso de **Active Record** com MVC no RoR é muito útil para se implementar sistemas simples, mas para aplicações melhores o uso dessas arquiteturas geram problemas a longo prazo. Eles iram dificultar a manutenção do sistema por causarem o uso incorreto de algumas camadas, apesar disso ser algo mais relacionado a quem desenvolve o sistema.

Por conta disso, foi decidido o seguinte para essa aplicação. Inicialmente seria utilizado MVC + *Active Record* e depois ele seria refatorado para outras arquiteturas para fins didádicos, uma vez que o uso desses padrões é o suficiente para atender as necessidades do sistema.

### Domain Driven Design (DDD)

Existem alguns materias na internet que propõe o uso de DDD em aplicações RoR e apresentam soluções para quebra dos padrões utilizados no rails para se adptar ao DDD. O objetivo do DDD é estruturar e modelar a implementação do código com foco no domínio do negócio. As camadas físicas utilizadas podem variar de nomenclaturas, mas tradicionalmente conhecidas por camadas de apresentação, lógica de negócio e dados. Essas camadas fisícas podem possuir várias camadas lógicas. Esssa arquitetura exibe uma quantidade maior de camandas em relação a Clean Architecture que será vsta no próximo tópico. Po conta dessa complexidade optou-se por inicialmente não seguir essa arquitetura.

### Clean Architecture

![Clear Architecture](https://blog.cleancoder.com/uncle-bob/images/2012-08-13-the-clean-architecture/CleanArchitecture.jpg)
[Fonte: Blog Clean Code](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

Clean Architecture aborda vários conceitos importantes para implementar software e camadas organizadas e reutilizáveis, como as camadas mais próximas do núcleo definirem as interfaces para persistência e a implementação concreta destas interfaces estar no círculo mais externo fazendo parte de “Frameworks e Drivers”, o que é a inversão de dependências na prática, podendo inclusive também fazer uso de injeção de dependência.

Na comunidade existem muitas propostas para o uso de DDD e Clear Architecture. Uma solução que me chamou a atenção foi o [u-case](https://serradura.github.io/pt-BR/blog/introducao-gem-u-case/), que propõe a criação de uma camada de regras de negocio que seja fácil de entender, manter/modificar e testar. Seu desempenho foi comprado com de outras soluções semelhantes em rails como *interector*, *trailblazer-operation*, *dry-transaction* e *dry-monads*.

### Referências

 - [https://www.sitepoint.com/ddd-for-rails-developers-part-1-layered-architecture/](https://www.sitepoint.com/ddd-for-rails-developers-part-1-layered-architecture/)
 - [https://pt.slideshare.net/MarceloBrandoTheodor/ddd-e-rails](https://pt.slideshare.net/MarceloBrandoTheodor/ddd-e-rails)
 - [https://speakerdeck.com/danielbdias/comecando-a-modelar-sua-aplicacao-ruby-com-ddd](https://speakerdeck.com/danielbdias/comecando-a-modelar-sua-aplicacao-ruby-com-ddd)
 - [https://pt.slideshare.net/MarceloBrandoTheodor/ddd-e-rails](https://pt.slideshare.net/MarceloBrandoTheodor/ddd-e-rails)
 - [https://guia.dev/pt/pillars/software-architecture/layers.html](https://guia.dev/pt/pillars/software-architecture/layers.html)
 - [https://serradura.github.io/pt-BR/blog/introducao-gem-u-case/](https://serradura.github.io/pt-BR/blog/introducao-gem-u-case/)
 - [https://guia.dev/pt/pillars/software-architecture/layers-and-architecture-patterns.html](https://guia.dev/pt/pillars/software-architecture/layers-and-architecture-patterns.html)
 - [https://medium.com/luizalabs/descomplicando-a-clean-architecture-cf4dfc4a1ac6](https://medium.com/luizalabs/descomplicando-a-clean-architecture-cf4dfc4a1ac6)
 - [https://medium.com/magnetis-backstage/clean-architecture-on-rails-e5e82e8cd326](https://medium.com/magnetis-backstage/clean-architecture-on-rails-e5e82e8cd326)
 - [https://fbzga.medium.com/clean-architecture-in-ruby-v2-d2293c78d4a6](https://fbzga.medium.com/clean-architecture-in-ruby-v2-d2293c78d4a6)
 - [https://medium.com/todocartoes/clean-architecture-caso-de-estudo-em-uma-aplica%C3%A7%C3%A3o-rails-3daf0c9f206d](https://medium.com/todocartoes/clean-architecture-caso-de-estudo-em-uma-aplica%C3%A7%C3%A3o-rails-3daf0c9f206d)