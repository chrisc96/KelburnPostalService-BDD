package kps;
import cucumber.api.PendingException;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import kps.server.*;
import kps.util.MailPriority;
import kps.util.RouteNotFoundException;
import org.junit.Assert;


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
        Mail mail = new Mail(to, from, priorityType, weight, measure);

        TransportRoute route = server.getTransportMap().calculateRoute(mail).get(0);

        double actual = route.calculateCost(mail.weight, mail.volume);

        String msg = "The expected cost was " + expectedCost + " but the actual cost was " + actual;
        Assert.assertTrue(msg, expectedCost == actual);
    }

    @Then("^a route exists for this mail$")
    public void thisRouteExists() throws Throwable {
        Destination to = new Destination(toCity, toCountry);
        Destination from = new Destination(fromCity, fromCountry);
        Mail mail = new Mail(to, from, priorityType, weight, measure);
        Assert.assertTrue("This route does not exist", server.getTransportMap().calculateRoute(mail).size() != 0);
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
}