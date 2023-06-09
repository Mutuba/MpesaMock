# README

- MpesaMock app is a more of a clone and trimmed down version to the existing Mpesa app by Safaricom.

- The application offers to main functions: 1. Ability to top up own account and ability to send money to registered accounts

- This application uses Ruby version 3.1.o To install, use rvm or rbenv.

- RVM

`rvm install 3.1.0`

`rvm use 3.1.0`

- Rbenv

`rbenv install 3.1.0`

- Bundler provides a consistent environment for Ruby projects by tracking and installing
  the exact gems and versions that are needed. I recommend bundler version 2.0.2. To install:

- You need Rails. The rails version being used is rails version 7

- To install:

`gem install rails -v '~> 7'`

\*To get up and running with the project locally, follow the following steps.

- Clone the app

- With SSH

`git@github.com:Mutuba/MpesaMock.git`

- With HTTPS

`https://github.com/Mutuba/MpesaMock.git`

- Move into the directory and install all the requirements.

- cd mpesa-mock-app

- run `bundle install` to install application packages

- Run `rails db:create` to create a database for the application

- Run `rails db:migrate` to run database migrations and create database tables

- The application can be run by running the below command:-

`rails s` or `rails server`

- The application uses redis and sidekiq for backgroun
  d job processing
- Run this commands in separate terminals to start redis and sidekiq

`redis-server` to start redis server and `bundle exec sidekiq` to start sidekiq server

Screenshots:

Registration page

<img width="1424" alt="Screenshot 2023-05-23 at 09 27 15" src="https://github.com/Mutuba/MpesaMock/assets/39365725/b57e3319-9381-496c-beee-74966fb55556">


Home page

<img width="717" alt="Screenshot 2023-05-23 at 09 25 16" src="https://github.com/Mutuba/MpesaMock/assets/39365725/743a02b0-d9b9-42e8-97ff-9fad4e529731">


Top account page

<img width="1434" alt="Screenshot 2023-05-23 at 09 20 04" src="https://github.com/Mutuba/MpesaMock/assets/39365725/a7e0a417-361f-4df3-8b6d-38f75d6e828d">


Send money contact search page

<img width="1430" alt="Screenshot 2023-05-23 at 09 24 07" src="https://github.com/Mutuba/MpesaMock/assets/39365725/a35aff95-8046-416d-a744-b44dc17de58c">


All transactions page

<img width="1423" alt="Screenshot 2023-05-23 at 09 21 05" src="https://github.com/Mutuba/MpesaMock/assets/39365725/f87fd3ec-b953-45df-93e1-e4011b54caca">

In app notifications

<img width="564" alt="Screenshot 2023-05-23 at 09 22 12" src="https://github.com/Mutuba/MpesaMock/assets/39365725/9642202f-8541-4cc0-9d16-ff4caa93d6d7">


