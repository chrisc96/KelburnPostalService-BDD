package kps;

import com.sun.scenario.effect.impl.sw.sse.SSEBlend_SRC_OUTPeer;
import cucumber.api.PendingException;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import kps.server.*;
import kps.server.logs.MailDelivery;
import kps.util.MailPriority;
import kps.util.RouteType;
import org.junit.Assert;

import java.time.DayOfWeek;
import java.util.List;

public class PrioritySteps {

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

	@Given("^an initial priority map$")
	public void anInitialPriorityMap() throws Throwable {
		server.readInitialLog("data/data.xml");
	}

	@Given("^a priority parcel that weighs (\\d+)kg$")
	public void aPriorityParcelThatWeighsKg(int weight) {
		this.weight = weight;
	}

	@Given("^a priority parcel that measures (\\d+)cc$")
	public void aPriorityParcelThatMeasuresCc(int measure) {
		this.measure = measure / 1000;
	}

	@Given("^I send the priority parcel from \"([^\"]*)\" \"([^\"]*)\"$")
	public void iSendThePriorityParcelFrom(String fromCity, String fromCountry) {
		this.fromCity = fromCity;
		this.fromCountry = fromCountry;
	}

	@Given("^I send the priority parcel to \"([^\"]*)\" \"([^\"]*)\"$")
	public void iSendThePriorityParcelTo(String toCity, String toCountry) {
		this.toCity = toCity;
		this.toCountry = toCountry;
	}

	@And("^I send the priority parcel by \"([^\"]*)\"$")
	public void iSendThePriorityParcelBy(String priority) throws Throwable {
		MailPriority type = MailPriority.fromString(priority);
		Assert.assertNotNull("MailPriority type is invalid", type);
		priorityType = type;
	}

	@Given("^the route exists$")
	public void theRouteExists() throws Throwable {
		Destination from = new Destination(fromCity, fromCountry);
		Destination to = new Destination(toCity, toCountry);
		Mail mail = new Mail(to, from, priorityType, weight, measure);
		Assert.assertTrue("This route does not exist", server.getTransportMap().calculateRoute(mail).size() != 0);
	}

	@Then("^the route returned is by air$")
	public void theRouteReturnedIsByAir() throws Throwable {
		Destination to = new Destination(toCity, toCountry);
		Destination from = new Destination(fromCity, fromCountry);
		Mail mail = new Mail(to, from, priorityType, weight, measure);

		// We assume that the route to use is the one at the front of the list
		TransportRoute route = server.getTransportMap().calculateRoute(mail).get(0);
		String msg = "The route returned is not by air! It's shipping by " + route.getType().toString().toLowerCase();
		Assert.assertTrue(msg, route.getType() == RouteType.AIR);
	}

	@Then("^the route returned is by land or sea$")
	public void theRouteReturnedIsByLandOrSea() throws Throwable {
		Destination to = new Destination(toCity, toCountry);
		Destination from = new Destination(fromCity, fromCountry);
		Mail mail = new Mail(to, from, priorityType, weight, measure);

		// We assume that the route to use is the one at the front of the list
		TransportRoute route = server.getTransportMap().calculateRoute(mail).get(0);
		String msg = "The route returned is not by land or sea! It's shipping by " + route.getType().toString().toLowerCase();
		Assert.assertTrue(msg, route.getType() == RouteType.LAND || route.getType() == RouteType.SEA);
	}

	@Given("^air is not the only option$")
	public void airIsNotTheOnlyOption() throws Throwable {
		Destination to = new Destination(toCity, toCountry);
		Destination from = new Destination(fromCity, fromCountry);
		Mail mail = new Mail(to, from, priorityType, weight, measure);

		List<TransportRoute> routes = server.getTransportMap().calculateRoute(mail);

		boolean notJustAir = false;
		// Go through all the possible routes
		for (TransportRoute route: routes) {
			if (route.getType() == RouteType.SEA || route.getType() == RouteType.LAND) {
				notJustAir = true;
				break;
			}
		}
		Assert.assertTrue("Air is the only option..", notJustAir);
	}

	@Then("^this costs the customer \\$(\\d+)")
	public void thisCostsTheCustomer(int cost) {
		Destination to = new Destination(toCity, toCountry);
		Destination from = new Destination(fromCity, fromCountry);

		MailDelivery delivery = new MailDelivery(from, to, weight, measure, priorityType, DayOfWeek.MONDAY);

		System.out.println(server.getTransportMap().getCustomerPrice(delivery));
	}


	@And("^I send the priority parcel by domestic air and domestic standard\"$")
	public void iSendThePriorityParcelByDomesticAirAndDomesticStandard() {
		// No point doing anything, syntactic sugar
	}

	@Then("^sending by domestic air and domestic standard costs the same price for the customer$")
	public void sendingByDomesticAirAndDomesticStandardCostsTheSamePriceForTheCustomer() throws Throwable {
		Destination to = new Destination(toCity, toCountry);
		Destination from = new Destination(fromCity, fromCountry);

		MailDelivery domesticStandard = new MailDelivery(from, to, weight, measure, MailPriority.DOMESTIC_STANDARD, DayOfWeek.MONDAY);
		MailDelivery domesticAir = new MailDelivery(from, to, weight, measure, MailPriority.DOMESTIC_AIR, DayOfWeek.MONDAY);

		double domesticStandardCost = server.getTransportMap().getCustomerPrice(domesticStandard);
		double domesticAirCost = server.getTransportMap().getCustomerPrice(domesticAir);
		System.out.println(domesticAirCost);
		System.out.println(domesticStandardCost);
		// Customer route must not exist
		if (domesticStandardCost == -1 || domesticAirCost == -1) {
			Assert.fail("Your data file must not have <price> entries for this path");
		}
		else {
			Assert.assertTrue("The price a customer is being charged is not the same", domesticStandardCost == domesticAirCost);
		}

	}
}