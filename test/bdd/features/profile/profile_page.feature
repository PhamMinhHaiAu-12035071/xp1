Feature: Profile Page

    Background:
        Given the app is running
        And I am logged in

    Scenario: Profile page displays correctly
        When I tap {Icons.person} icon
        Then I see {'Hello World - Profile'} text

    Scenario: Profile tab is accessible from navigation
        When I tap {Icons.person} icon
        Then I see {'Profile'} text
        And I see {Icons.person} icon