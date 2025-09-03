Feature: Statistics Page

    Background:
        Given the app is running
        And I am logged in

    Scenario: Statistics page displays correctly
        When I tap {Icons.analytics} icon
        Then I see {'Hello World - Statistics'} text

    Scenario: Statistics tab is accessible from navigation
        When I tap {Icons.analytics} icon
        Then I see {'Statistics'} text
        And I see {Icons.analytics} icon