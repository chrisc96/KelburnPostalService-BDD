package kps.stepdefinitions;

import cucumber.api.PendingException;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import kps.server.*;
import kps.server.logs.CustomerCostUpdate;
import kps.server.logs.MailDelivery;
import kps.util.MailPriority;
import org.junit.Assert;

import java.time.DayOfWeek;

public class CustomerPriceUpdateSteps {

    private String fname = System.getProperty("os.name").contains("Windows") ? "NUL/" : "/dev/null";

    BusinessFigures figures = new BusinessFigures();
    KPSServer server = new KPSServer(fname, figures);

    // Mailing values
    double weight;
    double volume;
    String fromCity;
    String fromCountry;
    String toCity;
    String toCountry;
    MailPriority priority;

    // Price update values
    double oldPricePerGram;
    double oldPricePerCC;
    double newPricePerGram;
    double newPricePerCC;


    @Given("^an initial customer price map$")
    public void anInitialCustomerPriceMap() throws Throwable {
        server.readInitialLog("data/data.xml");
    }

    @And("^I want to change the pricing of a direct customer route$")
    public void iWantToChangeThePricingOfADirectCustomerRoute() throws Throwable {
        // Syntactic sugar
    }

    @And("^that route comes from \"([^\"]*)\", \"([^\"]*)\"$")
    public void thatRouteComesFrom(String fromCity, String fromCountry) throws Throwable {
        this.fromCity = fromCity;
        this.fromCountry = fromCountry;
    }

    @And("^that route goes to \"([^\"]*)\", \"([^\"]*)\"$")
    public void thatRouteGoesTo(String toCity, String toCountry) throws Throwable {
        this.toCity = toCity;
        this.toCountry = toCountry;
    }

