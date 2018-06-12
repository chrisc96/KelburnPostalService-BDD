package kps.stepdefinitions;
import cucumber.api.PendingException;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import kps.server.*;
import kps.server.logs.MailDelivery;
import kps.util.MailPriority;
import kps.util.RouteNotFoundException;
import kps.util.RouteType;
import org.junit.Assert;

import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.List;


public class MailSteps {

    private String fname = System.getProperty("os.name").contains("Windows") ? "NUL/" : "/dev/null";

    BusinessFigures figures = new BusinessFigures();
    KPSServer server = new KPSServer(fname, figures);

    // All mail should have these properties common, so lets define them and set them in steps definitions.
    double weight;
    double measure;
    String fromCity;
    String fromCountry;
    String toCity;
    String toCountry;
    MailPriority priorityType;
    double cost;

    @Given("^an initial map$")
    public void anInitialMap() throws Throwable {
        server.readInitialLog("data/data.xml");
    }

    @Given("^a parcel that weighs (\\d+)kg$")
    public void aParcelThatWeighsKg(int weight) {
        this.weight = weight;
    }

    @Given("^a parcel that measures (\\d+) cc$")
    public void aParcelThatMeasuresCc(int measure) {
        this.measure = measure / 1000;
    }

    @Given("^I send the parcel from \"([^\"]*)\" \"([^\"]*)\"$")
    public void iSendTheParcelFrom(String fromCity, String fromCountry) {
        this.fromCity = fromCity;
        this.fromCountry = fromCountry;
    }

    @Given("^I send the parcel to \"([^\"]*)\" \"([^\"]*)\"$")
    public void iSendTheParcelTo(String toCity, String toCountry) {
        this.toCity = toCity;
        this.toCountry = toCountry;
    }

    @And("^I send the parcel by \"([^\"]*)\"$")
    public void iSendTheParcelBy(String priority) throws Throwable {
        MailPriority type = MailPriority.fromString(priority);
        Assert.assertNotNull("MailPriority type is invalid", type);
        priorityType = type;
    }

