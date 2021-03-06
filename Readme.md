Shipping Package Calculator
===========================
Ship Sticks' Ruby/Rails Developer Challenge
-------------------------------------------

### How to run the project?

This project was developed using Docker. So all you need is Docker and docker-compose installed.

Once those two features are installed you need to run these commands in the root folder of the project:

1. `docker network create ship_sticks_dev_challenge` to create the docker virtual network.
2. `docker-compose run api rails db:seed` to populate database with data from provided file `products.json`.
3. `docker-compose up` to start the project.

The application will be running in http://localhost:8080 and the API in http://localhost:3000 (check documentation for more details). If you need a different port you can change it in the file `docker-compose.yml` located in the root folder, in the line `38`.

### API Documentation

The documentation for the api is located in http://localhost:3000/api/doc/.

### Testing environment

This application was developed and tested in the following environment:

* macOS Catalina 10.15.2
* Docker 19.03.5, build 633a0ea
* docker-compose 1.24.1, build 4667896b

### Author

Efren Vila Alfonso (efrenvalfonso@gmail.com)