    @Given("^this direct pricing route exists$")
    public void thisDirectPricingRouteExists() throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);

        MailDelivery customerRoute = new MailDelivery(from, to, weight, volume, priority, DayOfWeek.MONDAY);

        double cost = server.getTransportMap().getCustomerPrice(customerRoute);

        if (cost == -1) {
            Assert.fail("Your data file must not have <price> entries for this direct route");
        }
    }

    @And("^that route is being sent by \"([^\"]*)\" priority$")
    public void thatRouteIsBeingSentByPriority(String priority) throws Throwable {
        this.priority = MailPriority.fromString(priority);
    }

    @Then("^store the old prices$")
    public void storeTheOldPrices() throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);

        MailDelivery customer = new MailDelivery(from, to, weight, volume, priority, DayOfWeek.MONDAY);
        CustomerRoute customerRoute = server.getTransportMap().getCustomerRoute(customer);

        Assert.assertNotNull("There is no customer route for this path", customerRoute);

        oldPricePerGram = customerRoute.weightToCost * 1000; // Convert between data files Kilogram to Gram
        oldPricePerCC = customerRoute.volumeToCost * 1000; // Convert between data files Litre value to Cubic Centimeters
    }

    @Then("^apply the new prices to the system$")
    public void applyTheNewPricesToTheSystem() throws Throwable {
        Destination from = new Destination(fromCity, fromCountry);
        Destination to = new Destination(toCity, toCountry);

        double newPricePerKg = newPricePerGram / 1000;      // Working on assumption that the data files store in Kg
        double newPricePerLitre = newPricePerCC / 1000;     // Working on assumption that the data files store in Litres

        CustomerCostUpdate update = new CustomerCostUpdate(from, to, priority,newPricePerKg,newPricePerLitre);

        server.getTransportMap().apply(update);
    }

    @Then("^try to get the new customer pricing route$")
    public void checkTheOldRouteNoLongerExists() throws Throwable {
        Destination from = new Destination(fromCity, fromCountry);
        Destination to = new Destination(toCity, toCountry);

        double newPricePerKg = newPricePerGram / 1000;      // Working on assumption that the data files store in Kg
        double newPricePerLitre = newPricePerCC / 1000;     // Working on assumption that the data files store in Litres

        CustomerCostUpdate update = new CustomerCostUpdate(from, to, priority, newPricePerKg, newPricePerLitre);
        CustomerRoute route = server.getTransportMap().getCustomerRoute(update);

        String errMsg =     "The customer route returned is not the same.\nThe route returned is from: " + route.from + " and to " + route.to + ".\n" +
                            "It's volumecost (in cc) is: " + route.volumeToCost * 1000 + " and it's weightcost (in gram) is: " + route.weightToCost * 1000;

        Assert.assertTrue(errMsg, route.volumeToCost == newPricePerLitre && route.weightToCost == newPricePerKg &&
                                            route.to.equals(to) && route.from.equals(from) && route.priority == priority);
    }

    @Then("^check the old customer route doesn't exist anymore$")
    public void checkTheOldCustomerRouteDoesnTExistAnymore() throws Throwable {
        Destination from = new Destination(fromCity, fromCountry);
        Destination to = new Destination(toCity, toCountry);

        double oldPricePerKg = oldPricePerGram / 1000;      // Working on assumption that the data files store in Kg
        double oldPricePerLitre = oldPricePerCC / 1000;     // Working on assumption that the data files store in Litres

        CustomerCostUpdate update = new CustomerCostUpdate(from, to, priority, oldPricePerKg, oldPricePerLitre);
        CustomerRoute route = server.getTransportMap().getCustomerRoute(update);

        boolean routeStillExists = route != null;
        if (routeStillExists) {
            // Checks if the values inside this route have been updated
            routeStillExists = (route.volumeToCost == oldPricePerLitre && route.weightToCost == oldPricePerKg &&
                                route.to.equals(to) && route.from.equals(from) && route.priority == priority);
        }

        Assert.assertFalse("The old customer price route is still in the system, therefore it could still be used to send mail.", routeStillExists);
    }

    @Then("^store the new prices where the newPricePerCC is (\\d+) and the newPricePerGram is (\\d+)$")
    public void storeTheNewPricesWhereTheNewPricePerCCIsNewPricePerCCAndTheNewPricePerGramIsNewPricePerGram(double newPricePerCC, double newPricePerGram) throws Throwable {
        if (oldPricePerCC == newPricePerCC ) Assert.fail("The new price per cubic centimeter should be different to the current price per cubic centimeter");
        this.newPricePerCC = newPricePerCC;
        if (oldPricePerGram == newPricePerGram) Assert.fail("The new price per gram should be different to the current price per gram");
        this.newPricePerGram = newPricePerGram;
    }

    @Given("^the customer parcel is being sent from \"([^\"]*)\"$")
    public void theParcelIsBeingSentFrom(String country) throws Throwable {
        Assert.assertTrue("Parcel is not being sent from New Zealand", this.fromCountry.equalsIgnoreCase(country));
    }

    @Given("^I want to send a parcel with a weight of (\\d+)kg$")
    public void iWantToSendAParcelWithAWeightOfWeightKg(double weight) throws Throwable {
        this.weight = weight;
    }

    @Given("^I want to send a parcel with a volume of (\\d+)cc$")
    public void iWantToSendAParcelWithAVolumeOfMeasurementCc(double volume) throws Throwable {
        this.volume = volume / 1000;
    }

    @And("^try send the mail and check if the route used is correct$")
    public void trySendTheMailAndCheckIfTheRouteUsedIsCorrect() throws Throwable {
        Destination from = new Destination(fromCity, fromCountry);
        Destination to = new Destination(toCity, toCountry);

        double newPricePerKg = newPricePerGram / 1000;      // Working on assumption that the data files store in Kg
        double newPricePerLitre = newPricePerCC / 1000;     // Working on assumption that the data files store in Litres

        // Get route after update, see if it's the new one
        MailDelivery mail = new MailDelivery(from, to, weight, volume, priority, DayOfWeek.MONDAY);
        CustomerRoute route = server.getTransportMap().getCustomerRoute(mail);

        Assert.assertTrue("Route used isn't correct as it doesn't match the details of the updated price for the customer", route.volumeToCost == newPricePerLitre && route.weightToCost == newPricePerKg &&
                route.to.equals(to) && route.from.equals(from) && route.priority == priority);
    }
}