    @Then("^the cost is \\$(\\d+)$")
    public void theCostIs$(double expectedCost) throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);
        MailDelivery mail = new MailDelivery(from, to, weight, measure, priorityType, DayOfWeek.MONDAY);

        double actual = server.getTransportMap().getTransportPrice(mail);

        String msg = "The expected cost was " + expectedCost + " but the actual cost was " + actual;
        Assert.assertTrue(msg, expectedCost == actual);
    }

    @Given("^a direct route \\(no hops\\) exists for this mail$")
    public void aDirectRouteWithNoHopsExists() {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);
        Mail mail = new Mail(to, from, priorityType, weight, measure);
        try {
            Assert.assertTrue("This route does not exist", server.getTransportMap().calculateRoute(mail).size() != 0);
            if (server.getTransportMap().calculateRoute(mail).size() > 1) {
                Assert.fail("This route has hops in between.");
            }
        }
        catch (RouteNotFoundException e) {
            Assert.fail("This route does not exist");
        }
    }

    @Then("^as part of this route I stop off in \"([^\"]*)\" \"([^\"]*)\"$")
    public void asPartOfThisRouteIStopOffIn(String city, String country) throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);
        Mail mail = new Mail(to, from, priorityType, weight, measure);
        List<TransportRoute> routes = server.getTransportMap().calculateRoute(mail);

        boolean foundIntermediatary = false;
        for (TransportRoute route: routes) {
            if (route.from.city.equals(city) && route.from.country.equals(country)) {
                foundIntermediatary = true;
            }
        }

        String msg = "This route doesn't go through " + city + " , " + country;
        Assert.assertTrue(msg, foundIntermediatary);
    }


    @Then("^does a route exist for this route$")
    public void doesARouteExistForThisRoute() throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);
        Mail mail = new Mail(to, from, priorityType, weight, measure);

        boolean routeExists;
        try {
            routeExists = server.getTransportMap().calculateRoute(mail).size() != 0;
        }
        catch (RouteNotFoundException | NullPointerException e) {
            routeExists = false;
        }
        String msg = "This route from " + fromCity + " to " + toCity + " doesn't exist";
        Assert.assertTrue(msg, routeExists);
    }

    @Then("^does a route not exist for this route$")
    public void doesARouteNottxistForThisRoute() throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);
        Mail mail = new Mail(to, from, priorityType, weight, measure);

        boolean routeDoesntExist = false;
        try {
            routeDoesntExist = server.getTransportMap().calculateRoute(mail).size() == 0;
        }
        // Null pointer thrown in calculate route - can't be a route.
        catch (NullPointerException e) {
            routeDoesntExist = true;
        }
        finally {
            String msg = "This route from " + fromCity + " to " + toCity + " does exist";
            Assert.assertTrue(msg, routeDoesntExist);
        }
    }

	@And("^\"([^\"]*)\" \"([^\"]*)\" distribution centre exists$")
	public void distributionCentreExists(String city, String country) {
        Destination to = new Destination(city, country);
        String msg = "The distribution centre " + city + ", " + country + " doesn't exist";
        Assert.assertNotNull(msg, server.getTransportMap().getDestination(to));
    }

    @And("^I want to send a parcel to the overseas country: \"([^\"]*)\"$")
    public void iWantToSendAParcelTo(String country) throws Throwable {
        toCountry = country;
    }


    @Then("^I should be only able to send it to one place$")
    public void iShouldBeOnlyAbleToSendItToOnePlace() throws Throwable {
        List<String> citiesInsideCountry = new ArrayList<>();
        for (TransportRoute route : server.getTransportRoutes()) {
            if (route.to.country.equalsIgnoreCase(toCountry)) {

                if (!citiesInsideCountry.contains(route.to.city)) {
                    citiesInsideCountry.add(route.to.city);
                }
            }
        }
        if (citiesInsideCountry.size() > 1) {
            Assert.fail("You can send a parcel to more than one port in this overseas country.");
        }
        else if (citiesInsideCountry.size() == 0) {
            Assert.fail("You can't send a parcel to this country at all.");
        }
    }

    @Given("^the mailing route returned is of type \"([^\"]*)\"$")
    public void theMailingRouteReturnedAreOfType(String priority) throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);
        Mail mail = new Mail(to, from, priorityType, weight, measure);

        // Null means land or sea. Otherwise it means air.
        RouteType typeToExpect = null;
        MailPriority type = MailPriority.fromString(priority);
        if (type == MailPriority.DOMESTIC_AIR || type == MailPriority.INTERNATIONAL_AIR) {
            typeToExpect = RouteType.AIR;
        }

        List<TransportRoute> routes = server.getTransportMap().calculateRoute(mail);
        TransportRoute route = routes.get(0);

        // Land or Sea
        if (route.getType() == RouteType.AIR) {
            if (typeToExpect == null) {
                Assert.fail("You requested to send by Land or Sea (Standard) but the route returned by the domain was by " + route.getType().toString().toLowerCase() + ". Probably a domain error.");
            }
        }
        // Air
        else if (route.getType() == RouteType.LAND || route.getType() == RouteType.SEA) {
            if (typeToExpect == RouteType.AIR) {
                Assert.fail("You requested to send by Air but the route returned by the domain was by " + route.getType().toString().toLowerCase() + ". Probably a domain error.");
            }
        }
    }

    @Then("^the expected cost should be one of \\$\"([^\"]*)\"$")
    public void theExpectedCostShouldBeOneOf$(String csvOfCosts) throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);
        MailDelivery mail = new MailDelivery(from, to, weight, measure, priorityType, DayOfWeek.MONDAY);

        double actual = server.getTransportMap().getTransportPrice(mail);

        List<Double> expectedCosts = new ArrayList<>();
        for (String str: csvOfCosts.split(",")) {
            try {
                expectedCosts.add(Double.parseDouble(str));
            }
            catch (NumberFormatException e) {}
        }

        boolean found = false;
        for (Double expected: expectedCosts) {
            if (actual == expected) {
                found = true;
            }
        }
        if (!found) {
            Assert.fail("The actual cost returned was " + actual + ". The expected costs were: " + expectedCosts.toString());
        }
    }

    @Given("^the mail is being sent from \"([^\"]*)\"$")
    public void theMailIsBeingSentFrom(String country) throws Throwable {
            Assert.assertTrue("Parcel is not being sent from New Zealand", this.fromCountry.equalsIgnoreCase(country));
    }

    @Then("^a route shouldn't exist for this mail$")
    public void aRouteShouldnTExistForThisMail() throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);
        Mail mail = new Mail(to, from, priorityType, weight, measure);

        boolean routeDoesntExist = false;
        List<TransportRoute> route = null;
        try {
            routeDoesntExist = (route = server.getTransportMap().calculateRoute(mail)).size() == 0;
        }
        catch (NullPointerException | RouteNotFoundException e) {
            routeDoesntExist = true;
        }
        finally {
            // If a route was returned
            if (route != null) {
                StringBuilder msg = new StringBuilder();
                if (weight > route.get(0).maxWeight) {
                    msg.append("We are overweight but the domain didn't care. It accepted the mail.\n");
                }
                if (measure > route.get(0).maxVolume) {
                    msg.append("We are oversized but the domain didn't care. It accepted the mail.\n");
                }
                System.out.println(msg.toString());
            }
            String msg = "This route from " + fromCity + " to " + toCity + " doesn't exist";
            Assert.assertFalse(msg, routeDoesntExist);
        }
    }
}