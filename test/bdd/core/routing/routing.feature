Feature: App Routing

    Scenario: App starts with login route
        Given the app is running
        Then I see {'Login'} text
        And I see {'Welcome to Login'} text
        And I see {'Login'} button

    Scenario: Login navigates to main app wrapper
        Given the app is running
        When I tap {'Login'} button
        Then I see {'Home'} text
        And I see {Icons.home} icon
        And I see {Icons.analytics} icon
        And I see {Icons.access_time} icon
        And I see {Icons.apps} icon
        And I see {Icons.person} icon

    Scenario: Route replacement shows home page content
        Given the app is running
        When I tap {'Login'} button
        Then I see {'Welcome to Home'} text