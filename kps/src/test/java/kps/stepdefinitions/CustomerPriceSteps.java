package kps.stepdefinitions;

import cucumber.api.PendingException;
import cucumber.api.java.en.And;
import cucumber.api.java.en.But;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import kps.server.*;
import kps.server.logs.MailDelivery;
import kps.util.MailPriority;
import kps.util.RouteNotFoundException;
import kps.util.RouteType;
import org.junit.Assert;

import java.time.DayOfWeek;
import java.util.List;

/**
 * Created by Chris on 11/06/2018.
 */
public class CustomerPriceSteps {

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

    MailDelivery standard;
    MailDelivery air;

    @Given("^an initial customer map$")
    public void anInitialCustomerMap() throws Throwable {
        server.readInitialLog("data/data.xml");
    }

    @Given("^a customer parcel that weighs (\\d+)kg$")
    public void aCustomerParcelThatWeighsKg(int weight) {
        this.weight = weight;
    }

    @Given("^a customer parcel that measures (\\d+)cc$")
    public void aCustomerParcelThatMeasuresCc(int measure) {
        this.measure = measure / 1000;
    }

    @Given("^I send the customer parcel from \"([^\"]*)\" \"([^\"]*)\"$")
    public void iSendTheCustomerParcelFrom(String fromCity, String fromCountry) {
        this.fromCity = fromCity;
        this.fromCountry = fromCountry;
    }

    @Given("^I send the customer parcel to \"([^\"]*)\" \"([^\"]*)\"$")
    public void iSendTheCustomerParcelTo(String toCity, String toCountry) {
        this.toCity = toCity;
        this.toCountry = toCountry;
    }

    @And("^I send the customer parcel by \"([^\"]*)\"$")
    public void iSendTheCustomerParcelBy(String priority) throws Throwable {
        MailPriority type = MailPriority.fromString(priority);
        Assert.assertNotNull("MailPriority type is invalid", type);
        priorityType = type;
    }


    @Then("^this parcel costs the customer \\$(\\d+)")
    public void thisCostsTheCustomer(int cost) {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);

        MailDelivery delivery = new MailDelivery(from, to, weight, measure, priorityType, DayOfWeek.MONDAY);

        double actual = server.getTransportMap().getCustomerPrice(delivery);
        CustomerRoute route = server.getTransportMap().getCustomerRoute(delivery);

        String msg = (actual == -1) ? "There is no customer price for this route" : "The actual cost was $" + actual + " but the expected cost was $" + cost + ". " +
                                                                                    "The volume cost for this route was " +  route.volumeToCost +
                                                                                    " and the weight cost was " + route.weightToCost;
        Assert.assertTrue(msg, actual == cost);
    }

    @Given("^the parcel is sent only within New Zealand$")
    public void theParcelIsSentOnlyWithinNewZealand() throws Throwable {
        Assert.assertTrue("You are not sending this customer parcel from New Zealand", this.fromCountry.equalsIgnoreCase("New Zealand"));
        Assert.assertTrue("You are not sending this customer parcel to New Zealand", this.toCountry.equalsIgnoreCase("New Zealand"));
    }

    @Then("^sending by domestic air and domestic standard costs the same price for the customer$")
    public void sendingByDomesticAirAndDomesticStandardCostsTheSamePriceForTheCustomer() throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);

        MailDelivery domesticStandard = new MailDelivery(from, to, weight, measure, MailPriority.DOMESTIC_STANDARD, DayOfWeek.MONDAY);
        MailDelivery domesticAir = new MailDelivery(from, to, weight, measure, MailPriority.DOMESTIC_AIR, DayOfWeek.MONDAY);

        double domesticStandardCost = server.getTransportMap().getCustomerPrice(domesticStandard);
        double domesticAirCost = server.getTransportMap().getCustomerPrice(domesticAir);

        Assert.assertTrue("The price a customer is being charged is not the same", domesticStandardCost == domesticAirCost);
    }

    @Given("^domestic air and domestic standard routes both exist$")
    public void domesticAirAndDomesticStandardRoutesBothExist() throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);

        MailDelivery domesticStandard = new MailDelivery(from, to, weight, measure, MailPriority.DOMESTIC_STANDARD, DayOfWeek.MONDAY);
        MailDelivery domesticAir = new MailDelivery(from, to, weight, measure, MailPriority.DOMESTIC_AIR, DayOfWeek.MONDAY);

        double domesticStandardCost = server.getTransportMap().getCustomerPrice(domesticStandard);
        double domesticAirCost = server.getTransportMap().getCustomerPrice(domesticAir);

        // Customer route must not exist
        if (domesticStandardCost == -1) {
            Assert.fail("There is no direct domestic standard transport method for this route");
        }
        if (domesticAirCost == -1) {
            Assert.fail("There is no direct domestic air transport method for this route");
        }
    }

    @Given("^a direct customer cost route exists for both priority types$")
    public void aDirectCustomerCostRouteExistsForBothPriorityTypes() throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);

        MailDelivery domesticStandard = new MailDelivery(from, to, weight, measure, MailPriority.DOMESTIC_STANDARD, DayOfWeek.MONDAY);
        MailDelivery domesticAir = new MailDelivery(from, to, weight, measure, MailPriority.DOMESTIC_AIR, DayOfWeek.MONDAY);

        double domesticStandardCost = server.getTransportMap().getCustomerPrice(domesticStandard);
        double domesticAirCost = server.getTransportMap().getCustomerPrice(domesticAir);

        if (domesticStandardCost == -1 || domesticAirCost == -1) {
            Assert.fail("Your data file must not have direct <price> entries for this path with both air and standard types");
        }
    }

    @And("^I send the priority parcel by \"([^\"]*)\" air and \"([^\"]*)\" standard\"$")
    public void iSendThePriorityParcelByAirAndStandard(String domesticOrIntl, String domesticOrIntlSame) throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);

        MailPriority air = MailPriority.fromString(domesticOrIntl + " air");
        MailPriority standard = MailPriority.fromString(domesticOrIntl + " standard");

        this.standard = new MailDelivery(from, to, weight, measure, standard, DayOfWeek.MONDAY);
        this.air = new MailDelivery(from, to, weight, measure, air, DayOfWeek.MONDAY);
    }

    @Then("^sending by air should cost more for the customer than standard$")
    public void sendingByAirShouldCostMoreForTheCustomerThanStandard() throws Throwable {
        double standardCost = server.getTransportMap().getCustomerPrice(standard);
        double airCost = server.getTransportMap().getCustomerPrice(air);

        String msg = "The cost of sending by air should've been more than standard. Air Cost: " + airCost + " Standard (land/sea) cost: " + standardCost;
        Assert.assertTrue(msg, airCost > standardCost);
    }
}