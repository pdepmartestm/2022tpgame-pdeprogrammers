import wollok.game.*
import secuencia.*
import jugador.*
import menu.*
import reloj.*

class PowerUp{

	method aplicarPowerUp(){}

}

object aumentarTiempo inherits PowerUp{
	const segundos=[5,10,15]
	override method aplicarPowerUp(){
		reloj.sumarTiempo(segundos.anyOne())
	}
}

object reducirTiempo inherits PowerUp{
	const segundos=[5,10,15]
	override method aplicarPowerUp(){
		reloj.restarTiempo(segundos.anyOne())
	}
}

object aumentarVidas inherits PowerUp{
	override method aplicarPowerUp(){
		jugador.sumarVida()
	}
}

object reducirVidas inherits PowerUp{ 
	override method aplicarPowerUp(){
		jugador.restarVida()
	}
}

object reducirColores inherits PowerUp{
	override method aplicarPowerUp(){
		secuencia.reducirSecuencia()
	}
}

object system32 inherits PowerUp{
	override method aplicarPowerUp(){
		gameOver.activar()
	}
}

object aumentarColores inherits PowerUp{
	override method aplicarPowerUp(){
		secuencia.aumentarSecuencia()
	}
}
