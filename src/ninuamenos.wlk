class Agresion{
	var lugar
	var autor
	var palabrasUsadas = []
	var palabrasInaceptables = ["perra","rapida"]
	method esGrave() =
		palabrasUsadas.any({palabra => palabrasInaceptables.contains(palabra)})
	method esFisica() = false
	method esIgnea() =
		palabrasUsadas.contains("fuego")
		
	method autor() = autor
}

class AgresionFisica inherits Agresion{
	var elementoUsado
	override method esFisica() = true
	override method esGrave() = true
	override method esIgnea() = elementoUsado == "combustible" || super()
	
	
}

class Persona{
	var actitud
	var agresiones = []
	var familiares = []
	method esFamiliar(nombre) = familiares.contains(nombre)
	method haceDenuncia(agresion) =
		agresion.esGrave() && 
		self.esFamiliar(agresion.autor()) &&
		actitud.haceDenuncia(agresion, self)
	method recordarAgresion(agresion) {
		agresiones.add(agresion)
	}
	method cantAgresionesDe(nombre) = 
		agresiones.count({agresion => agresion.autor() == nombre})
	
	method agresionesGraves() = agresiones.filter({agresion => agresion.esGrave()})
	method agredidoGravementePorFamiliar() = 	
		self.agresionesGraves().any({agresion => self.esFamiliar(agresion.autor())})
	
	method recibirAgresion(agresion) {
		self.recordarAgresion(agresion)
		if (self.haceDenuncia(agresion) ){
			policia.recibeDenuncia(agresion)
		}
	}
	
}

class Denuncia{
	var hecho
	var nroActa
	constructor (_hecho, _nroActa){
		hecho = _hecho
		nroActa = _nroActa
	}
}

object miedoso{
	method haceDenuncia(agresion, persona) = false
}


class Paciente{
	var umbral
	constructor (_umbral){
		umbral = _umbral
	}
	method haceDenuncia(agresion, persona) = 
		 persona.cantAgresionesDe(agresion.autor()) < umbral
}

object aguerrido{
	method haceDenuncia(agresion, persona) = persona.agredidoGravementePorFamiliar()
}

object militante{
	method haceDenuncia(agresion, persona) = true
}

object policia{
	var denuncias = []
	method recibeDenuncia(hecho) {
		denuncias.add(new Denuncia(hecho, denuncias.size() + 1))
	}
	
}


