import wollok.game.*
import menu.*

object reloj {
	
	var property tiempo = 60
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		if (tiempo==0){
			gameOver.activar()
			self.detener()
		}else{
			tiempo = tiempo - 1
		}
	}
	method iniciar(){
		game.onTick(1000,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
	method sumarTiempo(cantidad){
		tiempo = tiempo + cantidad
	}
	method restarTiempo(cantidad){
		tiempo=(tiempo-cantidad).max(1)
	}
}

object digito0{
	method position()=game.at(0,19)
	method image(){
		return (reloj.tiempo().div(10)).toString()+".png"
	}
}
object digito1{
	method position()=game.at(1,19)
	method image(){
		return (reloj.tiempo()%10).toString()+".png"
	}
}
