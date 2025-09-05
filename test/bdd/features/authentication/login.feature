Feature: Login

    Background:
        Given the app is running

    Scenario: App starts with login page
        Then I see {'Login'} text
        And I see {'Welcome to Login'} text
        And I see {'Login'} button

    Scenario: Login button navigates to main app
        When I tap {'Login'} button
        Then I see {'Home'} text
