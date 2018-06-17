# Technical Assignment
This is a Rails API project.
# Requirements:
1. Populate the data into new created SQL DB (pick up either PostgreSQL or MySQL). Use the schema of your preferred design for your DB.
2. Create API that will do the following:
    * CRUD operations.
    * Use pagination for Retrieving smaller chunks of data
    * Search endpoint to search the DB with the corresponding fields
        * Type (String)
        * price (Range)
        * sq_feet (Range)
3. Create tests (Unit Tests and functional tests) for the API using testing framework of your choice.



# Prerequisites
### Ruby on Rails version
This project has been developed in **Ruby 2.5.1** and **Rails 5.2.0**. Make sure your system has the same versions.
### Database
Used **PostgreSQL** Database.
# Project setup
### Get the application up and running
Use below command to clone the project from the github.
```
$ git clone git@github.com:nitin-srivastava/real_estate_api.git
```
Go to cloned project directory and run the `bundle install`.
```
$ cd real_estate_api
$ bundle install
```
After successfully bundle the project, run the below command to create the database and tables.
```
$ rake db:create
$ rake db:migrate
```
Run the below rake tasks to populate the data in to the created DB.
```
$ rake db:seed  #Create user for authentication
$ rake apartment:import #Populate the data from attached CSV file.
```
Start the rails server.
```
$ rails s
```
All done. Project is up and running
### How to run the test suite
I'm using `rspec` testing framework for all unit and functional testing. Run the below command for application test setup.
```
$ bundle exec rake db:migrate db:test:prepare
```
Run the test.
```
$ bundle exec rspec
```
I have achieved the 100% test coverage. To see the coverage the result open the ` coverage/index.html` file in your preferred browser.

# Available endpoints
As per the requirements here are some endpoints.
##### User authentication
#
| Action | HTTP Verb | PATH | Params |
| ------ | ------ | ----- | ---- |
| authenticate#login | POST | /api/v1/auth/login | email and password |

##### Apartment CRUD and Search
All endpoints for apartments will only work with adding the auth token in headers.
```
{ 'Authorization' => 'abcxyz123' }
```

| Action | HTTP Verb | PATH | Params |
| ------ | --------- | ----- | ---- |
| apartments#index | GET | /api/v1/apartments | Pagination and search params. For details please see below the table. |
| apartments#show | GET | /api/v1/apartments/:id | Apartment id |
| apartments#create | POST | /api/v1/apartments | Apartment attributes should be submitted. See the apartment model for required attributes. |
| apartments#update | PUT | /api/v1/apartments/:id | Id of the apartment that is going to be updated and attribute(s) that should be submitted. |
| apartments#destroy | DELETE | /api/v1/apartments/:id | Id of the apartment that is going to be deleted. |
**Pagination params**
Default page number and per page records are 1 and 10 respectively. We can pass the pagination params `page` and `per_page` to `index` action to set the page number and number of records on per page.
```
/api/v1/apartments?page=2&per_page=20
```
**Search params**
The `index` action is also responsible for filter records by params. Below are the valid params for searching.
- `apartment_type` for searching records by type of apartments like Residential, Condo, etc.
- `min_price` and `max_price` for searching records by given price range.
- `min_area` and `max_area` for searching records by given area sq feet range.

```
/api/v1/apartments?apartment_type=Condo
/api/v1/apartments?min_price=6000&max_price=10000
/api/v1/apartments?min_area=800&max_area=1150
```
Putting all together.
```
/api/v1/apartments?page=2&per_page=20&apartment_type=Condo&min_price=6000&max_price=10000&min_area=800&max_area=1150
```

# Thank you
Nitin Kumar Srivastava