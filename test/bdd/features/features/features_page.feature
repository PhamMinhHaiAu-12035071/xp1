Feature: Features Page

    Background:
        Given the app is running
        And I am logged in

    Scenario: Features page displays correctly
        When I tap {Icons.apps} icon
        Then I see {'Welcome to Features'} text

    Scenario: Features tab is accessible from navigation
        When I tap {Icons.apps} icon
        Then I see {'Features'} text
        And I see {Icons.apps} icon