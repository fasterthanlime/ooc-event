import net/ServerSocket, Event

{
    s := ServerSocket new("0.0.0.0", 8080)
    s listen()
    s setReuseAddr(true)
   
    base := EventBase new()
    event := Event new()
    event set(s descriptor, Event READ | Event PERSIST, |fd, ev|
	"Accepted connection! Yeepee." println()
    )
    base set(event&)
    event add()

    base dispatch()
}
