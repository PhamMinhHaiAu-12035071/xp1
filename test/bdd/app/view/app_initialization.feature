Feature: App Initialization

    Scenario: App starts successfully
        Given the app is running
        Then I see {'Login'} text
        And I see {'Welcome to Login'} text

    Scenario: App displays login page on startup
        Given the app is running
        Then I see {'Login'} button

    Scenario: App has proper initial state
        Given the app is running
        Then I see {'Login'} text
        And I see {'Login'} button