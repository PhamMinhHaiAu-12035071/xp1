Feature: Attendance Page

    Background:
        Given the app is running
        And I am logged in

    Scenario: Attendance page displays correctly
        When I tap {Icons.access_time} icon
        Then I see {'Hello World - Attendance'} text

    Scenario: Attendance tab is accessible from navigation
        When I tap {Icons.access_time} icon
        Then I see {'Attendance'} text
        And I see {Icons.access_time} icon