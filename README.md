# 📝 Simple Blog API 🖥️

### Versions

[![Generic badge](https://img.shields.io/badge/Ruby->= v2.5.1-blue?&style=plastic)](https://www.ruby-lang.org/en/downloads/releases/)&nbsp;&nbsp;[![Generic badge](https://img.shields.io/badge/Rails->= v5.2.1.1-blue?&style=plastic)](https://rubygems.org/gems/rails/versions)

### Gems

[![Generic badge](https://img.shields.io/badge/💎-active__model__serializer-important?&style=plastic)](https://rubygems.org/gems/active_model_serializers)&nbsp;&nbsp;[![Generic badge](https://img.shields.io/badge/💎-letter__opener-important?&style=plastic)](https://rubygems.org/gems/letter_opener/versions/1.4.1?locale=es)&nbsp;&nbsp; -&nbsp;&nbsp; [![Generic badge](https://img.shields.io/badge/🧪-rspec--rails-important?&style=plastic)](https://rubygems.org/gems/rspec-rails)&nbsp;&nbsp;[![Generic badge](https://img.shields.io/badge/🧪-factory__bot__rails-important?&style=plastic)](https://rubygems.org/gems/factory_bot_rails)&nbsp;&nbsp;[![Generic badge](https://img.shields.io/badge/🧪-shoulda--matchers-important?&style=plastic)](https://matchers.shoulda.io/)&nbsp;&nbsp;[![Generic badge](https://img.shields.io/badge/🧪-faker-important?&style=plastic)](https://rubygems.org/gems/faker)&nbsp;&nbsp;[![Generic badge](https://img.shields.io/badge/🧪-database__cleaner-important?&style=plastic)](https://rubygems.org/gems/database_cleaner)

## 📷 Screenshots 🎥

![image](https://user-images.githubusercontent.com/13999498/204707292-0cfdbb51-449b-4853-a9c7-3bafeeae8188.png)

## 📝 Description 📖

Simple API Blog in which we can create, read and update post. Here are a more detailed features:

### Post

- Create Post - we need a user token to create it.
- Read - only published post.
  - Read - draft post - need a token.
- Update - need a token to update

## User

- No user CRUD by now, but there seed data to create user and posts.

## ⏯️ Run locally 💻️

- Clone the repo
- Run `bundle install`
- Run `rails db:setup`
- Run `rails s`

And that's it, you can start using the API on `localhost:3000`

## 👨‍💻 Technologies 💻️

- Rails API project
- Postman(to test the endpoints)
- Rspec test Suit

## 🤓 What I learned? 🧠

- How API works on Rails
- How to use Postman
- How to serializer a JSON response
- How to manage the N+1 query problem on Rails
- How to Rspec test suit works
- How to integrate another gems with Rspec
- Basic usage of mailers (ActionMailer)
- Basic usage of jobs (ActiveJob)
- Basic cache management
- How AuthTokens works
