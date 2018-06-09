package kps;

import com.sun.scenario.effect.impl.sw.sse.SSEBlend_SRC_OUTPeer;
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

	MailDelivery air;
	MailDelivery standard;

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

		// Customer route must not exist
		if (domesticStandardCost == -1 || domesticAirCost == -1) {
			Assert.fail("Your data file must not have direct <price> entries for this path");
		}
		else {
			Assert.assertTrue("The price a customer is being charged is not the same", domesticStandardCost == domesticAirCost);
		}

	}

	@Then("^sending by air should cost more for the customer than standard$")
	public void sendingByAirShouldCostMoreForTheCustomerThanStandard() throws Throwable {
		double standardCost = server.getTransportMap().getCustomerPrice(standard);
		double airCost = server.getTransportMap().getCustomerPrice(air);

		String msg = "The cost of sending by air should've been more than standard. Air Cost: " + airCost + " Standard (land/sea) cost: " + standardCost;
		Assert.assertTrue(msg, airCost > standardCost);
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

	@Given("^the parcel is being sent from \"([^\"]*)\"$")
	public void theParcelIsBeingSentFrom(String country) throws Throwable {
		Assert.assertTrue("Parcel is not being sent from New Zealand", this.fromCountry.equalsIgnoreCase(country));
	}

	@But("^all my routes overseas must be done by \"([^\"]*)\"$")
	public void allMyRoutesOverseasMustBeDoneByAir(String arg0) {
		Destination to = new Destination(toCity, toCountry);
		Destination from = new Destination(fromCity, fromCountry);
		Mail mail = new Mail(to, from, priorityType, weight, measure);

		try {
			List<TransportRoute> routes = server.getTransportMap().calculateRoute(mail);

			boolean allAirOverseas = true;
			for (TransportRoute route : routes) {
				// If it's an overseas route, it must be by air
				if (!route.getTo().country.equalsIgnoreCase("New Zealand")) {
					if (route.getType() != RouteType.AIR) {
						allAirOverseas = false;
						break;
					}
				}
			}
			Assert.assertTrue("Part of the route overseas is not by air", allAirOverseas);
		}
		catch (RouteNotFoundException e) {
			String msg = "Part of your route in NZ must not be by Air";
			Assert.fail(msg);
		}
	}


	@Then("^all my routes domestically can be done by air, sea or land$")
	public void allMyRoutesDomesticallyCanBeDoneByAirSeaOrLand() throws Throwable {
		// Syntactic sugar, no point in testing as Land, Air or Sea are our only options in this implementation.
		Destination to = new Destination(toCity, toCountry);
		Destination from = new Destination(fromCity, fromCountry);
		Mail mail = new Mail(to, from, priorityType, weight, measure);

		// Currently unless all routes are by air for this test, this will throw an error
		try {
			server.getTransportMap().calculateRoute(mail);
		}
		catch (RouteNotFoundException e) {
			Assert.fail("In this current implementation, international air cannot be sent between distribution centres domestically via land or sea before sending overseas. Hence, failing");
		}
	}


	@But("^all my routes domestically must be done by \"([^\"]*)\"$")
	public void allMyRoutesDomesticallyMustBeDoneBy(String arg0) throws Throwable {
		Destination to = new Destination(toCity, toCountry);
		Destination from = new Destination(fromCity, fromCountry);
		Mail mail = new Mail(to, from, priorityType, weight, measure);

		try {
			List<TransportRoute> routes = server.getTransportMap().calculateRoute(mail);

			boolean allAirDomestic = true;
			for (TransportRoute route : routes) {
				// If it's an domestic route, it must be by air
				if (route.getTo().country.equalsIgnoreCase("New Zealand")) {
					if (route.getType() != RouteType.AIR) {
						allAirDomestic = false;
						break;
					}
				}
			}
			Assert.assertTrue("Part of the route domestically is not by air", allAirDomestic);
		}
		catch (RouteNotFoundException e) {
			// This throws on current implementation as mixed domestic aren't allowed for international air
			String msg = "Part of your route in NZ must not be by Air";
			Assert.fail(msg);
		}
	}
}