Feature: Home Page

    Background:
        Given the app is running
        And I am logged in

    Scenario: Home page displays by default after login
        Then I see {'Hello World - Home'} text

    Scenario: Home page is accessible via bottom navigation
        Then I see {'Home'} text
        And I see {Icons.home} icon
        And I see {'Statistics'} text
        And I see {'Attendance'} text
        And I see {'Features'} text
        And I see {'Profile'} text