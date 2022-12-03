# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# ENEMIES

Vamos criar um novo controller que vai servir como uma API, com 2 métodos principais: update e destroy
```
rails g controller enemies update destroy --no-helper --no-assets --no-controller-specs --no-view-specs --skip-routes
```

E depois geramos o model
```
rails g model enemy name:string power_base:integer power_step:integer level:integer kind:integer
```

Em seguida vamos atualizar o banco de dados
```
rails db:migrate
```

```

```

