package javareflx.bri;

import java.util.List;

public class ServiceRegistry {
	// cette classe est un registre de services
	// partag�e en concurrence par les clients et les "ajouteurs" de services,
	// un Vector pour cette gestion est pratique

	static {
		servicesClasses = null;
	}
	private static List<Class<?>> servicesClasses;

// ajoute une classe de service apr�s contr�le de la norme BLTi
	public static void addService() {
		// v�rifier la conformit� par introspection
		// si non conforme --> exception avec message clair
		// si conforme, ajout au vector
	}
	
// renvoie la classe de service (numService -1)	
	public static void getServiceClass(int numService) {
		
	}
	
// liste les activit�s pr�sentes
	public static String staticToString() {
		String result = "Activit�s pr�sentes :##";
		// todo
		return result;
	}

}
