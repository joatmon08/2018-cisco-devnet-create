Feature: Add a container network to switch

    Scenario: Route container network
        Given I have a gateway to my datacenter
        When I create a container network named devnet with subnet 172.19.0.0/16
        Then I should set up a route from that network to my datacenter
